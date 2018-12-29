/**
 -  EKSettingViewController.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/7.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是从"个人中心"界面进入的"设置"界面
 */

#import "EKSettingViewController.h"
#import "EKSettingSwitchCell.h"
#import "EKSettingNormalCell.h"
#import "EKSettingCellModel.h"
#import "EKSettingLogoutFooterView.h"
#import "BKUserHelper.h"
#import "AppDelegate.h"
#import "EKLoginPresenter.h"
#import "BKUserModel.h"
#import "BKUserHelper.h"
#import "BKLGActionSheet.h"
#import "BTextKit.h"

@interface EKSettingViewController () <UITableViewDelegate,
                                       UITableViewDataSource,
                                       EKSettingSwitchCellDelegate,
                                       EKSettingLogoutFooterViewDelegate,
                                       UIActionSheetDelegate>
//主体的tableView
@property (nonatomic, strong) UITableView *vTableView;
//包含cell信息的数据源数组(本地生成)
@property (nonatomic, strong) NSArray <NSArray <EKSettingCellModel *> *> *vSettingCellModelArray;
//记录"消息提醒"开关状态
@property (nonatomic, assign) BOOL vIsSwitchOn;
@end

@implementation EKSettingViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDeviceTokenNotification object:nil];
}

#pragma mark - 初始化UI
- (void)mInitUI {
    self.title = @"設置";
    self.view.backgroundColor = [UIColor EKColorBackground];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self mInitTableView];
}


//设置tableView
- (void)mInitTableView {
    _vTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _vTableView.backgroundColor = [UIColor EKColorBackground];
    [self.view addSubview:_vTableView];
    [_vTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAV_BAR_HEIGHT);
    }];
    _vTableView.dataSource = self;
    _vTableView.delegate = self;
    _vTableView.separatorColor = [UIColor EKColorSeperateWhite];
    CGFloat tableViewRowHeight = 43;
    _vTableView.rowHeight = tableViewRowHeight;
    [_vTableView registerClass:[EKSettingNormalCell class] forCellReuseIdentifier:settingNormalCell];
    [_vTableView registerClass:[EKSettingSwitchCell class] forCellReuseIdentifier:settingSwitchCellID];
    
    _vTableView.estimatedRowHeight = 0;
    _vTableView.estimatedSectionFooterHeight = 0;
    _vTableView.estimatedSectionHeaderHeight = 0;
    
    //设置tableView底部视图.登录时才显示
    if (LOGINSTATUS) {
        EKSettingLogoutFooterView *footerView = [[EKSettingLogoutFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, tableViewRowHeight)];
        footerView.vDelegate = self;
        _vTableView.tableFooterView = footerView;
    }
}


#pragma mark - 初始化数据
- (void)mInitData {
    _vSettingCellModelArray = [EKSettingCellModel mGetSettingCellModelArray];
    [self mSetSwitchState];
    [_vTableView reloadData];
}


//设置switch开关状态的值
- (void)mSetSwitchState {
    if (iOS8) {
        _vIsSwitchOn = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    } else {
        //用本地保存的数据判断
        NSString *defRemoteNoticePower = [BKSaveData getString:kNotificationsSwitchKey];
        //没有设置过推送开关，或者推送设置已经打开
        if (!defRemoteNoticePower || [defRemoteNoticePower isEqualToString:@"1"]) {
            _vIsSwitchOn = YES;
        } else {
            _vIsSwitchOn = NO;
        }
    }
}


#pragma mark - UITableViewDataSource
//返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _vSettingCellModelArray.count;
}

//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _vSettingCellModelArray[section].count;
}


//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EKSettingCellModel *model = _vSettingCellModelArray[indexPath.section][indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.vReuseIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0 && indexPath.row == 0) {
        EKSettingSwitchCell *switchCell = (EKSettingSwitchCell *)cell;
        switchCell.vDelegate = self;
        switchCell.vIsSwitchOn = _vIsSwitchOn;
    } else {
        EKSettingNormalCell *normalCell = (EKSettingNormalCell *)cell;
        normalCell.detailTextLabel.text = model.vDetailText;
    }
    cell.textLabel.text = model.vTitle;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor EKColorTitleBlack];
    cell.detailTextLabel.textColor = [UIColor EKColorTitleBlack];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}


#pragma mark - UITableViewDelegate
//点击cell时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //从数组中获取要执行的方法名
    NSString *selectorName = _vSettingCellModelArray[indexPath.section][indexPath.row].vSelectorName;
    if (!selectorName) {
        return;
    }
    SEL selector = NSSelectorFromString(selectorName);
    IMP imp = [self methodForSelector:selector];
    void (*func)(id, SEL) = (void *)imp;
    func(self, selector);
}


//返回tableView组头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}


//返回组尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 14;
}


#pragma mark - 点击cell之后调用的方法
//点击"默认排序"
- (void)mSetRank {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"順序",@"倒序", nil];
    [actionSheet showInView:self.view];
}


//点击"默认文字大小"
- (void)mSetFont {
    [BKLGActionSheet showActionSheet:self type:InvitationDetailType defSize:[BKSaveData getInteger:kTopicDetailFontSizeKey]];
}


//点击"清理缓存"
- (void)mClearCache {
    //清理缓存
    [[SDImageCache sharedImageCache] clearMemory];//清除内存缓存图片
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];//清除磁盘缓存图片
    [self.view showHUDActivityView:@"正在清理" shade:NO];
    //清理缓存实际没什么效果，帖子中的图片缓存一般都会定期清理
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view removeHUDActivity];
        [BTextKit cleanImageData];//清除工程中帖子详情中图片缓存
        [self.view showSuccess:@"清理完成"];
    });
}


//点击"关于我们"
- (void)mPushToAboutUsViewController {
    [super showNextViewControllerName:@"EKAboutUsViewController" params:nil isPush:YES];
}


#pragma mark - EKSettingSwitchCellDelegate
//回传开关的开关值
- (void)mSettingSwitchCellSwitchIsOn:(BOOL)isOn {
    if (isOn) {
        //打开推送
        [BKSaveData setString:@"1" key:kNotificationsSwitchKey];
        [[AppDelegate share] registerNotification];
        
        //添加观察者，打开推送，在appdelegate中新的推送token生成后，要重新发送给后台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mNotifyOpen) name:kDeviceTokenNotification object:nil];
    } else {
        //关闭推送
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        [BKSaveData setString:@"0" key:kNotificationsSwitchKey];
    }
}


//重新向后台发送新的推送id
- (void)mNotifyOpen {
    //重新向后台发送新的推送id
    NSString *userName = USER.username;
    NSString *pawskey = [BKSaveData getString:kUserPasswordIndexKey];
    NSString *password = [AESCrypt decrypt:pawskey password:kUserPasswordKey];
    NSString *deviceToken = [BKSaveData getString:kDeviceTokenKey];
    DLog(@"deviceToken : %@",deviceToken);
    NSDictionary *parameter = @{@"username" : userName,
                                @"password" : password,
                                @"deviceID" : deviceToken ? deviceToken : @""
                                };
    [self.view showHUDActivityView:kStartLoadingText shade:NO];
    [EKHttpUtil mHttpWithUrl:kLoginURL parameter:parameter response:^(BKNetworkModel *model, NSString *netErr) {
        [self.view removeHUDActivity];
        if (netErr) {
            [self.view showHUDTitleView:netErr image:nil];
        } else {
            if (1 == model.status) {
                //保存用户对象
                if (model.data && [model.data isKindOfClass:[NSDictionary class]]) {
                    BKUserModel *userModel = [BKUserModel yy_modelWithDictionary:model.data];
                    [BKSaveUser mSaveUser:userModel];
                }
            }
        }
    }];
}


#pragma mark - EKSettingLogoutFooterViewDelegate
//点击登出按钮的时候调用
- (void)mLogoutButtonDidClick {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"溫馨提示"
                                                                       message:@"是否退出當前賬戶"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self.view showHUDActivityView:kStartLoadingText shade:NO];
            [BKUserModel mLogOutWithCallBack:^(NSString *netErr) {
                [self.view removeHUDActivity];
                if (netErr) {
                    [self.view showError:netErr];
                } else {
                    //统计
                    NSString *googleString = [NSString stringWithFormat:@"uid=%@", USERID];
                    NSDictionary *parameter = @{@"uid": USERID};
                    [super mAddAnalyticsWithPageIndex:kLoginOutPageIndex googleString:googleString parameter:parameter];
                    //返回到上一级界面
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - UIActionSheetDelegate
//默认排序弹窗代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex < 2) {
        [BKSaveData setInteger:buttonIndex key:kTopicDetailOrderKey];
        [self mInitData];
    }
}


#pragma mark - 字号弹窗的回调方法
- (void)actionSheet:(LGActionSheet *)actionSheet buttonPressedWithTitle:(NSString *)title index:(NSUInteger)index {
    //改变帖子文字字号
    //2 表示大号
    //0 表示中号
    //1 表示小号
    NSArray <NSNumber *> *fontSizeArray = @[@(2), @(0), @(1)];
    [BKSaveData setInteger:fontSizeArray[index].integerValue key:kTopicDetailFontSizeKey];
    [self mInitData];
}


@end
