/**
 -  BlogViewController.m
 -  EKHKAPP
 -  Created by HY on 2017/9/7.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BlogViewController.h"
#import "BlogTypeModel.h"
#import "BlogScrollerView.h"
#import "BlogListTableView.h"
#import "PublishBlogViewController.h"
#import "EKLoginViewController.h"
#import "EKColumnView.h"

//当order = dateline 时，获取的是最新发布日志列表,hot获取的是推荐阅读日志列表
static NSString *ORDER_DATELINE =@"dateline";
static NSString *ORDER_HOT = @"hot";

@interface BlogViewController () <EKCornerSelectMenuViewDelegate>

//最底层view，头部距离上方的距离，用于适配UI
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewTopSpace;

//自定义的底层view
@property (weak, nonatomic) IBOutlet BlogScrollerView *customScrollerView;


//头部滑动的日志分类数据
@property (nonatomic , strong) NSMutableArray *itemViews;

//当前选中的tableview
@property (nonatomic , strong) BlogListTableView *selectBlogTableView;

//当前选中的头部滑动view中item的索引值
@property (nonatomic , assign) CGFloat selectItemIndex;

@end

@implementation BlogViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:kLoginSuccessNotification];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //添加广告
    [self mRequestInterstitialView];
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    //登录后，刷新当前页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFinishAction) name:kLoginSuccessNotification object:nil];
}

#pragma mark - 初始化UI
- (void)mInitUI {
    self.view.backgroundColor = [UIColor EKColorBackground];
    self.bgViewTopSpace.constant = NAV_BAR_HEIGHT;
    _customScrollerView.backgroundColor = [UIColor EKColorBackground];
    
    //设置导航栏右侧,分享按钮
    [self.vRightBarButton setTitle:@"發佈" forState:UIControlStateNormal];
    
    [self mInitNavBarCenterView];
}

#pragma mark - 初始化数据
- (void)mInitData {
    [self.view showHUDActivityView:@"正在加載..." shade:NO];
    [BlogTypeModel mRequestBlogTypeListBlock:^(NSArray *data, NSString *netErr) {
        [self.view removeHUDActivity];
        if (netErr) {
            [self.view showHUDTitleView:netErr image:nil];
        }else{
            [self addHeaderItemViews:data];
        }
    }];
}

#pragma mark - 头部可滑动的日志小分类view
- (void)addHeaderItemViews:(NSArray *)data {
    
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:data.count];
    _itemViews = [NSMutableArray arrayWithCapacity:data.count];
    //初始化页面分类view
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BlogTypeModel *list = (BlogTypeModel*)obj;
        [titles addObject:list.catname];
        
        //创建分类view
        BlogListTableView *blogView = [[BlogListTableView alloc] init];
        blogView.blogTypeModel = list;
        blogView.controller = self;
        blogView.order = ORDER_DATELINE;
        blogView.isFirstTouch = YES;//初始值
        [_itemViews addObject:blogView];
    }];
    
    //顶部可滑动的日志分类view
    [_customScrollerView addItemView:_itemViews title:titles];
    __weak typeof(self)weakSelf = self;
    
    //点击日志小分类
    _customScrollerView.itemsTouchAction = ^(NSInteger index){
        [weakSelf mRefreshSelectTableView:index];
    };
    
    //开始加载第一页数据
    [self mRefreshSelectTableView:0];
}

//刷新选中的item对应的下方tableview
- (void)mRefreshSelectTableView:(NSInteger)index {
    _selectItemIndex = index;
    
    BlogListTableView *blogTableView = _itemViews[index];
    _selectBlogTableView = blogTableView;
    
    //用于第一次点击才刷新，再次点击不自动刷新
    if (blogTableView.isFirstTouch == YES) {
        //点击一次后，改变状态为No
        blogTableView.isFirstTouch = NO;
        [_selectBlogTableView requestLoadData];
    }
}

#pragma mark - UINavigationBar 导航条中间的view
- (void)mInitNavBarCenterView {
    
    CGFloat tempWidth;
    if ([UIScreen mainScreen].bounds.size.height >= 667) {
        tempWidth = 190;
    } else {
        tempWidth = 160; //适配iphone4，5
    }
    CGRect vRect = CGRectMake(0, 0, tempWidth, NAV_MENU_HEIGHT);
    _vSelectMenuView = [[EKCornerSelectMenuView alloc] initWithFrame:vRect
                                                          titleArray:@[@"最新日誌", @"推薦日誌"]
                                                            delegate:self
                                                                type:EKCornerSelectMenuViewTypeNavigation
                                                       selectedIndex:0];
    self.navigationItem.titleView = _vSelectMenuView;
    self.vSelectMenuView.userInteractionEnabled = NO;
}

#pragma mark - EKCornerSelectMenuViewDelegate 切换频道的时候调用
- (void)mEKCornerSelectMenuView:(EKCornerSelectMenuView *)selectMenuView didClickWithIndex:(NSInteger)index {

    NSLog(@"select index = %ld",(long)index);
    [_itemViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BlogListTableView *blogView = (BlogListTableView *)obj;
        blogView.order = index ?  ORDER_HOT : ORDER_DATELINE;
        blogView.page = 1;
        blogView.isFirstTouch = YES; //切换导航上方按钮时候，全部置为初始值
    }];
    
    _selectBlogTableView.page = 1;
    [self mRefreshSelectTableView:_selectItemIndex];
}

#pragma mark - 发布日志按钮
- (void)mTouchRightBarButton {
    //隐藏侧滑菜单视图
    [EKColumnView hiddenColumnViewAction];
    
    if (!LOGINSTATUS) {
        [EKLoginViewController showLoginVC:self from:@"inPage"];
    } else {
        PublishBlogViewController *vc = [[PublishBlogViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//登录成功后，要刷新当前页面
- (void)loginFinishAction {
    
    if (_itemViews.count > 0 ) {
        [_itemViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BlogListTableView *blogView = (BlogListTableView *)obj;
            blogView.isFirstTouch = YES; //切换导航上方按钮时候，全部置为初始值
        }];
        
        _selectBlogTableView.page = 1;
        [self mRefreshSelectTableView:_selectItemIndex];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
