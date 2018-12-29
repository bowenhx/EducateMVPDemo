 //
//  EKThemeDetailViewController.m
//  BKMobile
//
//  Created by Guibin on 15/2/4.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
//
//#import <AdSupport/ASIdentifierManager.h>
#import "EKThemeDetailViewController.h"
#import "MoveThreadViewVC.h"
#import "InvitationDataModel.h"
#import "InvitationViewCell.h"
#import "BTextKit.h"
#import "CommentViewController.h"
#import "SendCommentViewController.h"
#import "EKLoginViewController.h"
#import "BKLGActionSheet.h"
#import "BKGuideViewTool.h"
#import "BKSendThemeViewController.h"
#import "EKNavigationViewController.h"
#import "OpenThreadViewVC.h"
#import "ShieldPostVC.h"
#import "WarningPostVC.h"
#import "UserBanVC.h"
#import "EKThemeDetailViewController+Network.h"
#import "EKUserInformationViewController.h"
#import "DWBubbleMenuButton.h"
#import "EKThemeDetailHeadCell.h"
#import "EKThemeDetailPresenter.h"

#define SELECTPAGE_VIEW_HEIGHT 45   //选择页数弹出的自定义view高度
#define DEF_TABBAR_HEIGHT      44   //底部TabBar的高度
#define viewTag 99999999
#define pageRowTag  0xf000
static NSString *defineCell = @"invitationViewCell";
static NSString *defHeadCell = @"detailHeadCell";
@interface EKThemeDetailViewController () <UITableViewDataSource,
                                    UITableViewDelegate,
                                    UIAlertViewDelegate,
                                    UITextViewDelegate,
                                    UIScrollViewDelegate,
                                    ZLPhotoPickerBrowserViewControllerDelegate,
                                    InvitationDataModelDelegate,
                                    EKCornerSelectMenuViewDelegate,
                                    LGActionSheetDelegate,
                                    EKThemeDetailHeadCellDelegate
                                    >
@property (nonatomic, strong) EKThemeDetailPresenter *vPresenter;
@property (nonatomic, strong) DWBubbleMenuButton *iMenuView;
@property (nonatomic, strong) UIButton *tapMenuBtn;
@property (nonatomic, strong) UIButton *vCollectBtn;
@property (nonatomic, strong) UIButton *vTaxisBtn;
@end

@implementation EKThemeDetailViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdataRevertNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    DLog(@"%s",__func__);
    
}
- (void)removeAllObj{
    [_dataSource enumerateObjectsUsingBlock:^(InvitationDataModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
         model.delegate = nil;
    }];
    [_dataSource removeAllObjects];
    _dataSource = nil;
    
    _apiRequestQueue = nil;
}
- (void)mTouchBackBarButton {
    [self removeAllObj];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if(!parent){
        if (_apiRequestQueue) {
            [self removeAllObj];
        }
    }
}

- (void)setParames:(NSDictionary *)parames {
    self.tid = parames[@"tid"];
    self.password = [parames[@"password"] integerValue];
    self.pid = [parames[@"pid"] integerValue];
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.tid == nil) { //注意，这里如果传过来为nil会导致崩溃
        self.tid = @(0);
    }
  
    [self initView]; //设置基本 UI
    
    [self initMutableData]; //初始化变量
    
    //清除图片缓存
    [BKCleanCache trimCacheDirByPath:BTKCacheFolder isAll:NO];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
    //登录后去刷新帖子
    if (_isRefreshPicture && ![BKTool isStringBlank:USERID]) {
        [self loadDataSource];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载 ，在WWDC视频也忽视这一点。
    if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
    {
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
    
}

- (void)addObserVerCenter{
    //注册回复刷新通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshRevert:)
                                                 name:kUpdataRevertNotification
                                               object:nil];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

#pragma mark - 网络请求及刷新 模块
///下拉刷新
- (void)refreshInvdetailData {
    _isLoadMore = NO;
    _pageInteger --;
    
    if ( _pageInteger < 1 ) _pageInteger = 1;
    //判断是否是回复，如果是需要知道对应的帖子页数
    if (self.pid) {
        dispatch_async([self apiRequestQueue], ^{
            DLog(@"队列2");
            [self floorLocation:self.pid];
        });
    } else {
        [self loadDataSource];
    }
    
}
///上啦加载更多
- (void)loadMore
{
    _isLoadMore = YES;
    _pageInteger ++;
    [self loadDataSource];
}

#pragma mark - 初始化模块
- (void)initView {
    [self initNavViewItems];
    _topSpaceHeight.constant = NAV_BAR_HEIGHT;
    if (IPHONEX) _bootomViewWithScreenHeight.constant = IPHONEX_BottomAddHeight;

    //设置tableView
     [_tableView registerNib:[UINib nibWithNibName:@"EKThemeDetailHeadCell" bundle:nil] forCellReuseIdentifier:defHeadCell];
    //注册nibCell
    UINib *nibCell = [UINib nibWithNibName:@"InvitationViewCell" bundle:nil];
    [_tableView registerNib:nibCell forCellReuseIdentifier:defineCell];
    
    //添加下拉刷新功能
    gifHeader = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshInvdetailData)];
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header = gifHeader;
    //添加上拉加载更多功能
    gifFooter = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    _tableView.mj_footer = gifFooter;
    //隐藏刷新控件
    _tableView.mj_footer.hidden = YES;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    //有时候分割线会莫名其妙的隐藏,所以需要在这里设置一下
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)initNavViewItems
{
    //添加引导页面
    //[BKGuideViewTool mShowGuideView:ThemeGuideImageType_TjemeDetail];
    self.title = @"詳情";
    //设置navigation上的分段选择控件UISegmentedControl
//    _navTitleView = [[EKCornerSelectMenuView alloc] initWithFrame:CGRectMake(0, 0, 200, 30) titleArray:@[@"全部帖子",@"只看樓主"] delegate:self type:EKCornerSelectMenuViewTypeNavigation selectedIndex:0];
//    self.navigationItem.titleView = _navTitleView;
//   [self setBackgroundView];
    
    UIImage *image = [UIImage imageNamed:@"list_more_unpressed_n"];
    _tapMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _tapMenuBtn.frame = CGRectMake(0, 0, image.w, image.h);
    [_tapMenuBtn setImage:image forState:UIControlStateNormal];
    [_tapMenuBtn setImage:[UIImage imageNamed:@"list_more_pressed_n"] forState:UIControlStateSelected];
    [_tapMenuBtn addTarget:self action:@selector(didChangeTapImageNor:) forControlEvents:UIControlEventTouchUpInside];

    //初始化右边选择菜单栏
//    _iMenuView = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-image.w-25, SCREEN_HEIGHT - BOTTOM_TABBAR_HEIGHT - 50, image.w, image.h) expansionDirection:DirectionUp];
//    _iMenuView.buttonSpacing = 10;
//    _iMenuView.homeButtonView = _tapMenuBtn;
//    [_iMenuView addButtons:[self createMenuItems]];
//    [self.view addSubview:_iMenuView];

}



//初始化基本数据
- (void)initMutableData{
    [self addObserVerCenter];
    if (!self.tid) {
        self.tid = @(0);
        [self.view showHUDTitleView:@"数据出错" image:nil];
    }
    _password         = 0;
    _isRefreshPicture = NO;
    _pageInteger      = 1;
    _ordertype        = [BKLGActionSheet getDetailTaxis] ? [BKLGActionSheet getDetailTaxis] : 2;//默认ordertype = 2；为順序 1為倒序
    self.vTaxisBtn.selected = _ordertype == 2;
    _authorid         = 0;
    _tempData         = [NSMutableArray arrayWithCapacity:0];
    _textSize         = [BKLGActionSheet getDetailSizeFont]; ///默认帖子字号设置
    if (_textSize == 2) {
        [BModelData sharedInstance].font = DetailSize_Max;
    } else if (_textSize == 0) {
        [BModelData sharedInstance].font = DetailSize_Middle;
    } else {
        [BModelData sharedInstance].font = DetailSize_Small;
    }

    //进入页面，自动下拉刷新拉取数据
    if (self.pid) {
        //pid非空时候，要定位楼层
        [self floorLocation:self.pid];
    } else {
        [self loadDataSource];
    }

    //添加广告
    self.vAdFid = [NSString stringWithFormat:@"%@",self.tid];
    [self mRequestPopupView:_toolbarView.size.height];
    [self mRequestInterstitialView];
    [self mRequestBannerView];
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataSource;
}

#pragma mark -  ------------------ 重写父类方法，获取到banner，合并数据------------------
- (void)mMergeBannerAdData {
    NSLog(@"vBannerArray = %@",self.vBannerArray);
    //合并广告数据和网络请求到的列表数据
    if (self.vBannerArray.count > 0 && _tempData.count > 0) {
        [self uniteLoadData];
    }
}


#pragma mark
#pragma mark - 排序操作
- (void)orderAction {
    //排序默认页数为1
    _pageInteger = 1;
    //ordertype=1为倒序，ordertype=2为正序。
    _ordertype = _ordertype == 2 ? 1 : 2;
    self.vTaxisBtn.selected = _ordertype == 2;
    [self loadDataSource];
}

- (void)didChangeTapImageNor:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [self.iMenuView showButtons];
    } else {
        [self.iMenuView dismissButtons];
    }
}

- (NSString *)shareURL{
    NSString *shareURL = [NSString stringWithFormat:@"%@/forum.php?mod=viewthread&tid=%@", kWebURL, self.tid];
    return shareURL;
}

#pragma  mark - 右下角菜单栏
- (void)tapBtnClickAction:(UIButton *)button {
    NSInteger funtSize = _textSize;
    switch (button.tag) {
        case 0: {//分享
            InvitationDataModel *model = self.dataSource.count > 2 ? self.dataSource[2] : nil;
            UIImage *image = [UIImage imageNamed:@"Icon_share"];
            if (model && model.imgUrls.count) {
                NSString *imageURL = model.imgUrls[0];
                NSData *dataImg = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
                image = [UIImage imageWithData:dataImg];
                NSData *data = UIImageJPEGRepresentation(image, .3f);
                image = [UIImage imageWithData:data];
            }
            [BKTool mSystemShare:self urlToShare:[self shareURL] textToShare:self.thModel.subject imageToShare:image];
           
            //添加统计
            NSString *googleString = [NSString stringWithFormat:@"uid=%@", USERID];
            NSDictionary *parameter = @{@"uid": USERID};
            [super mAddAnalyticsWithPageIndex:kShareThemePageIndex googleString:googleString parameter:parameter];
            
            break;
        }
        case 1: [BKLGActionSheet showActionSheet:self type:InvitationDetailType defSize:funtSize]; break;  //選擇字號
        case 2: [self orderAction]; break;//排序
        case 3: [self didAddCollectAction:button]; break; //收藏
        case 4: [self replyBtnClick:button]; break;//回复楼主
    }
    _tapMenuBtn.selected = NO;
}

#pragma mark - 上一页，下一页操作
- (IBAction)pageTurningClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 77://上一页
        {
            if (_pageInteger == 1) {
                return; //如果已经在第一页，按钮不可点
            } else {
                [self refreshInvdetailData];
            }
        }
            break;
        case 88://下一页
        {
            if (_pageInteger == _maxPageNum) {
                return; //如果已经在最后一页，按钮不可点
            } else {
                [self loadMore];
            }
        }
            break;
        default:
            break;
    }
    
}

//改变上一页下一页按钮状态
- (void)changePageBtnStatusForPage:(NSInteger)pageIndex{
    UIButton *leftBtn = [self.view viewWithTag:77];
    UIButton *rightBtn = [self.view viewWithTag:88];
    
    //改变上一页，下一页按钮的状态
    leftBtn.selected = pageIndex != 1;
    leftBtn.userInteractionEnabled = leftBtn.selected;
    
    rightBtn.selected = pageIndex != _maxPageNum;
    rightBtn.userInteractionEnabled = rightBtn.selected;
}

#pragma mark - 选择页数 操作
- (IBAction)didSelectPageAction:(UIButton *)sender {
    _isLoadMore = NO;
    //为即将弹出的view上label赋值
    UIButton *pageBtn = (UIButton *)[_toolbarView viewWithTag:6];
    _currentPageLabel.text = [NSString stringWithFormat:@"當前%@",pageBtn.titleLabel.text];
    //显示view
    if (_maxPageNum > 1) {
        [_pageTextField becomeFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            _chosePageView_bottom.constant = _keyboardHeight;
            [self.view layoutIfNeeded];
            [self changeViewStatus:YES];
        }];
    } else {
        [self.view showHUDTitleView:@"沒有更多頁數可選" image:nil];
    }
}

//选择页数view，取消
- (IBAction)didSelectCancelAction:(UIButton *)sender {
    [self selectPageViewHidden];
}

//选择页数view，确定
- (IBAction)didSelectFinishAction:(UIButton *)sender {
    [self selectPageViewHidden];
    if ([_pageTextField.text isEqualToString:@""] ) {
        [self.view showHUDTitleView:@"頁碼輸入錯誤，請重新輸入" image:nil];
        return;
    }
    int selectPage = [_pageTextField.text intValue]; //记录数字
    NSLog(@"--%ld",(long)_maxPageNum);
    //判断输入的页码是否合法
    if ([BKTool isPureInt:_pageTextField.text]) {
        if (selectPage > 0  && selectPage <= _maxPageNum) {
            _isLoadMore = YES;
            _pageInteger = selectPage;
            [self loadDataSource];
        } else {
            [self.view showHUDTitleView:@"頁碼輸入錯誤，請重新輸入" image:nil];
        }
    } else {
        [self.view showHUDTitleView:@"頁碼輸入錯誤，請重新輸入" image:nil];
    }
    _pageTextField.text = @""; //清空数字
    [self changeViewStatus:NO];
}

//选择页数的弹出view，消失的方法
-(void)selectPageViewHidden{
    [_pageTextField resignFirstResponder];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        _chosePageView_bottom.constant = -SELECTPAGE_VIEW_HEIGHT;
        [self.view layoutIfNeeded];
    }];
    [self changeViewStatus:NO];
}

#pragma mark - 返回首页
- (IBAction)backHomeAction:(id)sender {
}

//改变视图状态背景色
- (void)changeViewStatus:(BOOL)status {
    if (status) {
        _tableView.userInteractionEnabled        = NO;
        _toolbarView.userInteractionEnabled      = NO;
        self.view.backgroundColor                = [UIColor grayColor];
        _toolbarView.backgroundColor             = [UIColor grayColor];
        _tableView.backgroundColor               = [UIColor grayColor];
        _toolbarView.alpha                       = .5f;
        _tableView.alpha                         = .5f;
    } else {
        _tableView.userInteractionEnabled        = YES;
        _toolbarView.userInteractionEnabled      = YES;
        self.view.backgroundColor                = [UIColor EKColorBackground];
        _toolbarView.backgroundColor             = [UIColor whiteColor];
        _tableView.backgroundColor               = [UIColor EKColorBackground];
        _tableView.alpha                         = 1.f;
        _toolbarView.alpha                       = 1.f;

    }
}

- (void)setBackgroundView{
    _tableView.backgroundColor = [UIColor EKColorBackground];
    //设置button
    UIButton *pageBtn = (UIButton *)[_toolbarView viewWithTag:6];
    pageBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    pageBtn.layer.masksToBounds = YES;
    pageBtn.layer.cornerRadius = 15;
}

#pragma  mark 通知刷新回复帖子
- (void)refreshRevert:(NSNotification *)obj {
    //回复完成后显示对应的回复楼层信息
    NSInteger tempPid = [[obj object] integerValue];
    if (obj.object == nil || !tempPid) {
        [_tableView.mj_header beginRefreshing];
    } else {
        self.pid = tempPid;
        [self floorLocation:self.pid];
    }
}

//update head View data
- (void)changeHeadData:(NSDictionary *)dict{
    ThreadsDetailModel *model = [ThreadsDetailModel new];
    [model setValuesForKeysWithDictionary:dict];
    
    self.thModel = model;
    _isRefreshPicture = LOGINSTATUS ? NO : YES;
   
    if (self.thModel.threadtype == 4) {
        threadType = ThreadTypeActivity;
    } else if (self.thModel.threadtype == 1) {
        threadType = ThreadTypePolls;
    } else {
        threadType = ThreadTypeNormal;
    }

    [self updataCollectStatus];
}

- (void)updataCollectStatus {
    //是否收藏
    self.vCollectBtn.selected = self.thModel.favid;
}

#pragma mark 列表页数
- (void)loadMaxPage:(NSDictionary *)page {
    NSInteger maxPage = [page[@"max_page"] integerValue];
    _maxPageNum = maxPage;
    [self changePageBtnStatusForPage:_pageInteger];
    if (maxPage >= 1) {
        UIButton *pageBtn = (UIButton *)[_toolbarView viewWithTag:6];
        [pageBtn setTitle:[NSString stringWithFormat:@"%ld/%ld頁",(long)_pageInteger,(long)maxPage] forState:UIControlStateNormal];
    }
    
}


#pragma mark 收藏 操作
- (void)didAddCollectAction:(UIButton *)btn {
    if ([EKLoginViewController showLoginVC:self from:@"inPage"]) {
        return;
    }
    btn.enabled = NO;
    //收藏帖子
    if (btn.selected) {
        //取消收藏
        [self cancelCollectClick:btn];
    } else {
        //添加收藏
        [self addCollectClick:btn];
    }
}



#pragma mark - 长按头像手势处理
- (IBAction)longPressGestureAction:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [sender locationInView:_tableView];
        if (point.x < 60) {
            NSIndexPath * indexPath = [_tableView indexPathForRowAtPoint:point];
            if(indexPath){
                NSInteger row = indexPath.row;
                InvitationDataModel *model = [self.dataSource objectAtIndex:row];
                NSArray *arrTitel = [self.vPresenter alertManageTitle:model closed:self.thModel.closed];
                if (arrTitel.count) {
                    InvitationViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
                    CustomAlertController *customAlert = [[CustomAlertController alloc] init];
                    customAlert.actions(arrTitel).cancelTitle(@"取消").sourceView(cell.iconBtn).sourceRect(cell.iconBtn.bounds).controller(self);
                    [customAlert show:^(UIAlertAction *action, NSInteger index) {
                       [self mManageThemeView:action.title model:model];
                    } confirmAction:nil cancelAction:nil];
                }
            }
        }
    }
}

- (void)mManageThemeView:(NSString *)resultStr model:(InvitationDataModel *)model {
    if ([resultStr rangeOfString:@"移動"].location != NSNotFound) {//移動主題
        [MoveThreadViewVC push:self model:self.thModel];
    } else if ([resultStr rangeOfString:@"主題"].location != NSNotFound){//關閉/開啟主題
        [OpenThreadViewVC push:self model:self.thModel];
    } else if ([resultStr rangeOfString:@"屏蔽"].location != NSNotFound){//屏蔽/解除屏蔽
        [ShieldPostVC push:self detailModel:self.thModel dataModel:model];
    } else if ([resultStr rangeOfString:@"警告"].location != NSNotFound){//警告/解除警告
        [WarningPostVC push:self detailModel:self.thModel dataModel:model];
    } else if ([resultStr rangeOfString:@"禁言"].location != NSNotFound){//禁言/解除禁言
        [UserBanVC push:self dataModel:model groupid:4 userBanType:UserBanTypeOfNoSpeak];
    } else if ([resultStr rangeOfString:@"禁訪"].location != NSNotFound){//禁訪/解除禁訪
        [UserBanVC push:self dataModel:model groupid:5 userBanType:UserBanTypeOfNoAccess];
    } else if ([resultStr rangeOfString:@"查看"].location != NSNotFound){//查看用戶IP
        NSString *msg = [NSString stringWithFormat:@"IP : %@", model.useip];
        CustomAlertController *customAlert = [[CustomAlertController alloc] init];
        customAlert.message(msg).confirmTitle(@"確定").controller(self).alertStyle(alert);
        [customAlert show:nil confirmAction:nil cancelAction:nil];
    } else if ([resultStr rangeOfString:@"點評"].location != NSNotFound){
        [SendCommentViewController push:self detailModel:self.thModel dataModel:model pwd:_password];
    }
}

#pragma mark - 回复楼主 操作
- (void)replyBtnClick:(id)sender{
    
    NSLog(@"hahaha == %@  ,,, ",TOKEN);
    
    
    if ([EKLoginViewController showLoginVC:self from:@"inPage"]) {
        return;
    }
    if (self.thModel.closed == 1) {
        [self.view showHUDTitleView:@"該主題已被關閉，不能回覆" image:nil];
        return;
    }
    [self pushPostingVC:@"回覆樓主：,回覆" uname:nil];
}


#pragma mark 刷新 操作
- (IBAction)didRefreshAction:(UIButton *)sender {
    _pageInteger = 1;
    [self refreshInvdetailData];
}
- (void)pushWebViewVC:(NSString *)url title:(NSString *)title{
    [EKWebViewController showWebViewWithTitle:title forURL:url from:self];
}

#pragma mark 进入主题列表
- (void)mThemeTypeHeadAction {
    NSDictionary *param = @{@"fid":@(self.thModel.fid),
                            @"password":@(_password)
                            };
    [self showNextViewControllerName:@"BKThemeListViewController" params:param isPush:true];
}

#pragma mark 选择查看用户资料
- (void)didUserAction:(UIButton *)btn {
    InvitationDataModel *model = [self.dataSource objectAtIndex:btn.tag];
    if (model.authorid == [USERID integerValue]) {
        //点击用户自己，不可以查看资料
        return;
    }
    EKUserInformationViewController *userInfoVC = [[EKUserInformationViewController alloc] init];
    userInfoVC.userImageURLString = model.avatar;
    userInfoVC.name = model.author;
    userInfoVC.uid = [NSString stringWithFormat:@"%zd",model.authorid];
    [self.navigationController pushViewController:userInfoVC animated:true];
}

#pragma mark 进入评论页面
- (void)pushCommentAction:(UIButton *)btn {
    InvitationDataModel *model = [self.dataSource objectAtIndex:btn.tag];
    [CommentViewController pushCommentVC:model.tid pid:model.pid dataArr:model.comments vc:self];
}

#pragma mark 举报 操作
- (void)didReportAction:(UIButton *)btn {
       [self reportFloorIndex:btn.tag];
}

- (void)reportFloorIndex:(NSInteger)index {
    if ([EKLoginViewController showLoginVC:self from:@"inPage"]) return;
    InvitationDataModel *model = [self.dataSource objectAtIndex:index];
    [self pushPostingVC:@"舉報帖子" uname:@{@"isquote":@(model.isquote),
                                          @"pid":@(model.pid)
                                        }];
}

#pragma  mark 管理选项 操作
- (void)didManageAction:(UIButton *)btn {
}

#pragma mark 编辑帖子操作
- (void)didSelectEditAction:(UIButton *)btn {
    BKSendThemeViewController *sendVC = [[BKSendThemeViewController alloc] init];
    [sendVC setParames:@{@"title":self.thModel.subject,
                         @"fid":@(self.thModel.fid),
                         @"threadtypes":self.thModel.threadtypes,
                         @"password":@(_password)
                         }];
    sendVC.model = [self.dataSource objectAtIndex:btn.tag];

    EKNavigationViewController *nav = [[EKNavigationViewController alloc] initWithRootViewController:sendVC];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma  mark 引用回复 操作
- (void)didRevertAction:(UIButton *)btn{
    if ([EKLoginViewController showLoginVC:self from:@"inPage"]) {
        return;
    }
    if (self.thModel.closed == 1) {
        [self.view showHUDTitleView:@"該主題已被關閉，不能回覆" image:nil];
        return;
    }
    if (btn.tag == 0) {
        [self pushPostingVC:@"回覆樓主：,引用回覆" uname:nil];
    } else {
        InvitationDataModel *model = [self.dataSource objectAtIndex:btn.tag];
        NSDictionary *param = @{@"isquote":@(model.isquote),
                                @"pid":@(model.pid)};
        [self pushPostingVC:[NSString stringWithFormat:@"引用%@的發帖:",model.author] uname:param];
    }
}
//跳转页面
- (void)pushPostingVC:(NSString *)name uname:(NSDictionary *)dic {
    NSDictionary *param = @{@"title":name,
                            @"repid":dic[@"pid"],
                            @"isquote":dic[@"isquote"],
                            @"fid":@(self.thModel.fid),
                            @"tid":self.tid,
                            @"password":@(_password)
                            };
    [self showNextViewControllerName:@"BKReportViewController" params:param isPush:NO];
}

#pragma mark - EKCornerSelectMenuViewDelegate 切换 "全部帖子""只看楼主"
- (void)mEKCornerSelectMenuView:(EKCornerSelectMenuView *)selectMenuView
              didClickWithIndex:(NSInteger)index {
    self.navLeftView.userInteractionEnabled = NO;
    self.vSelectNavIndex = index;
    if (index == 0) {
        _authorid = 0;
    } else {
        _authorid = selectMenuView.tag;
    }
    _pageInteger = 1;
    [self loadDataSource];
}

#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    _tableView.mj_footer.hidden = _dataSource.count == 0;
    if (section == 0)  return 1;
    return _dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) return 75;
    NSInteger row = indexPath.row;
    InvitationDataModel *model = [_dataSource objectAtIndex:row];
    CGFloat cellHeight = model.viewHeight;
    if (!model.typeView) {
        cellHeight = model.viewHeight + model.restHeight;
    }
    //判断是否是活动贴并且是一楼
    if (threadType == ThreadTypeActivity && [model.number isEqualToString:@"1樓"]) {
        cellHeight += kActivityViewHeight;
    } else if (threadType == ThreadTypePolls && [model.number isEqualToString:@"1樓"]){
        //判断是否是投票贴并且是一楼
        cellHeight += kPollsViewHeight;
    }
    return cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //表头标题cell
        EKThemeDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:defHeadCell forIndexPath:indexPath];
        cell.delegate = self;
        [cell uploadHeadListData:self.thModel];
        return cell;
    }
    static NSString *cellNormal = @"CellNormal";
    NSInteger row = indexPath.row;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorInset = UIEdgeInsetsZero;
    InvitationDataModel *model = [_dataSource objectAtIndex:row];
    if (nil == model.typeView) {
        //model.delegate = self;
        InvitationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defineCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor EKColorBackground];
        cell.textView.delegate = self;
        model.ismoderator = self.thModel.ismoderator;//判断用户是否具备管理权限
        [self cellForRowInvitationViewCell:cell index:row];
        cell.item = model;
        
        //判断是否是活动贴并且是一楼
        if (threadType == ThreadTypeActivity && [model.number isEqualToString:@"1樓"]) {            
            cell.threadacts = _dictThreadacts;
            cell.threadType = ThreadTypeActivity;
            cell.activityView.viewController = self;
            cell.activityView.activityisOver = self.thModel.activityisover;
            cell.activityView.activityStatus = self.thModel.activitystatus;
            cell.activityView.tid = _tid;
        } else if (threadType == ThreadTypePolls && [model.number isEqualToString:@"1樓"]) {
            //判斷是投票貼並且是一樓
            cell.threadType = ThreadTypePolls;
            cell.pollsView.threadpolls = _dictThreadpolls;
            cell.pollsView.tid = _tid;
            cell.pollsView.viewController = self;
        } else {
            cell.threadType = ThreadTypeNormal;
        }
        return cell;
    } else {
        UITableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:cellNormal];
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNormal];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsZero;
        }
        BKBannerAdView *typeView = (BKBannerAdView *)[cell.contentView viewWithTag:viewTag];
        if (typeView != nil) {
            [typeView removeFromSuperview];
        }
        //添加广告VIEW
        [cell.contentView addSubview:model.typeView];
        model.typeView.tag = viewTag;
        return cell;
    }
}


- (void)cellForRowInvitationViewCell:(InvitationViewCell *)cell index:(NSInteger)row{
    cell.textView.tag   = row;
    cell.iconBtn.tag    = row;
    cell.commentBtn.tag = row;
    cell.reportBtn.tag  = row;
    cell.manageBtn.tag  = row;
    cell.revertBtn.tag  = row;
    cell.editBtn.tag    = row;
    
    [cell.iconBtn    addTarget:self action:@selector(didUserAction:)      forControlEvents:UIControlEventTouchUpInside];
    [cell.commentBtn addTarget:self action:@selector(pushCommentAction:)  forControlEvents:UIControlEventTouchUpInside];
    [cell.reportBtn  addTarget:self action:@selector(didReportAction:)    forControlEvents:UIControlEventTouchUpInside];
    [cell.manageBtn  addTarget:self action:@selector(didManageAction:)    forControlEvents:UIControlEventTouchUpInside];
    [cell.editBtn    addTarget:self action:@selector(didSelectEditAction:)forControlEvents:UIControlEventTouchUpInside];
    [cell.revertBtn  addTarget:self action:@selector(didRevertAction:)    forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 键盘监听
- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    _keyboardHeight = height;
}

#pragma mark  - UIActionSheetDelegate
- (void)actionSheet:(LGActionSheet *)actionSheet buttonPressedWithTitle:(NSString *)title index:(NSUInteger)index
{
    if ( actionSheet.tag == 100 ) {
        //改变帖子文字字号
        switch (index) {
            case 0:{
                _textSize = 2;
                [BModelData sharedInstance].font = DetailSize_Max;
            }
                break;
            case 1:{
                _textSize = 0;
                [BModelData sharedInstance].font = DetailSize_Middle;
            }
                break;
            default:{
                _textSize = 1;
                [BModelData sharedInstance].font = DetailSize_Small;
            }
                break;
        }

        //更新帖子内容
        [self uniteLoadData];
    }
    
}

#pragma mark - UIAlertViewDelegate
- (void)addAlertViewAction
{
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
            _password = [textField.text integerValue];
            [self loadDataSource];
        }
    } cancelAction:^(UIAlertAction *action, NSArray<UITextField *> *textFields) {
        [self mTouchBackBarButton];
    }];
}

#pragma mark -  InvitationDataModelDelegate 
//刷新TextView
- (void)updataTextViewData:(NSDictionary *)dic{
    NSUInteger row = [dic[@"tag"] integerValue];
    InvitationDataModel *model = [_dataSource objectAtIndex:row];
    
    if (model.imgUrls.count == 0 || _dataSource.count == 0) {
        //没有图片不需要再次刷新
        return;
    }
    
    model.attString = dic[@"attString"];
    model.viewWidth = [dic[@"width"] floatValue];
    model.viewHeight = [dic[@"height"] floatValue];
   
    
    NSInteger flagsRow = [self tableView:_tableView numberOfRowsInSection:0];
    if (row > flagsRow) {
        NSLog(@"attempt to insert row 2 into section 0, but there are only 0 rows in section 0 after the update");
        return;
    }
    NSIndexPath *iPath = [NSIndexPath indexPathForRow:row inSection:1];
    [_tableView reloadRowsAtIndexPaths:@[iPath] withRowAnimation:UITableViewRowAnimationAutomatic];

}
- (BOOL)pushWebViewLink:(NSString *)imgurl forData:(InvitationDataModel *)model{
    BOOL showWeb = NO;
    for (NSArray *item in model.linkImgs) {
        if ([item[1] isEqualToString:imgurl]) {
            [EKWebViewController showWebViewWithTitle:@"" forURL:item[0] from:self];
            showWeb = YES;
            continue;
        }
    }
    return showWeb;
}
#pragma mark UITextView **** 帖子内容点击图片和链接代理方法*****
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    //判断没有登录的话去登陆页
    if ([EKLoginViewController showLoginVC:self from:@"inPage"]) {
        _isRefreshPicture = YES;
        return YES;
    }
    
    InvitationDataModel *model = [_dataSource objectAtIndex:textView.tag];
      //判断点击是否是警告图标
    if ([textAttachment.imageURL isEqualToString:@"jinggaoicon"] && model.ismoderator == 1) {
        NSString *message = [NSString stringWithFormat:@"%@已經被警告%ld次，如再次違規，將有可能被禁止訪問。",model.author,(long)model.warningnumber];
        
        [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"確定", nil] show];
        return YES;
    }
    
    if ([self pushWebViewLink:textAttachment.imageURL forData:model]) {
        return YES;
    }
    
    
    NSArray *arrImgs = model.imgUrls;
    if ( arrImgs.count ) {
        __block NSInteger index = 0;  //标记点击哪一个图片
        __block BOOL isImg = NO;      //判断点击是否有匹配的图片 ，是的话才可以浏览图片
        [arrImgs enumerateObjectsUsingBlock:^(NSString *url, NSUInteger idx, BOOL *stop) {
            if ([url isEqualToString:textAttachment.imageURL]) {
                index = idx;
                *stop = true;
                isImg = YES;
                return ;
            }
        }];
        if (isImg) {
            //后台返回的都是缩略图，去掉后缀_thumb.jpg得到原始图（示例：下面两个后台返回的图片地址jpg，gif两种类型）
            //处理图片为原图
            NSMutableArray *imgArray = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < arrImgs.count; i++) {
                NSString *imgUrl = [arrImgs objectAtIndex:i];
                if ([imgUrl hasSuffix:@"thumb.jpg"]) {
                    //去掉_thumb.jpg后缀，得到原始图
                    NSArray *array = [imgUrl componentsSeparatedByString:@"_thumb.jpg"]; //从字符A中分隔成2个元素的数组
                    [imgArray addObject:[array objectAtIndex:0]];
                } else {
                    [imgArray addObject:imgUrl];
                }
            }
            [self touchTextViewImageUrl:imgArray index:index];
        }
    }
    return YES;
}

#pragma Mark delegate 帖子内容点击事件处理
- (void)touchTextViewImageUrl:(NSArray *)urls index:(NSInteger)index
{
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 淡入淡出效果
    pickerBrowser.status = UIViewAnimationAnimationStatusFade;
    // 数据源/delegate
    pickerBrowser.editing = YES;
    pickerBrowser.editText = @"保存";
    pickerBrowser.photos = [NSArray setPhotoPickerPhotos:urls urlKey:nil];
    // 能够删除
    pickerBrowser.delegate = self;
    // 当前选中的值
    pickerBrowser.currentIndex = index;
    // 展示控制器
    [pickerBrowser showPickerVc:self];
    
}

#pragma  - 点击链接对应的帖子跳转
- (void)selectLinkAction:(NSString *)link {
    DLog(@"link = %@",link);
    [self pushWebViewVC:link title:@""];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    [self pushWebViewVC:URL.absoluteString title:@""];
    return iOS9 ? NO : YES;
}


#pragma mark - 逻辑处理模块
//队列
- (dispatch_queue_t)apiRequestQueue{
    if (!_apiRequestQueue) {
        _apiRequestQueue = dispatch_queue_create("BAPIRequestQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _apiRequestQueue;
}

- (EKThemeDetailPresenter *)vPresenter {
    if (!_vPresenter) {
        _vPresenter = [[EKThemeDetailPresenter alloc] init];
    }
    return _vPresenter;
}

//右边菜单栏
- (NSArray *)createMenuItems {
    NSArray *images = @[@"list_more_share_n",
                        @"list_more_size_n",
                        @"list_more_positive_n",
                        @"list_more_collection_n",
                        @"list_more_reply_n"];
    NSMutableArray *itemsView = [NSMutableArray arrayWithCapacity:images.count];
    int i = 0;
    for (NSString *imageName in images) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:imageName];
        [button setImage:image forState:UIControlStateNormal];
        button.frame = CGRectMake(0.f, 0.f, image.w, image.h);
        button.tag = i++;
        [button addTarget:self action:@selector(tapBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [itemsView addObject:button];
        if (i == 3) {
            [button setImage:[UIImage imageNamed:@"list_more_reverse_n"] forState:UIControlStateSelected];
            self.vTaxisBtn = button;
        } else if (i == 4) {
            [button setImage:[UIImage imageNamed:@"list_more_collection_a_n"] forState:UIControlStateSelected];
            self.vCollectBtn = button;
        }
    }
    return [itemsView copy];
}


@end
