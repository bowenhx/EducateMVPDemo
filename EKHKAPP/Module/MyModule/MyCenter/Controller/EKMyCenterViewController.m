/**
 -  EKMyCenterViewController.m
 -  EKHKAPP
 -  Created by HY on 2017/9/7.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：这是tabBar标签栏的最后一个控制器--"个人中心"
 */

#import "EKMyCenterViewController.h"
#import "EKLoginViewController.h"
#import "BKUserHelper.h"
#import "EKMyCenterInformationCell.h"
#import "EKMyCenterListCell.h"
#import "EKMyCenterListModel.h"
#import "EKMyCenterUploadAvatarAlertController.h"
#import "MBProgressPercentHUD.h"
#import "EKMyThemeViewController.h"
#import "EKMyCenterNoLoginCell.h"
#import "EKLoginViewController.h"
#import "EKBasicInformationViewController.h"
#import "MyBlogViewController.h"

@interface EKMyCenterViewController () <UITableViewDataSource,
                                        UITableViewDelegate,
                                        EKMyCenterBaseCellDelegate,
                                        EKMyCenterUploadAvatarAlertControllerDelegate,
                                        UINavigationControllerDelegate,
                                        UIImagePickerControllerDelegate>
//主体的tableView
@property (strong, nonatomic) UITableView *vTableView;
//包含cell信息的数据源数组
@property (strong, nonatomic) NSArray <NSArray <EKMyCenterListModel *> *> *vMyCenterListModelArray;
//用来记录是否需要隐藏未读小红点,YES代表需要隐藏
@property (nonatomic, assign) BOOL vIsHideRedBadge;
@end

@implementation EKMyCenterViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //广告
    [self mRequestPopupView:BOTTOM_TABBAR_HEIGHT];
    [self mRequestInterstitialView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //监听用户登录成功&登出成功的通知,以更新页面数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mInitData) name:kLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mInitData) name:kQuitLoginNotifation object:nil];
    
    //获取本地保存的程序一启动时从后台获取到的是否有未读消息的BOOL值,YES的话表示要隐藏小红点
    _vIsHideRedBadge = [BKSaveData getBool:kUnreadMessageCountKey];
    //监听是否有新消息的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mShowRedBadge) name:kRemotePushNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mHideRedBadge) name:kNoRemotePushNotification object:nil];
}


- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kQuitLoginNotifation object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRemotePushNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNoRemotePushNotification object:nil];
}


#pragma mark - 初始化UI
- (void)mInitUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor EKColorBackground];
    //实例化tableView
    _vTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _vTableView.tableFooterView = [[UIView alloc] init];
    _vTableView.delegate = self;
    _vTableView.dataSource = self;
    _vTableView.backgroundColor = [UIColor EKColorBackground];
    _vTableView.separatorColor = [UIColor EKColorSeperateWhite];
    [self.view addSubview:_vTableView];
    [_vTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAV_BAR_HEIGHT);
    }];
    //要设置内缩,要不然老是向下偏移,原因不明
    _vTableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    
    //注册cell
    //顶部显示用户信息的cell
    UINib *informationCellNib = [UINib nibWithNibName:@"EKMyCenterInformationCell" bundle:nil];
    [_vTableView registerNib:informationCellNib forCellReuseIdentifier:myCenterInformationCellID];
    //未登录时的顶部cell
    UINib *noLoginCellNib = [UINib nibWithNibName:@"EKMyCenterNoLoginCell" bundle:nil];
    [_vTableView registerNib:noLoginCellNib forCellReuseIdentifier:myCenterNoLoginCellID];
    //下面的普通常规cell
    UINib *listCellNib = [UINib nibWithNibName:@"EKMyCenterListCell" bundle:nil];
    [_vTableView registerNib:listCellNib forCellReuseIdentifier:myCenterListCellID];
    
    _vTableView.estimatedRowHeight = 0;
    _vTableView.estimatedSectionFooterHeight = 0;
    _vTableView.estimatedSectionHeaderHeight = 0;
}


#pragma mark - 初始化数据
- (void)mInitData {
    //获取到包含cell信息的model数组(本地数据)
    _vMyCenterListModelArray = [EKMyCenterListModel mGetMyCenterListModelArray];
    [_vTableView reloadData];
    if (!LOGINSTATUS) {
        return;
    }
    
    //获取到用户基本资料model
    [EKBasicInformationModel mRequestBasicInformationModelWithCallBack:^(NSString *netErr, EKBasicInformationModel *basicInformationModel) {
        if (netErr) {
            [self.view showError:netErr];
        } else {
            _vMyCenterListModelArray.firstObject.firstObject.vBasicInformationModel = basicInformationModel;
            //更新第0个cell的UI
            [_vTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}


#pragma mark - UITableViewDataSource
//返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _vMyCenterListModelArray.count;
}


//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _vMyCenterListModelArray[section].count;
}


//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取cell的缓存标识符
    NSString *reuseIdentifier = _vMyCenterListModelArray[indexPath.section][indexPath.row].vReuseIdentifier;
    //生成cell
    EKMyCenterBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.vMyCenterListModel = _vMyCenterListModelArray[indexPath.section][indexPath.row];
    cell.vDelegate = self;
    //单独对第0个cell的小红点做一下显示与否的处理
    if (indexPath.section == 0) {
        cell.vIsHideRedBadge = _vIsHideRedBadge;
    }
    return cell;
}


#pragma mark - UITableViewDelegate
//返回行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _vMyCenterListModelArray[indexPath.section][indexPath.row].vCellHeight;
}


//cell点击时候调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //获取到要跳转到的控制器的名字
    NSString *controllerName = _vMyCenterListModelArray[indexPath.section][indexPath.row].vControllerName;
    //有无登录,都可以跳转到"设置"界面
    if ([controllerName isEqualToString:@"EKSettingViewController"]) {
        [super showNextViewControllerName:controllerName params:nil isPush:YES];
        return;
    }
    if ([EKLoginViewController showLoginVC:self from:@"inPage"]) {
        return;
    }
    [super showNextViewControllerName:controllerName params:nil isPush:YES];
}


//返回tableView组头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}


//返回组尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 14;
}


#pragma mark - EKMyCenterBaseCellDelegate
//用户头像点击时调用
- (void)mUploadUserAvatarButtonDidClick {
    EKMyCenterUploadAvatarAlertController *alertController = [EKMyCenterUploadAvatarAlertController alertControllerWithTitle:@"上傳頭像"
                                                                                                                     message:nil
                                                                                                              preferredStyle:UIAlertControllerStyleActionSheet];
    alertController.vDelegate = self;
    EKMyCenterInformationCell *cell = [_vTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    alertController.popoverPresentationController.sourceRect = cell.vAvatarButton.bounds;
    alertController.popoverPresentationController.sourceView = cell.vAvatarButton;
    [self presentViewController:alertController animated:YES completion:nil];
}


//"资料"按钮点击时候调用
- (void)mBasicInformationButtonDidClick {
    EKBasicInformationViewController *basicViewController = [[EKBasicInformationViewController alloc] init];
    basicViewController.vBasicInformationArray = [_vMyCenterListModelArray.firstObject.firstObject.vBasicInformationModel mChangeBasicInformationModelToArray];
    [self.navigationController pushViewController:basicViewController animated:YES];
}


//"帖子"按钮点击时候调用
- (void)mMyThemeButtonDidClick {
    [self.navigationController pushViewController:[[EKMyThemeViewController alloc] init] animated:YES];
}


//"主题收藏"按钮点击时候调用
- (void)mThemeCollectButtonDidClick {
    [super showNextViewControllerName:@"EKMyCollectThemeViewController" params:nil isPush:YES];
}


//"消息提醒"按钮点击时候调用
- (void)mMessageButtonDidClick {
    [super showNextViewControllerName:@"EKMessageNoticeViewController" params:nil isPush:YES];
}


//"日志"按钮点击时候调用
- (void)mMyBlogButtonDidClick {
    [super showNextViewControllerName:@"MyBlogViewController" params:nil isPush:YES];
}


//未登录时点击顶部cell跳转到登录界面
- (void)mPopToLoginViewController {
    [EKLoginViewController showLoginVC:self from:@"inPage"];
}


#pragma mark - EKMyCenterUploadAvatarAlertControllerDelegate
//选择上传头像方式的时候调用
- (void)mMyCenterUploadAvatarAlertControllerDidSelectWithType:(EKMyCenterUploadAvatarMethodType)methodType {
    //创建照片选取控制器
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    switch (methodType) {
            //手机相册
        case EKMyCenterUploadAvatarMethodTypeAlbum: {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
            break;
            //拍照
        case EKMyCenterUploadAvatarMethodTypeTakePhoto: {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.videoQuality = UIImagePickerControllerQualityType640x480;
        }
            break;
        default:
            break;
    }
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate
//选取完照片时候调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //获取到图片
    UIImage *avatarImage = info[UIImagePickerControllerEditedImage];
    //裁剪图片
    avatarImage = [avatarImage scaleToSize:CGSizeMake(200, 200)];
    //上传图片
    NSDictionary *parameter = @{@"token" : TOKEN};
    MBProgressPercentHUD *progressPercentHUD = [MBProgressPercentHUD showHUDAddedTo:self.view message:@"0%"];
    [EKHttpUtil mUploadWithURLString:kUserAvatarUploadURL
                           parameter:parameter
                               image:avatarImage
                        percentBlock:^(float precent) {
                            progressPercentHUD.labelText = [NSString stringWithFormat:@"%.1f%%",precent * 100];
                        } completionBlock:^(BKNetworkModel *model, NSString *netErr) {
                            [progressPercentHUD removeFromSuperview];
                            if (netErr) {
                                [self.view showError:netErr];
                            } else {
                                if (1 == model.status) {
                                    //让SD重新从后台下载用户头像,防止用户头像出现缓存错乱
                                    [[SDImageCache sharedImageCache] removeImageForKey:kUserAvatarURLStringKey withCompletion:nil];
                                    //生成1个新的用户头像URL地址保存起来
                                    int randomNumber = arc4random() % 100;
                                    NSString *newAvatarUrlString = [NSString stringWithFormat:@"%@&random=%d",USER.avatar,randomNumber];
                                    [BKSaveData setString:newAvatarUrlString key:kUserAvatarURLStringKey];
                                    
                                    //更新tableView的UI
                                    [_vTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                                                       withRowAnimation:UITableViewRowAnimationNone];
                                } else {
                                    [self.view showError:model.message];
                                }
                            }
                        }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 对未读消息小红点的处理
//显示小红点
- (void)mShowRedBadge {
    _vIsHideRedBadge = NO;
    [_vTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}


//隐藏小红点
- (void)mHideRedBadge {
    _vIsHideRedBadge = YES;
    [_vTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}


@end
