/**
 -  BKThemeListViewController.m
 -  BKHKAPP
 -  Created by HY on 2017/8/4.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BKThemeListViewController.h"
#import "BKThemeListPresenter.h"
#import "ThemeListCell.h"
#import "BKGuideViewTool.h"
#import "BKSelectPageView.h"
#import "UITableView+BKRefresh.h"
#import "MoveThreadViewVC.h"
#import "OpenThreadViewVC.h"
#import "EKUserInformationViewController.h"
#import "EKCornerSelectMenuView.h"
#import "EKLoginViewController.h"
#import "BADBannerView.h"

//请求精华类型，api的order字段所对应的参数值
static NSString *kThemeTypeWithChoice = @"digest";

//请求最新类型，api的order字段所对应的参数值
static NSString *kThemeTypeWithNew = @"dateline";

//页面底部，view高度
static CGFloat kBottomViewHeight = 44;

@interface BKThemeListViewController ()  <BKThemeListProtocol, UITableViewDelegate, UITableViewDataSource, BKThemeListHeaderCellDelegate, BKSelectPageViewDelegate, ThemeListCellDelegate, EKCornerSelectMenuViewDelegate>

//用来控制三个tableview的切换
@property (weak, nonatomic)   IBOutlet UIScrollView *vScrollView;

//屏幕下方view上，加载上一页面按钮
@property (weak, nonatomic) IBOutlet UIButton *vLeftArrowBtn;

//屏幕下方view上，加载下一页面按钮
@property (weak, nonatomic) IBOutlet UIButton *vRightArrowBtn;

//屏幕下方view上，选择页数按钮
@property (weak, nonatomic) IBOutlet UIButton *vSelectPageBtn;

@property (weak, nonatomic) IBOutlet UIView *vFooterView;

//底部选择页数view的约束，适配x
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vFooterViewWithBottom;


//navBar中间的选择控件
@property (nonatomic, strong) EKCornerSelectMenuView *vSelectMenuView;

//存放三个滑动tabview对象数据
@property (nonatomic, strong) NSMutableArray <UITableView *> *vTableArray;

//主题列表的数据源数组,由于该页面包含三个tableview，
@property (nonatomic, strong) NSMutableArray <NSMutableArray <BKThemeListModel *> *> *vSourceDataArray;

//Presenter
@property (nonatomic, strong) BKThemeListPresenter *vPresenter;

//分页请求列表数据
@property (nonatomic, assign) NSInteger   vPageNum;

//记录当前主题，最大页码值
@property (nonatomic, assign) NSInteger   vMaxPageNum;

//order为排序过滤参数，默认为空获取全部，当order=dateline时，获取最新的主题列表，当order=digest时，获取精华主题列表。
@property (nonatomic, copy)   NSString    *vOrderType;

//板块下面有一横列可滑动的分类选项，分类id
@property (nonatomic, assign) NSInteger   vClassTypeID;

//标示当前选中的小分类的索引值，从0开始，用來回传给头部view
@property (nonatomic, assign) NSInteger   vSelectClassIndex;

//记录选择顶部类型，全部，精华，最新
@property (nonatomic, assign) NSInteger   vSelectedIndex;

//帖子列表页面所有数据的数据源model，表头的板块数据也从这里面取，列表数据也从里面取
@property (nonatomic, strong) BKThemeListDataModel *vTotalModel;

//bool值记录,默认为No，用来记录：只有第一次点击“精选”Segmented的时候才刷新，其他点击手动刷新
@property (nonatomic, assign) BOOL vTouchChoiceSegmented;

//bool值记录,默认为No，用来记录：只有第一次点击“最新”Segmented的时候才刷新，其他点击手动刷新
@property (nonatomic, assign) BOOL vTouchNewSegmented;

//判断是否是加载更多数据
@property (nonatomic, assign) BOOL vIsLoadMore;

//判断表是否滚动到顶部位置
@property (nonatomic, assign) BOOL vIsScrollToTop;

//表是否需要滚动位置，yes代表需要，No代表不需要滚动
@property (nonatomic, assign) BOOL vIsScrollTable;

@end

@implementation BKThemeListViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    DLog(@"fid = %@",self.vFid);
    [super viewDidLoad];
    
    //管理权限后，刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mNotificationWithRefreshView) name:kRefreshThemeListNotifation object:nil];
    
    //登录后，刷新当前页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mNotificationWithRefreshView) name:kLoginSuccessNotification object:nil];
    
    //添加广告
    self.vAdFid = self.vFid;
//    [self mRequestPopupView:self.vFooterView.size.height];
    [self mRequestInterstitialView];
    [self mRequestBannerView];
    
}

#pragma mark - 初始化UI
- (void)mInitUI {

    //适配iphonex
//    _vFooterViewWithBottom.constant = IPHONEX_BottomAddHeight;
    _vFooterView.hidden = YES;
    //设置navigation上的分段选择控件
    //[self mInitNavBarCenterView];
    
    //设置导航栏右侧@“发帖”按钮
    [self.vRightBarButton setImage:[UIImage imageNamed:@"def_btn_Edit_unpressed"] forState:UIControlStateNormal];
    
    
    //设置选择页数按钮为圆角
    _vSelectPageBtn.layer.masksToBounds = YES;
    _vSelectPageBtn.layer.cornerRadius = 15;
    _vSelectPageBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //设置三个滑动的UITableView
    self.automaticallyAdjustsScrollViewInsets = false;
    _vScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3,_vScrollView.frame.size.height);
    _vTableArray = [NSMutableArray arrayWithCapacity:3];
    
    for (int i = 0; i < 1; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_BAR_HEIGHT)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.hidden = YES;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //添加刷新功能
        [tableView mGifRefresh:self action:@selector(mRefreshView)];
        [tableView mGifLoadMore:self action:@selector(mLoadMore)];
        
        tableView.estimatedRowHeight = THEMELISTCELLHEIGHT;
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        [_vTableArray addObject:tableView];
        [_vScrollView addSubview:tableView];
    }
}

#pragma mark - 初始化数据
- (void)mInitData {
    //p层
    _vPresenter = [[BKThemeListPresenter alloc] init];
    _vPresenter.vThemeListProtocol = self;
    _vIsScrollTable = YES;
    _vSelectClassIndex = 0;
    
    //实例化数据源数组和其内部的元素(可变数组)
    NSInteger tableNumber = 3; //页面有三个表格
    _vSourceDataArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < tableNumber; i++) {
        NSMutableArray *mArr = [NSMutableArray array];
        [_vSourceDataArray addObject:mArr];
    }
    
    //刷新页面数据
    [self mRefreshView];

}

- (void)setParames:(NSDictionary *)parames {
    self.vFid = [NSString stringWithFormat:@"%@",parames[@"fid"]];
    self.vPassword = [NSString stringWithFormat:@"%@",parames[@"password"]];
}

#pragma mark -  ------------------ 刷新模块 ------------------

#pragma mark - 下拉刷新
- (void)mRefreshView {
    
    _vPageNum --;
    _vIsLoadMore = NO;
    if (_vPageNum < 1) { _vPageNum = 1; }
    
    //请求主题列表数据
    [self mLoadThemeListData];
}

#pragma mark - 上拉加载更多
- (void)mLoadMore {
    _vPageNum ++;
    _vIsLoadMore = YES;
    [self mLoadThemeListData];
}

//加载主题列表页数据
- (void)mLoadThemeListData {
    
    self.vSelectMenuView.userInteractionEnabled = NO;
    
    //设置刷新控件的文字，下拉刷新第几页等文字
    UITableView *tabView = (UITableView *)_vTableArray[_vSelectedIndex];
    [tabView mSettingRefreshTitleWithPage:_vPageNum];
    [tabView.mj_footer resetNoMoreData];
    
    //统计
    NSString *googleString = [NSString stringWithFormat:@"fid=%@&page=%zd", _vFid, _vPageNum];
    NSDictionary *parameter = @{@"fid": _vFid,
                                @"page": @(_vPageNum).description};
    [super mAddAnalyticsWithPageIndex:kThemeListPageIndex googleString:googleString parameter:parameter];
    
    //请求列表数据
    [self.view showHUDActivityView:@"正在加載..." shade:NO];
    [_vPresenter mRequestThemeListWithPage:_vPageNum fid:_vFid order:_vOrderType typeId:_vClassTypeID  password:_vPassword index:_vSelectedIndex];
}

#pragma mark -  ------------------ 重写父类方法，获取到banner，合并数据------------------
- (void)mMergeBannerAdData {
    NSLog(@"%@",self.vBannerArray);
    
    //合并广告数据和网络请求到的列表数据
    if (self.vBannerArray.count > 0 && _vSourceDataArray[_vSelectedIndex].count > 0) {
        NSMutableArray *listArr = [NSMutableArray arrayWithArray:_vSourceDataArray[_vSelectedIndex]];
        NSArray *tempArray = [_vPresenter mMergingDataSource:listArr bannerList:self.vBannerArray];
        [_vSourceDataArray[_vSelectedIndex] setArray:tempArray];
        
        //刷新表
        [self mRefreshTableView];
    }
}

- (void)mRefreshTableView {
    
    //底部view的刷新
    [self mRefreshBottomSelectPageView];
    //表操作
    UITableView *tabView = (UITableView *)_vTableArray[_vSelectedIndex];
    
    [tabView mEndRefresh];
    tabView.hidden = NO;
    [tabView reloadData];
    [self mTableViewSetContent];
}

#pragma mark -  ------------------ 实现协议，接收数据 ------------------

#pragma mark - 实现p层协议，接收到主题列表页面整体的数据源，包含表头的板块数据，列表数据等
- (void)mReceiveThemeListData:(BKThemeListDataModel *)dataModel status:(NSInteger)status error:(NSString *)error index:(NSInteger)index{
    
    self.vSelectMenuView.userInteractionEnabled = YES;
    [self.view removeHUDActivity];
//    self.vFooterView.hidden = NO;
    if (error) {
        [self.view showHUDTitleView:error image:nil];
    } else if (status == 1) {
        //该页面全部数据源，赋值
        _vTotalModel = dataModel;
        [_vSourceDataArray[index] setArray:dataModel.lists];
        //合并广告数据和网络请求到的列表数据
        if (self.vBannerArray.count > 0 && _vSourceDataArray[_vSelectedIndex].count > 0) {
            [self mMergeBannerAdData];
        } else {
            [self mRefreshTableView];
        }

        //后台返回每页30条数据
        NSInteger pageCount = 30;
        if (dataModel.lists.count < pageCount ||  dataModel.lists.count == 0) {
            UITableView *tabView = (UITableView *)_vTableArray[index];
            [tabView.mj_footer endRefreshingWithNoMoreData];
        }
    } else if (status == -1) {
        
        //帖子需要密码，逻辑处理
        NSDictionary *forumDic = [BKSaveData getDictionary:kForumPasswordKey];
        if (forumDic) {
            NSString *forumID = [NSString stringWithFormat:@"%@_%@",kForumPasswordKey,self.vFid];
            NSString *password = forumDic[forumID];
            
            if (password == nil || [password isEqual:[NSNull null]]) {
                //弹出密码输入框
                [self addAlertViewAction];
            } else {
                _vPassword = password;
                //更新数据
                [self mLoadThemeListData];
            }
        } else {
            //弹出密码输入框
            [self addAlertViewAction];
        }
    } else {
        [self.view showError:error];
    }
}

#pragma mark ------------------ UITableViewDelegate ------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    tableView.mj_footer.hidden = _vSourceDataArray.count == 0;
    if (section == 0) {
        return 1;
    } else {
        NSInteger tableIndex = [_vTableArray indexOfObject:tableView];
        return _vSourceDataArray[tableIndex].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger tableIndex = [_vTableArray indexOfObject:tableView];
    if (indexPath.section == 0) {
        //表头显示板块信息，和滑动主题菜单的cell
        static NSString *kCellHeaderIdentifier = @"BKThemeListHeaderCell";
        BKThemeListHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellHeaderIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:kCellHeaderIdentifier owner:nil options:nil] lastObject];
        }
        cell.delegate = self;
        cell.vCurrentTableIndex = tableIndex;
        if (_vTotalModel.forum) {
            [cell mRefreshForumHeadCell:_vTotalModel.forum viewType:_vType selectClassIndex:_vSelectClassIndex];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else {
        
        //主题列表的cell,中间会穿插如banner广告cell
        BKThemeListModel *listModel = [_vSourceDataArray[tableIndex] objectAtIndex:indexPath.row];
        
        //取出下一个cell的model数据，因为置顶帖和普通帖子中间的分割线要用两条帖子来对比
        BKThemeListModel *nextListModel;
        if (indexPath.row + 1 < _vSourceDataArray[tableIndex].count && _vSelectedIndex == 0) {
            nextListModel = [_vSourceDataArray[tableIndex] objectAtIndex:indexPath.row + 1];
        }
        
        if ([listModel.type isEqualToString:kAD]) {
            /** banner广告cell */
            UITableViewCell *cell = [_vPresenter mInitBannerAdCellWithTableview:tableView listModel:listModel];
            return cell;
            
        } else {
            /** 普通的主题列表cell */
            static NSString *kCellThemeListIdentifier = @"ThemeListCell";
            ThemeListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellThemeListIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:kCellThemeListIdentifier owner:nil options:nil] lastObject];
            }
            cell.delegate = self;
            BOOL isAllType = !_vSelectedIndex; //Index = 0代表选择是全部板块。
            if (_vSourceDataArray[tableIndex].count > indexPath.row) {
                [cell mRefreshThemeListCell:listModel isAllType:isAllType nextListModel:nextListModel forumModel:_vTotalModel.forum indexPath:indexPath];
            }
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger tableIndex = [_vTableArray indexOfObject:tableView];
    return [_vPresenter mCalculateCellHeightWithIndexPath:indexPath totalModel:_vTotalModel dataArray:_vSourceDataArray[tableIndex]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return;
        
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger tableIndex = [_vTableArray indexOfObject:tableView];
    BKThemeListModel *listModel = [_vSourceDataArray[tableIndex] objectAtIndex:indexPath.row];
    
    if ([listModel.type isEqualToString:kAD]) return;
    
    [self showNextViewControllerName:@"EKThemeDetailViewController" params:@{@"tid":@(listModel.tid),@"password":_vPassword} isPush:true];
}

#pragma mark -  ------------------ cell的代理事件 ------------------

#pragma mark - BKThemeListHeaderCellDelegate
//点击滑动主题分类中的一个按钮
- (void)mTouchSlideThemeMenuWithModel:(BKThemeMenuModel *)model tableIndex:(NSInteger)tableIndex selectClassIndex:(NSInteger)selectClassIndex{
    //改变参数值，刷新表格
    _vClassTypeID = model.vid;
    _vPageNum = 1;
    _vSelectClassIndex = selectClassIndex;
    UITableView *tabView = (UITableView *)_vTableArray[tableIndex];
    [tabView.mj_header beginRefreshing];
}

//点击版主，弹出Alert，可点击进入版主的个人资料页面
- (void)mTouchForumModeratorClick:(BKThemeListForumModel *)forumModel {
    NSArray *modlist = forumModel.modlist;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [modlist enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EKThemeModlistModel *model = (EKThemeModlistModel *)obj;
        UIAlertAction *alert = [UIAlertAction actionWithTitle:model.username style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            EKUserInformationViewController *userInformationViewController = [[EKUserInformationViewController alloc] init];
            userInformationViewController.userImageURLString = model.avatar;;
            userInformationViewController.uid = [NSString stringWithFormat:@"%d",(int)model.uid];
            userInformationViewController.name =  model.username;
            [self.navigationController pushViewController:userInformationViewController animated:YES];
        }];
        [alertController addAction:alert];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    [alertController addAction:cancelAction];
    
    //适配ipad
    BKThemeListHeaderCell *headerCell = [_vTableArray[_vSelectedIndex] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    alertController.popoverPresentationController.sourceRect = headerCell.vMemberButton.bounds;
    alertController.popoverPresentationController.sourceView = headerCell.vMemberButton;
    [self presentViewController:alertController animated:YES completion:nil];
}

//点击表头收藏按钮
- (void)mTouchCollectBtnWithNotLogin {
     [EKLoginViewController showLoginVC:self from:@"inPage"];
}

#pragma mark - ThemeListCellDelegate
//管理员长按cell，触发事件
- (void)mLongPressThemeListCell:(BKThemeListModel *)model {
    
    NSString *title1 = @"移動主題";
    NSString *title2 = model.closed == 1 ? @"開啟主題" : @"關閉主題";
    NSString *cancelButtonTitle = @"取消";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    //@"移動主題"
    UIAlertAction *alert1 = [UIAlertAction actionWithTitle:title1 style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        MoveThreadViewVC *moveThreadViewVC = [[MoveThreadViewVC alloc] initWithNibName:@"MoveThreadViewVC" bundle:nil];
        moveThreadViewVC.title = @"移動主題";
        moveThreadViewVC.dicInfo = @{@"tid":@(model.tid),@"fid":@(model.fid),@"subject":model.subject};
        [self.navigationController pushViewController:moveThreadViewVC animated:YES];
    }];
    
    //@"關閉主題"
    UIAlertAction *alert2 = [UIAlertAction actionWithTitle:title2 style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        OpenThreadViewVC *openThreadViewVC = [[OpenThreadViewVC alloc] init];
        openThreadViewVC.isClosed = model.closed;
        openThreadViewVC.threadInfo = @{@"tid":@(model.tid),@"fid":@(model.fid),@"subject":model.subject};
        [self.navigationController pushViewController:openThreadViewVC animated:YES];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"001");
    }];
    
    [alertController addAction:alert1];
    [alertController addAction:alert2];
    [alertController addAction:cancelAction];
    
    //适配ipad
    NSMutableArray *array = _vSourceDataArray[_vSelectedIndex];
    NSInteger index = [array indexOfObject:model];
    ThemeListCell *cell = [_vTableArray[_vSelectedIndex] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:1]];
    alertController.popoverPresentationController.sourceView = cell;
    alertController.popoverPresentationController.sourceRect = cell.bounds;
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -  ------------------ 按钮点击事件 ------------------

#pragma mark - 发帖按钮的点击方法
- (void)mTouchRightBarButton {
    
    if (!LOGINSTATUS) {
        [EKLoginViewController showLoginVC:self from:@"inPage"];
    } else {
        BKThemeListForumModel *forum = _vTotalModel.forum;
        NSDictionary *param = @{@"password":_vPassword,
                                @"fid":_vFid,
                                @"title":forum.name,
                                @"threadtypes":forum.threadtypes
                                };
        [self showNextViewControllerName:@"BKSendThemeViewController" params:param isPush:NO];
    }
}

#pragma mark -  @"全部",@"精華",@"最新" nav中间的控件初始化
- (void)mInitNavBarCenterView {
    
    CGFloat tempWidth;
    if ([UIScreen mainScreen].bounds.size.height >= 667) {
        tempWidth = 200;
    } else {
        tempWidth = 160; //适配iphone4，5
    }
    CGRect vRect = CGRectMake(0, 0, tempWidth, NAV_MENU_HEIGHT);
    
    //设置navigation上的分段选择控件UISegmentedControl
    NSArray *title = @[kThemeModule_KThemeListAllTypeText,
                       kThemeModule_KThemeListChoiseTypeText,
                       kThemeModule_KThemeListNewTypeText];
    _vSelectMenuView = [[EKCornerSelectMenuView alloc] initWithFrame:vRect titleArray:title delegate:self type:EKCornerSelectMenuViewTypeNavigation selectedIndex:0];
    self.navigationItem.titleView = _vSelectMenuView;
}

#pragma mark - 顶部按钮切换 @"全部",@"精華",@"最新" EKCornerSelectMenuViewDelegate
- (void)mEKCornerSelectMenuView:(EKCornerSelectMenuView *)selectMenuView didClickWithIndex:(NSInteger)index {
    _vSelectedIndex = index;
    [_vScrollView setContentOffset:CGPointMake(_vSelectedIndex * _vScrollView.frame.size.width, 0) animated:YES];
    
    if (_vSelectedIndex == 0) {
        _vOrderType = @"";
    } else if (_vSelectedIndex == 1) {
        _vOrderType = kThemeTypeWithChoice;
    } else if (_vSelectedIndex == 2) {
        _vOrderType = kThemeTypeWithNew;
    }
    
    //每次点击都刷新
    _vPageNum = 1;
    [self mRefreshView];
    
}

#pragma mark -  ------------------ 底部view上按钮点击事件 ------------------

#pragma mark - 返回首页按钮
- (IBAction)mBackHomeBtnClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
    //发出通知，改变当前tabbar上选择的按钮为首页
    [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarIndexChangeNotification object:@(0)];
}

#pragma mark - 刷新页面按钮
- (IBAction)mTouchRefreshBtnClick:(id)sender {
    _vPageNum = 1;
    [self mLoadThemeListData];
}

#pragma mark - 上一页tag=11，下一页tag=22，箭头按钮点击事件
- (IBAction)mTouchArrowBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 11: {
            if (_vPageNum <= 1 ) {
                return;
            } else {
                [self mRefreshView];
            }
            break;
        }
        case 22: {
            if (_vPageNum == _vMaxPageNum) {
                return;
            } else {
                [self mLoadMore];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - 弹出选择页数view的按钮点击事件
- (IBAction)mTouchSelectPageBtnClick:(id)sender {
    BKSelectPageView *customView = [BKSelectPageView mGetInstance];
    customView.delegate = self;
    [self.view addSubview:customView];
    [customView mShowViewWithCurrentPage:_vPageNum totalPage:_vMaxPageNum];
}

#pragma mark - 代理：自定义选择页数view上的确定按钮点击事件
- (void)mTouchFinishBtnOfSelectPageViewWithError:(NSString *)error  page:(NSInteger)page {
    if (error) {
        [self.view showHUDTitleView:error image:nil];
    } else {
        //页码正确，刷新页面
        _vPageNum = page;
        _vIsScrollToTop = YES;
        [self mLoadThemeListData];
    }
}

#pragma mark -  ------------------ 逻辑处理方法 ------------------
- (void)mTableViewSetContent {
    
    if (_vIsScrollTable == NO) {
        _vIsScrollTable = YES;
        return;
    }
    UITableView *tabView = (UITableView *)_vTableArray[_vSelectedIndex];
    if (_vPageNum == 1 || _vIsLoadMore || _vIsScrollToTop) {
        //设置表滚动到最顶部
        [tabView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        _vIsScrollToTop = NO;
    } else {
        [self.view  layoutIfNeeded];
        //设置表滚动到最底部
        if (_vSourceDataArray[_vSelectedIndex].count > 1 ) {
            [tabView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_vSourceDataArray[_vSelectedIndex].count - 1 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
}

//根据请求到的数据，刷新底部选择页数view
- (void)mRefreshBottomSelectPageView {
    self.vMaxPageNum = [_vTotalModel.page[@"max_page"] integerValue];
    if (self.vMaxPageNum >= 1) {
        [_vSelectPageBtn setTitle:[NSString stringWithFormat:@"%ld/%ld頁",(long)self.vPageNum,(long)self.vMaxPageNum] forState:UIControlStateNormal];
        //改变上一页，下一页按钮的状态
        _vLeftArrowBtn.selected = self.vPageNum != 1;
        _vLeftArrowBtn.userInteractionEnabled = _vLeftArrowBtn.selected;
        
        _vRightArrowBtn.selected = self.vPageNum != self.vMaxPageNum;
        _vRightArrowBtn.userInteractionEnabled = _vRightArrowBtn.selected;
    } else {
        [_vSelectPageBtn setTitle:[NSString stringWithFormat:@"0/0頁"] forState:UIControlStateNormal];
        self.vPageNum = 0;
        _vLeftArrowBtn.userInteractionEnabled = _vLeftArrowBtn.selected = NO;
        _vRightArrowBtn.userInteractionEnabled = _vRightArrowBtn.selected = NO;
    }
    
    //表尾
    if (_vRightArrowBtn.userInteractionEnabled == NO) {
        UITableView *tabView = (UITableView *)_vTableArray[_vSelectedIndex];
        [tabView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - 加密帖子 UIAlertView
- (void)addAlertViewAction {
    CustomAlertController *customAlert = [[CustomAlertController alloc] init];
    customAlert.message(@"加密日誌，請輸入密碼").tfPlaceholders(@[@"請輸入密碼"]).confirmTitle(@"確定").cancelTitle(@"取消").controller(self).alertStyle(alert);
    [customAlert showTextField:^(UITextField *textField) {
        //密码设置非明文
        textField.secureTextEntry = YES;
    } confirmAction:^(UIAlertAction *action, NSArray<UITextField *> *textFields) {
        UITextField *textField = textFields.firstObject;
        if ([BKTool isStringBlank:textField.text]) {
            [self.view showHUDTitleView:@"输入密码才能訪問" image:nil];
            [self addAlertViewAction];
        } else {
            //去验证密码是否正确
            _vPassword = textField.text;
            //更新数据
            [self mLoadThemeListData];
        }
    } cancelAction:^(UIAlertAction *action, NSArray<UITextField *> *textFields) {
        [self mTouchBackBarButton];
    }];
}

//从其他页面返回到主题列表，刷新列表的通知
- (void)mNotificationWithRefreshView {
    _vIsScrollTable = NO;
    [self mRefreshView];
}

@end


