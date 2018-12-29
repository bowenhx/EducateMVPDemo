/**
 -  EKMessageNoticeViewController.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/3.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"个人中心"进入的"消息提醒"界面
 */

#import "EKMessageNoticeViewController.h"
#import "EKCornerSelectMenuView.h"
#import "EKMessageCell.h"
#import "EKNoticeCell.h"
#import "EKMessageModel.h"
#import "EKNoticeModel.h"
#import "MessageWebViewController.h"
#import "EKMessageNoticeUnreadCountModel.h"
#import "FriendRevertAddVC.h"
#import "FriendRevertGreetingVC.h"
#import "AppDelegate+EKAppConfig.h"

@interface EKMessageNoticeViewController () <EKCornerSelectMenuViewDelegate,
                                             UITableViewDelegate,
                                             UITableViewDataSource,
                                             FriendRevertAddVCDelegate,
                                             FriendRevertGreetingVCDelegate>
//顶部的选择视图
@property (strong, nonatomic) EKCornerSelectMenuView *vSelectMenuView;
//主体的scrollView
@property (weak, nonatomic) IBOutlet UIScrollView *vScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vScrollViewTopConstraint;
//管理两个tableView的数组
@property (nonatomic, strong) NSArray <UITableView *> *vTableViewArray;
//存储后台返回的"我的主题"&"我的回复"的数据源数组
@property (nonatomic, strong) NSMutableArray <NSMutableArray *> *vMessageNoticeDataSource;
//存储两个tableView当前刷新到的page参数
@property (nonatomic, strong) NSMutableArray <NSNumber *> *vPageArray;
//记录当前显示的tableView在数组中的下标
@property (nonatomic, assign) NSInteger vCurrentIndex;
//存储未读消息数和未读提醒数的数组
@property (nonatomic, strong) NSMutableArray <NSNumber *> *vNewCountArray;
@end

@implementation EKMessageNoticeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


#pragma mark - 初始化UI
- (void)mInitUI {
    self.title = @"我的訊息";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self mInitSelectMenuView];
    [self mInitTableView];
    
    //适配ipX
    _vScrollViewTopConstraint.constant = 90 + NAV_BAR_HEIGHT;
}


//设置菜单选择视图
- (void)mInitSelectMenuView {
    _vSelectMenuView = [[EKCornerSelectMenuView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 280) / 2, 30 + NAV_BAR_HEIGHT, 280, 30)
                        titleArray:@[@"私訊", @"提醒"] delegate:self type:EKCornerSelectMenuViewTypeNormal selectedIndex:0];
    [self.view addSubview:_vSelectMenuView];
}


//设置scrollView及实例化其内部的两个tableView
- (void)mInitTableView {
    _vScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    _vScrollView.scrollEnabled = NO;
    
    NSMutableArray <UITableView *> *tempTableViewArray = [NSMutableArray array];
    NSInteger tableViewCount = 2;
    for (NSInteger i = 0; i < tableViewCount; i++) {
        UITableView *tableView = [[UITableView alloc] init];
        [tempTableViewArray addObject:tableView];
        [_vScrollView addSubview:tableView];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView.separatorColor = [UIColor EKColorSeperateWhite];
        tableView.backgroundColor = [UIColor EKColorBackground];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_vScrollView).offset(SCREEN_WIDTH * i);
            make.top.width.height.equalTo(_vScrollView);
        }];
        //添加上下拉刷新控件
        @WEAKSELF(self);
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [selfWeak.vTableViewArray[selfWeak.vCurrentIndex].mj_footer resetNoMoreData];
            [selfWeak mRefreshDataWithIndex:selfWeak.vCurrentIndex page:1];
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        tableView.mj_header = header;
        
        tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [selfWeak mRefreshDataWithIndex:selfWeak.vCurrentIndex
                                       page:(selfWeak.vPageArray[selfWeak.vCurrentIndex].integerValue + 1)];
        }];
        tableView.mj_footer.hidden = YES;
    }
    //属性记录tableView数组
    _vTableViewArray = tempTableViewArray.copy;
    
    //注册cell
    UINib *messageCellNib = [UINib nibWithNibName:@"EKMessageCell" bundle:nil];
    [_vTableViewArray[0] registerNib:messageCellNib forCellReuseIdentifier:messageCellID];
    UINib *noticeCellNib = [UINib nibWithNibName:@"EKNoticeCell" bundle:nil];
    [_vTableViewArray[1] registerNib:noticeCellNib forCellReuseIdentifier:noticeCellID];
    
    //设置行高
    _vTableViewArray[0].rowHeight = 66;
    //设置第1个tableView的自动计算行高
    _vTableViewArray[1].rowHeight = UITableViewAutomaticDimension;
    _vTableViewArray[1].estimatedRowHeight = 148;
}


#pragma mark - 上下拉刷新控件监听事件
/**
 根据对应的tableView的索引,和对应的page参数,发起网络请求

 @param index 要发起网络请求的tableView的下标
 @param page 对应的page参数
 */
- (void)mRefreshDataWithIndex:(NSInteger)index page:(NSInteger)page {
    NSString *googleString = [NSString stringWithFormat:@"uid=%@&page=%zd", USERID, page];
    NSDictionary *parameter = @{@"uid" : USERID,
                                @"page" : @(page).description};
    if (0 == index) {
        //统计
        [super mAddAnalyticsWithPageIndex:kMessagePageIndex googleString:googleString parameter:parameter];
        
        [EKMessageModel mRequestMessageModelWithPage:page callBack:^(NSString *netErr, EKMessageModel *messageModel) {
            [self mRequestCallBackWithIndex:index netErr:netErr page:page array:messageModel.lists newCount:messageModel.newcount];
        }];
    } else {
        //统计
        [super mAddAnalyticsWithPageIndex:kNoticePageIndex googleString:googleString parameter:parameter];
        
        [EKNoticeModel mRequestNoticeModelDataSourceWithPage:page callBack:^(NSString *netErr, EKNoticeModel *noticeModel) {
            [self mRequestCallBackWithIndex:index netErr:netErr page:page array:noticeModel.lists newCount:noticeModel.newcount];
        }];
    }
}


/**
 网络请求完成后调用的方法,抽取出来便于复用,用于更新数据源&UI

 @param index 要发起网络请求的tableView的下标
 @param netErr 错误信息
 @param page 对应的page参数
 @param array 后台返回的数组
 @param newCount 后台返回的未读数
 */
- (void)mRequestCallBackWithIndex:(NSInteger)index
                           netErr:(NSString *)netErr
                             page:(NSInteger)page
                            array:(NSArray *)array
                         newCount:(NSString *)newCount {
    UITableView *tableView = _vTableViewArray[index];
    [tableView mEndRefresh];
    if (netErr) {
        if ([netErr isEqualToString:@"沒有更多相關消息"] || [netErr isEqualToString:@"沒有更多通知"]) {
            [tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.view showError:netErr];
        }
    } else {
        //处理page参数
        _vPageArray[index] = @(page);
        //添加新的数据到数据源数组并更新UI
        if ([_vPageArray[index] isEqual:@(1)]) {
            [_vMessageNoticeDataSource[index] removeAllObjects];
        }
        [_vMessageNoticeDataSource[index] addObjectsFromArray:array];
        [tableView reloadData];
        //添加新的未读数到数组中,并更新选择控件的UI
        _vNewCountArray[index] = @(newCount.integerValue);
        _vSelectMenuView.vNewCountArray = _vNewCountArray;
        
        if (_vMessageNoticeDataSource[1].count && _vMessageNoticeDataSource[0].count) {
            //当消息和提醒数据都加载过的时候,再检查是否有未读消息提醒数,否则可能漏检查未读提醒数
            [self mCalculateNewCount];
        }
    }
}


#pragma mark - 初始化数据
- (void)mInitData {
    //初始化数据源数组
    _vMessageNoticeDataSource = [NSMutableArray array];
    NSInteger arrayCount = 2;
    for (NSInteger i = 0; i < arrayCount; i++) {
        NSMutableArray *array = [NSMutableArray array];
        [_vMessageNoticeDataSource addObject:array];
    }
    //初始化page数组
    _vPageArray = [NSMutableArray arrayWithArray:@[@(1), @(1)]];
    //初始化管理两组未读数的数组
    _vNewCountArray = [NSMutableArray arrayWithArray:@[@(0), @(0)]];
    
    _vCurrentIndex = 0;
    //默认一进入的时候,第0个tableView的头部视图下拉刷新加载网络数据
    [_vTableViewArray[_vCurrentIndex].mj_header beginRefreshing];
    //请求未读消息提醒数
    [self mRequestNewMessageNoticeCount];
}


//请求未读消息提醒数
- (void)mRequestNewMessageNoticeCount {
    [EKMessageNoticeUnreadCountModel mRequestMessageNoticeUnreadCountModelWithCallBack:^(NSString *messageCount, NSString *noticeCount) {
        //更新数据源
        _vNewCountArray = [NSMutableArray arrayWithArray:@[@(messageCount.integerValue), @(noticeCount.integerValue)]];
        //更新UI
        _vSelectMenuView.vNewCountArray = _vNewCountArray;
    }];
}


#pragma mark - UITableViewDataSource
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger index = [_vTableViewArray indexOfObject:tableView];
    NSInteger count = _vMessageNoticeDataSource[index].count;
    tableView.mj_footer.hidden = !count;
    return count;
}


//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [_vTableViewArray indexOfObject:tableView];
    if (0 == index) {
        EKMessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:messageCellID forIndexPath:indexPath];
        messageCell.vMessageListModel = _vMessageNoticeDataSource[index][indexPath.row];
        return messageCell;
    } else {
        EKNoticeCell *noticeCell = [tableView dequeueReusableCellWithIdentifier:noticeCellID forIndexPath:indexPath];
        noticeCell.vNoticeListModel = _vMessageNoticeDataSource[index][indexPath.row];
        return noticeCell;
    }
}


//开启"消息"界面的删除效果
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return ![_vTableViewArray indexOfObject:tableView];
}


//设置"消息"界面的删除效果
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger index = [_vTableViewArray indexOfObject:tableView];
        //刪除消息
        if (0 == index) {
            EKMessageListModel *messageListModel = self.vMessageNoticeDataSource[index][indexPath.row];
            NSDictionary *parameter = @{@"token" : TOKEN,
                                        @"deluid" : messageListModel.pmuid};
            [self.view showHUDActivityView:@"正在刪除..." shade:NO];
            [EKHttpUtil mHttpWithUrl:kMessageDeleteURL parameter:parameter response:^(BKNetworkModel *model, NSString *netErr) {
                [self.view removeHUDActivity];
                if (netErr) {
                    [self.view showHUDTitleView:netErr image:nil];
                } else {
                    if (1 == model.status) {
                        //更新新消息数数据源
                        _vNewCountArray[index] = @(_vNewCountArray[index].integerValue - messageListModel.newcount.integerValue);
                        //更新选择控件UI
                        _vSelectMenuView.vNewCountArray = _vNewCountArray;
                        //更新列表model数据源
                        [self.vMessageNoticeDataSource[index] removeObjectAtIndex:indexPath.row];
                        //更新tableView的UI
                        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                    } else {
                        [self.view showHUDTitleView:model.message image:nil];
                    }
                }
            }];
        }
    }
}


#pragma mark - UITableViewDelegate
//点击cell的时候调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger index = [_vTableViewArray indexOfObject:tableView];
    if (0 == index) {
        EKMessageListModel *messageListmodel = _vMessageNoticeDataSource[index][indexPath.row];
        //跳转到"消息详情"界面
        MessageWebViewController *messageWebViewController = [[MessageWebViewController alloc] init];
        messageWebViewController.webURL = messageListmodel.weburl;
        messageWebViewController.friendUID = messageListmodel.pmuid;
        messageWebViewController.friendName = messageListmodel.pmname;
        [self.navigationController pushViewController:messageWebViewController animated:YES];
        
        //取到当前model的新消息数
        NSInteger newMessageCount = messageListmodel.newcount.integerValue;
        //更新当前新消息数数据源
        _vNewCountArray[index] = @(_vNewCountArray[index].integerValue - newMessageCount);
        
        //修改点击的cell对应的model的newCount属性为0
        messageListmodel.newcount = @"0";
    } else {
        EKNoticeListModel *noticeListModel = _vMessageNoticeDataSource[index][indexPath.row];
        
        //根据vType枚举属性,跳转到不同的控制器
        switch (noticeListModel.vType) {
            case EKNoticeListModelTypePost: {
                //跳转到帖子详情界面
                NSDictionary *paramter = @{@"tid" : [NSNumber numberWithInteger:noticeListModel.tid.integerValue],
                                           @"password" : @"0",
                                           @"pid" : noticeListModel.pid
                                           };
                [super showNextViewControllerName:@"EKThemeDetailViewController" params:paramter isPush:YES];
                break;
            }
            case EKNoticeListModelTypeFriendRequest: {
                //跳转到好友申请界面
                FriendRevertAddVC *friendRevertAddVC = [[FriendRevertAddVC alloc] init];
                friendRevertAddVC.vNoticeListModel = noticeListModel;
                //设置代理对象
                friendRevertAddVC.vDelegate = self;
                [self.navigationController pushViewController:friendRevertAddVC animated:YES];
                return;
            }
            case EKNoticeListModelTypePoke: {
                //跳转到回打招呼界面
                FriendRevertGreetingVC *friendRevertGreetingVC = [[FriendRevertGreetingVC alloc] init];
                friendRevertGreetingVC.vNoticeListModel = noticeListModel;
                [self.navigationController pushViewController:friendRevertGreetingVC animated:YES];
                return;
            }
            case EKNoticeListModelTypeGroup: {
                [self.view showHUDTitleView:@"請到網頁版操作！" image:nil];
                break;
            }
            case EKNoticeListModelTypeOther:
                break;
        }
        
        //更新当前新提醒数数据源
        _vNewCountArray[index] = @(_vNewCountArray[index].integerValue - noticeListModel.isnew.integerValue);
        //修改点击的cell对应的model的newCount属性为0
        noticeListModel.isnew = @"0";
    }
    //更新UI头部控件UI
    _vSelectMenuView.vNewCountArray = _vNewCountArray;
    //更新tableView指定cell的UI
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

    [self mCalculateNewCount];
}


#pragma mark - EKCornerSelectMenuViewDelegate
//切换频道的时候调用
- (void)mEKCornerSelectMenuView:(EKCornerSelectMenuView *)selectMenuView didClickWithIndex:(NSInteger)index {
    //记录当前显示的tableView的下标
    _vCurrentIndex = index;
    //滚动scrollView
    [_vScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0) animated:NO];
    
    //符合条件的话则让tableView进行下拉刷新
    if (_vTableViewArray[index].mj_header.isRefreshing) {
        return;
    }
    if (_vMessageNoticeDataSource[index].count) {
        return;
    }
    [_vTableViewArray[index].mj_header beginRefreshing];
}


#pragma mark - FriendRevertAddVCDelegate
//当用户点击完批准好友申请的界面的"忽略"/"批准"按钮并完成数据上传后执行
- (void)mFriendRevertAddVCDidFinish:(FriendRevertAddVC *)friendRevertAddVC {
    //此model即为cell对应的model
    EKNoticeListModel *noticeListModel = friendRevertAddVC.vNoticeListModel;
    //更新当前新提醒数数据源
    _vNewCountArray[1] = @(_vNewCountArray[1].integerValue - noticeListModel.isnew.integerValue);
    //更新头部控件UI
    _vSelectMenuView.vNewCountArray = _vNewCountArray;
    //删除对应的数据源model
    [_vMessageNoticeDataSource[1] removeObject:noticeListModel];
    //刷新tableView的UI
    [_vTableViewArray[1] reloadData];
    
    [self mCalculateNewCount];
}


#pragma mark - FriendRevertGreetingVCDelegate
//当用户点击完回打招呼界面的"发送"/"忽略"按钮并完成数据上传后执行
- (void)mFriendRevertGreetingVCDidFinish:(FriendRevertGreetingVC *)friendRevertGreetingVC {
    //此model即为cell对应的model
    EKNoticeListModel *noticeListModel = friendRevertGreetingVC.vNoticeListModel;
    //更新当前新提醒数数据源
    _vNewCountArray[1] = @(_vNewCountArray[1].integerValue - noticeListModel.isnew.integerValue);
    //修改对应的model的newCount属性为0
    noticeListModel.isnew = @"0";
    //更新UI头部控件UI
    _vSelectMenuView.vNewCountArray = _vNewCountArray;
    //更新tableView指定cell的UI
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_vMessageNoticeDataSource[1] indexOfObject:noticeListModel] inSection:0];
    [_vTableViewArray[1] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self mCalculateNewCount];
}


#pragma mark - 私有方法
//计算未读消息数的总和,为0的话需要发送通知,告诉外界没有新的未读消息提醒
- (void)mCalculateNewCount {
    NSInteger totalNewCount = 0;
    for (NSInteger i = 0; i < _vNewCountArray.count; i++) {
        totalNewCount = _vNewCountArray[i].integerValue + totalNewCount;
    }
    if (!totalNewCount) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNoRemotePushNotification object:nil];
    }
}


#pragma mark - 返回按钮监听事件
- (void)mTouchBackBarButton {
    [super mTouchBackBarButton];
    [[AppDelegate share] requestUnreadMessageNoticeCount];
}


@end
