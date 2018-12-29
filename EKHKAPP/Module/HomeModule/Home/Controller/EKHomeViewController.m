/**
 -  EKHomeViewController.m
 -  EKHKAPP
 -  Created by HY on 2017/9/7.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明："首页"模块--tabBar的第0个控制器
 */

#import "EKHomeViewController.h"
#import "EKHomeItemView.h"
#import "EKHomeTableView.h"
#import "EKFirstLaunchScrollView.h"
#import "EKHomeItemModel.h"
#import "EKHomeTopUpDownAdvertiseModel.h"
#import "BKLoopViewModel.h"
#import "EKHomeListModel.h"
#import "EKHomeVoteModel.h"
#import "EKMilkMoreViewController.h"
#import "EKLoginViewController.h"
#import "EKColumnView.h"
#import "EKThemeDetailViewController.h"
#import "BKThemeListViewController.h"
#import "EKHomeADModel.h"
#import "EKHomeWebViewController.h"
#import "EKColumnModel.h"

@interface EKHomeViewController () <EKHomeItemViewDelegate, EKHomeTableViewDelegate>
#pragma mark - 属性 - UI
//顶部的频道选择视图
@property (nonatomic, strong) EKHomeItemView *vHomeItemView;
//主体的自定义视图
@property (nonatomic, strong) EKHomeTableView *vHomeTableView;
#pragma mark - 属性 - 数据源
//后台返回的置顶左侧上下广告数据
@property (nonatomic, strong) NSArray <EKHomeTopUpDownAdvertiseModel *> *vHomeTopUpDownAdvertiseDataSource;
//后台返回的横向标签栏数据源数组
@property (nonatomic, strong) NSArray <EKHomeItemModel *> *vHomeItemDataSource;
//后台返回的列表数据源,包含论坛话题列表/bk milk文章列表/tv数据列表/kmall产品列表
@property (nonatomic, strong) EKHomeListModel *vHomeListModel;
#pragma mark - 属性 - 记录
//用来记录下来当前选择的顶部横向标签对应的model
@property (nonatomic, strong) EKHomeItemModel *vCurrentHomeItemModel;
//由于首次安装选择兴趣板块，记录willApper显示全屏广告次数；
@property (nonatomic, assign) BOOL vShowInterstitial;
@end

@implementation EKHomeViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kFirstLaunchSelectFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kHomeVoteRefreshNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.vShowInterstitial) {
        [self mRequestInterstitialView];
        [self mRequestPopupView:BOTTOM_TABBAR_HEIGHT];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //添加广告
    [self mRequestBannerView];
}

#pragma mark - banner广告请求成功的回调
- (void)mMergeBannerAdData {
    NSLog(@"%@",self.vBannerArray);
    _vHomeTableView.vHomeBannerArray = self.vBannerArray;
    [self.vHomeTableView.vTableView reloadData];
}

#pragma mark - 实例化UI
- (void)mInitUI {
    //1.设置自身UI属性
    [self mInitSelfUI];
    //2.实例化频道选择view
    [self mInitHomeItemView];
    //3.实例化自定义tableView
    [self mInitHomeTableView];
    
    //需要在此先让侧滑视图先获取一下本地数据,目的是提早实例化它,以提早更新其底部按钮文字
    //因为不这么做的话,侧滑视图一开始只会在呼出侧滑按钮的时候再实例化,那么底部按钮显示的"加入讨论"/"编辑"的文字,需要消耗时间来确定其要显示的文字内容,用户体验不够好
    [EKColumnView mReloadData];
    
    //先隐藏表，等四个列表数据的网络请求加载完成后，显示
    [self.view showHUDActivityView:kStartLoadingText shade:NO];
    self.vHomeTableView.vTableView.hidden = YES;
}


#pragma mark - 初始化数据
- (void)mInitData {
    //1.请求顶部横向标签数据
    //如果没有用户选择的喜爱板块的话,则先不在此获取顶部横向标签的数据.如获取到了的话,则正常加载数据
    if ([BKSaveData getArray:kPreferForumInfoKey]) {
        [self mRequestItemViewData];
    }
    //2.请求置顶左侧上下广告数据
    [self mRequestTopUpDownAdvertiseData];
  
    //3.请求轮播banner数据
    [self mRequestLoopViewData];
    
    //监听首次启动界面的选择是否完成
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mRequestItemViewData)
                                                 name:kFirstLaunchSelectFinishNotification
                                               object:nil];
    
    //监听刷新投票数据
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mRefreshVoteData)
                                                 name:kHomeVoteRefreshNotification
                                               object:nil];
  
}


//设置自身UI属性
- (void)mInitSelfUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //显示"首次启动"页面
    [EKFirstLaunchScrollView mShowFirstLaunchScrollView];
    
    //设置导航栏左侧按钮
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 2, 40, 40)];
    imageView.image = [UIImage imageNamed:@"home_vi_logo"];
    imageView.contentMode = UIViewContentModeCenter;
    [self.navLeftView addSubview:imageView];
    
    //设置导航栏右侧按钮
//    [self.vRightBarButton setImage:[UIImage imageNamed:@"home_search_unpressed"] forState:UIControlStateNormal];
}


//实例化频道选择view
- (void)mInitHomeItemView {
    _vHomeItemView = [[EKHomeItemView alloc] init];
    _vHomeItemView.delegate = self;
    [self.view addSubview:_vHomeItemView];
    CGFloat homeItemViewHeight = 40;
    [_vHomeItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAV_BAR_HEIGHT);
        make.height.mas_equalTo(homeItemViewHeight);
    }];
}


//实例化主体View
- (void)mInitHomeTableView {
    _vHomeTableView = [[EKHomeTableView alloc] init];
    [self.view addSubview:_vHomeTableView];
    _vHomeTableView.delegate = self;
    [_vHomeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_vHomeItemView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}


#pragma mark - 导航栏右侧，"搜索"按钮点击事件
- (void)mTouchRightBarButton {
    //隐藏侧滑菜单视图
    [EKColumnView hiddenColumnViewAction];
    //跳转到"搜索"控制器
    [self showNextViewControllerName:@"EKSearchViewController" params:nil isPush:YES];
}


//请求顶部横向标签数据
- (void)mRequestItemViewData {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //添加广告
        [self mRequestInterstitialView];
        [self mRequestPopupView:BOTTOM_TABBAR_HEIGHT];
        self.vShowInterstitial = YES;
    });
    
    //加入下面这行代码,是避免首次启动的时候,侧边栏在用户选择完喜爱版块后却无数据显示的BUG
    [EKColumnView mReloadData];
    [EKHomeItemModel mRequestHomeItemDataWithCallBack:^(NSString *netErr, NSArray<EKHomeItemModel *> *homeItemDataSource) {
        if (netErr) {
            [self.view showError:netErr];
        } else {
            NSMutableArray <NSString *> *tempTitleArray = [NSMutableArray array];
            for (EKHomeItemModel *itemModel in homeItemDataSource) {
                [tempTitleArray addObject:itemModel.label];
            }
            //传递数据给UI进行UI更新
            _vHomeItemView.vTitles = tempTitleArray.copy;
            //记录后台返回的顶部横向标签数据源
            _vHomeItemDataSource = homeItemDataSource;
            //DLog(@"后台返回的顶部横向标签数据源数组 : %@",homeItemDataSource);
            
            //加载完标签数据之后,首页加载什么数据,得看当前是否是用户第一次启动程序
            //如果是,则加载首次启动程序界面选择的年级
            //如果不是,则默认加载第0个年级
            if ([BKSaveData getBool:kIsHomeLoadFirstItemDataKey]) {
                _vHomeItemView.vIndex = 0;
            } else {
                NSDictionary *firstLaunchDictionary = [BKSaveData getArray:kPreferForumInfoKey].firstObject;
                NSString *key = firstLaunchDictionary[@"key"];
                for (EKHomeItemModel *homeItemModel in homeItemDataSource) {
                    if ([homeItemModel.key isEqualToString:key]) {
                        _vHomeItemView.vIndex = [homeItemDataSource indexOfObject:homeItemModel];
                        DLog(@"要加载的横向标签model为:%@",homeItemModel);
                    }
                }
            }
        }
    }];
}


//请求置顶左侧上下广告数据
- (void)mRequestTopUpDownAdvertiseData {
    [EKHomeTopUpDownAdvertiseModel mRequestHomeTopUpDownAdvertiseDataWithCallBack:^(NSString *netErr, NSArray<EKHomeTopUpDownAdvertiseModel *> *data) {
        if (netErr) {
        } else {
            //传递数据给自定义视图
            _vHomeTableView.vHomeTopUpDownAdvertiseDataSource = data;
            //属性记录数据
            _vHomeTopUpDownAdvertiseDataSource = data;
        }
    }];
}


//请求轮播banner后台数据
- (void)mRequestLoopViewData {
    [BKLoopViewModel mRequestLoopViewDataWithCallBack:^(NSArray<BKLoopViewModel *> *data) {
        _vHomeTableView.vHomeLoopImageViewDataSource = data;
    }];
}


#pragma mark - EKHomeItemViewDelegate 点击顶部横向标签
- (void)mHomeItemViewDidClickWithIndex:(NSInteger)index {
    [self.view showHUDActivityView:kStartLoadingText shade:NO];
    //记录下来当前选中的顶部横向标签所对应的model
    _vCurrentHomeItemModel = _vHomeItemDataSource[index];
    NSString *tabID = _vCurrentHomeItemModel.key;
    
    //Google统计
    NSString *googleString = [NSString stringWithFormat:@"tabid=%@",tabID];
    //UMeng统计
    NSDictionary *parameter = @{@"tabid" : tabID};
    [super mAddAnalyticsWithPageIndex:kHomePageIndex googleString:googleString parameter:parameter];
    
    DLog(@"点击的置顶标签下标为:%zd   对应的model为:%@",index,_vCurrentHomeItemModel);
    [EKHomeListModel mRequestHomeListDataWithTabID:tabID callBack:^(NSString *netErr, EKHomeListModel *homeListModel) {
        [self.view removeHUDActivity];
        self.vHomeTableView.vTableView.hidden = NO;
        if (netErr) {
            [self.view showError:netErr];
        } else {
            //传递数据给自定义视图
            _vHomeTableView.vHomeListModel = homeListModel;
            //属性记录数据
            _vHomeListModel = homeListModel;
        }
    }];
    
    [self mRefreshVoteData];
    
    //更新活动日期数据
    [_vHomeTableView updataActivityDate];
    
    //页面滚动到顶部
    [_vHomeTableView.vTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}


- (void)mRefreshVoteData {
    //投票数据
    [EKHomeVoteModel mLoadVoteTabid:_vCurrentHomeItemModel.key block:^(EKHomeVoteModel *data, NSString *error) {
        _vHomeTableView.vOteModel = data;
    }];
}


#pragma mark - EKHomeTableViewDelegate
//置顶左侧上下广告的两个按钮,点击的时候调用
- (void)mHomeTableViewTopUpDownAdvertiseButtonDidClickWithIndex:(NSInteger)index {
    EKHomeTopUpDownAdvertiseModel *model = _vHomeTopUpDownAdvertiseDataSource[index];
    DLog(@"点击的置顶左侧上下广告model为 : %@",model);
    //根据后台字段的有无,决定跳转到web/帖子详情/帖子列表中的一种
    if (![BKTool isStringBlank:model.url]) {
        NSString *title = nil;
        if ([BKTool isStringBlank:model.title]) {
            title = @"精選";
        } else {
            title = model.title;
        }
        [EKHomeWebViewController showHomeWebViewControllerWithTitle:title
                                                          URLString:model.url
                                                 fromViewController:self
                                                           pageType:WebPageTypeNormal];
    } else if (![BKTool isStringBlank:model.tid]) {
        EKThemeDetailViewController *detailViewController = [[EKThemeDetailViewController alloc] init];
        detailViewController.tid = @(model.tid.integerValue);
        [self.navigationController pushViewController:detailViewController animated:YES];
    } else if (![BKTool isStringBlank:model.fid]) {
        BKThemeListViewController *themeListViewController = [[BKThemeListViewController alloc] init];
        themeListViewController.vFid = model.fid;
        [self.navigationController pushViewController:themeListViewController animated:YES];
    }
}


//cell点击的时候调用
- (void)mHomeTableViewCellDidClickAtIndexpath:(NSIndexPath *)indexPath {
    //先提取出组数和行数
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case 0: {
            //获取到当前点的"论坛主题"cell对应的model
            EKHomeThreadModel *homeThreadModel = _vHomeListModel.thread[row];
            DLog(@"点击的论坛主题model为 : %@",homeThreadModel);
            NSDictionary *parameter = @{@"tid" : @(homeThreadModel.tid.integerValue),
                                        @"password" : @"0"};
            [super showNextViewControllerName:@"EKThemeDetailViewController" params:parameter isPush:YES];
            break;
        }
        case 1: {
            EKHomeMilkModel *homeMilkModel = _vHomeListModel.milk[row];
            DLog(@"点击的BKMilk model为 : %@",homeMilkModel);
            [EKHomeWebViewController showHomeWebViewControllerWithTitle:homeMilkModel.title
                                                              URLString:homeMilkModel.url
                                                     fromViewController:self pageType:WebPageTypeNormal];
            }
        default:
            break;
    }
}


//点击到活动详情页面
- (void)mHomeTableViewTopActivityData:(EKHomeActivityEventModel *)activityModel {
    DLog(@"点击的活动 model为 : %@",activityModel);
    [EKHomeWebViewController showHomeWebViewControllerWithTitle:@"活動資料"
                                                      URLString:activityModel.weburl
                                             fromViewController:self
                                                       pageType:WebPageTypeNormal];
}


//BKMilk的组头点击的时候调用
- (void)mHomeTableViewMilkMoreButtonDidClick {
    //跳转到"BKMilk更多"界面
    EKMilkMoreViewController *milkMoreViewController = [[EKMilkMoreViewController alloc] init];
    milkMoreViewController.vTabid = _vCurrentHomeItemModel.key;
    milkMoreViewController.title = _vCurrentHomeItemModel.label;
    DLog(@"准备跳转到BKMilk更多界面,传递的顶部横向标签tabid : %@",_vCurrentHomeItemModel.key);
    [self.navigationController pushViewController:milkMoreViewController animated:YES];
}


//tableView的 TV cell内部的"播放"按钮被点击的时候调用
- (void)mHomeTableViewTVCellDidClickWithIndex:(NSInteger)index {
    DLog(@"点击的 TV model 为 : %@",_vHomeListModel.tv[index]);
    EKHomeTVModel *tvModel = _vHomeListModel.tv[index];
    [EKHomeWebViewController showHomeWebViewControllerWithTitle:tvModel.subject
                                                      URLString:tvModel.url
                                             fromViewController:self
                                                       pageType:WebPageTypeVideo];
    //添加谷歌统计
    NSString *str = [NSString stringWithFormat:@"tvUrl = %@",tvModel.url];
    [EKGoogleStatistics mGoogleActionAnalytics:kParentsTvPageIndex label:str];
}


//tableView的kmall collectionView内部的cell被点击的时候调用
- (void)mHomeTableViewKMallCellDidClickWithIndex:(NSInteger)index {
    DLog(@"点击的KMall 的 model为 : %@",_vHomeListModel.kmall[index]);
    EKHomeKMallModel *kmModel = _vHomeListModel.kmall[index];
    [EKHomeWebViewController showHomeWebViewControllerWithTitle:kmModel.title
                                                      URLString:kmModel.url
                                             fromViewController:self
                                                       pageType:WebPageTypeNormal];
    //添加谷歌统计
    NSString *str = [NSString stringWithFormat:@"kmallURL = %@",kmModel.url];
    [EKGoogleStatistics mGoogleActionAnalytics:kKmallDetailPageIndex label:str];
    
}


- (void)mUserNotLogigWithPush {
    [EKLoginViewController showLoginVC:self from:@"inPage"];
}


@end
