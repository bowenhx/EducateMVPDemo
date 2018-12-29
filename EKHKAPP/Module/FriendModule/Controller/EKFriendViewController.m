/**
 -  EKFriendViewController.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/31.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是从"个人中心"界面进入的"我的好友"界面
 -  该界面的几个类是直接用的"搜索好友"模块的,如解除好友关系的弹窗控制器/删除好友时使用的model/列表cell
 */

#import "EKFriendViewController.h"
#import "EKSearchUserCell.h"
#import "EKFriendModel.h"
#import "EKSearchUserAlertController.h"
#import "EKSearchUserModel.h"
#import "EKUserInformationViewController.h"

//缓存标识符
static NSString *cellID = @"EKSearchUserCellID";

@interface EKFriendViewController () <UITableViewDataSource,
                                      UITableViewDelegate,
                                      EKSearchUserCellDelegate,
                                      EKSearchUserAlertControllerDelegate,
                                      EKUserInformationViewControllerDelegate>
//主体的tableView
@property (nonatomic, strong) UITableView *vTableView;
//后台返回的朋友列表数据源数组
@property (nonatomic, strong) NSMutableArray <EKFriendModel *> *vFriendModelDataSource;
//发布日志，选择的好友数组
@property (nonatomic, strong) NSMutableArray *selectFriends;

@end

@implementation EKFriendViewController

#pragma mark - 初始化UI
- (void)mInitUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor EKColorTableBackgroundGray];
    
    if (_friendPageType == FriendPageTypeIsPublishBlog) {
        self.title = @"選擇好友";
        [self.vRightBarButton setTitle:@"完成" forState:UIControlStateNormal];
    } else {
        self.title = @"我的好友";
    }
    
    _vTableView = [[UITableView alloc] init];
    _vTableView.delegate = self;
    _vTableView.dataSource = self;
    [self.view addSubview:_vTableView];
    [_vTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NAV_BAR_HEIGHT);
        make.left.right.bottom.equalTo(self.view);
    }];
    _vTableView.tableFooterView = [[UIView alloc] init];
    _vTableView.rowHeight = 61;
    //注册cell
    UINib *friendCellNib = [UINib nibWithNibName:@"EKSearchUserCell" bundle:nil];
    [_vTableView registerNib:friendCellNib forCellReuseIdentifier:cellID];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(mRefreshData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _vTableView.mj_header = header;
}


#pragma mark - 初始化数据
- (void)mInitData {
    _selectFriends = [NSMutableArray array];
    [_vTableView.mj_header beginRefreshing];
}


#pragma mark - 下拉刷新控件监听事件
- (void)mRefreshData {
    [EKFriendModel mRequestFriendModelDataSourceWithCallBack:^(NSString *netErr, NSArray<EKFriendModel *> *data) {
        if (netErr) {
            [self.view showError:netErr];
        } else {
            _vFriendModelDataSource = [NSMutableArray arrayWithArray:data];
            [_vTableView reloadData];
        }
        [_vTableView mEndRefresh];
    }];
}


#pragma mark - EKSearchUserCellDelegate
//点击"解除好友"按钮时调用
- (void)mSearchUserCellAddFriendButtonDidClickWithCell:(EKSearchUserCell *)cell {
    NSInteger row = [_vTableView indexPathForCell:cell].row;
    //弹出解除好友的弹窗控制器
    EKSearchUserAlertController *alertController = [[EKSearchUserAlertController alloc] initWithDelegate:self withRow:row];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - EKSearchUserAlertControllerDelegate - 解除好友的弹窗控制器的代理方法
//解除好友的"确定"按钮点击的时候调用
- (void)mSearchUserAlertControllerConfirmButtonDidClickWithRow:(NSInteger)row {
    //获取到要解除关系的好友的model
    EKFriendModel *friendModel = _vFriendModelDataSource[row];
    [self.view showHUDActivityView:kStartLoadingText shade:NO];
    [EKSearchUserModel mRequestDeleteFriendWithUid:friendModel.uid
                                          callBack:^(BOOL isSuccess, NSString *message) {
                                              [self.view removeHUDActivity];
                                              [self.view showSuccess:message];
                                              if (isSuccess) {
                                                  //移除数据源中删除掉的好友的model
                                                  [_vFriendModelDataSource removeObject:friendModel];
                                                  [_vTableView reloadData];
                                              }
                                          }];
}


#pragma mark - UITableViewDataSource
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _vFriendModelDataSource.count;
}


//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EKSearchUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.vFriendModel = _vFriendModelDataSource[indexPath.row];
    cell.delegate = self;
    
    if (_friendPageType == FriendPageTypeIsPublishBlog) {
        cell.vAddFriendButton.hidden = YES;
    }
        
    return cell;
}


#pragma mark - UITableViewDelegate
//点击时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_friendPageType == FriendPageTypeIsPublishBlog) {
        EKSearchUserCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        __block NSUInteger index = 9999999;
        [_selectFriends enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj integerValue] -10 == indexPath.row) {
                //判断是否点击的是同一个
                cell.accessoryType = UITableViewCellAccessoryNone;
                index = idx;
                *stop = true;
            }
        }];
        
        if (index == 9999999) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [_selectFriends addObject:@(indexPath.row+10)];
        }else{
            [_selectFriends removeObject:@(indexPath.row+10)];
        }
        
    } else {
        //跳转到用户基本资料界面
        EKUserInformationViewController *userInformationViewController = [[EKUserInformationViewController alloc] init];
        userInformationViewController.delegate = self;
        EKFriendModel *friendModel = _vFriendModelDataSource[indexPath.row];
        userInformationViewController.userImageURLString = friendModel.avatar;
        userInformationViewController.uid = friendModel.uid;
        userInformationViewController.name = friendModel.username;
        [self.navigationController pushViewController:userInformationViewController animated:YES];
    }
    
}


#pragma mark - EKUserInformationViewControllerDelegate
//好友基本资料界面"解除好友"关系成功后调用
- (void)mDeleteFriendWithUID:(NSString *)UID {
    //移除对应数据
    for (EKFriendModel *friendModel in _vFriendModelDataSource) {
        if ([friendModel.uid isEqualToString:UID]) {
            [_vFriendModelDataSource removeObject:friendModel];
        }
    }
    //刷新UI
    [_vTableView reloadData];
}



#pragma mari - 从发布日志页面进入的，选择好友后，完成按钮
- (void)mTouchRightBarButton {
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:_selectFriends.count];
    [_selectFriends enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EKFriendModel *model = [_vFriendModelDataSource objectAtIndex:[obj integerValue]-10];
        [items addObject:model.username];
    }];
    
    if (_usernames) {
        _usernames (items);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
