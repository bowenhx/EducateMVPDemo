/**
 -  EKMyThemeViewController.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/25.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"个人中心"进入的"我的主题"界面
 -  也可从"用户个人资料"界面的"话题"按钮进入用于查看别人的话题和回复
 */

#import "EKMyThemeViewController.h"
#import "EKCornerSelectMenuView.h"
#import "EKMyThemeCell.h"
#import "EKMyReplyCell.h"
#import "EKMyThemeModel.h"

@interface EKMyThemeViewController () <EKCornerSelectMenuViewDelegate,
                                       UITableViewDelegate,
                                       UITableViewDataSource>
//顶部的选择视图
@property (strong, nonatomic) EKCornerSelectMenuView *vSelectMenuView;
//主体的scrollView
@property (weak, nonatomic) IBOutlet UIScrollView *vScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vScrollViewTopConstraint;
//管理两个tableView的数组
@property (nonatomic, strong) NSArray <UITableView *> *vTableViewArray;
//存放两种cell的高度的数组
@property (nonatomic, strong) NSArray <NSNumber *> *vCellHeightArray;
//存储后台返回的"我的主题"&"我的回复"的数据源数组
@property (nonatomic, strong) NSMutableArray <NSMutableArray <EKMyThemeModel *> *> *vMyThemeReplyDataSource;
//存储两个tableView当前刷新到的page参数
@property (nonatomic, strong) NSMutableArray <NSNumber *> *vPageArray;
//记录当前显示的tableView在数组中的下标
@property (nonatomic, assign) NSInteger vCurrentIndex;
@end

@implementation EKMyThemeViewController
#pragma mark - 初始化UI
- (void)mInitUI {
    if (_vUserName) {
        self.title = [NSString stringWithFormat:@"%@的話題",_vUserName];
    } else {
        self.title = @"帖子";
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self mInitSelectMenuView];
    [self mInitTableView];
    //适配ipX
    _vScrollViewTopConstraint.constant = 71 + NAV_BAR_HEIGHT;
}


//设置菜单选择视图
- (void)mInitSelectMenuView {
    _vSelectMenuView = [[EKCornerSelectMenuView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 280) / 2, 20 + NAV_BAR_HEIGHT, 280, 30)
                        titleArray:@[@"主題", @"回覆"] delegate:self type:EKCornerSelectMenuViewTypeNormal selectedIndex:0];
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
            [selfWeak mRefreshDataWithCurrentIndex:selfWeak.vCurrentIndex];
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        tableView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [selfWeak mRefreshDataWithCurrentIndex:selfWeak.vCurrentIndex];
        }];
        tableView.mj_footer.hidden = YES;
        tableView.mj_footer = footer;
    }
    //属性记录tableView数组
    _vTableViewArray = tempTableViewArray.copy;
    
    //注册cell
    UINib *myThemeCellNib = [UINib nibWithNibName:@"EKMyThemeCell" bundle:nil];
    [_vTableViewArray[0] registerNib:myThemeCellNib forCellReuseIdentifier:myThemeCellID];
    UINib *myReplyCellNib = [UINib nibWithNibName:@"EKMyReplyCell" bundle:nil];
    [_vTableViewArray[1] registerNib:myReplyCellNib forCellReuseIdentifier:myReplyCellID];
}


#pragma mark - 初始化数据
- (void)mInitData {
    //初始化数据源数组
    _vMyThemeReplyDataSource = [NSMutableArray array];
    NSInteger arrayCount = 2;
    for (NSInteger i = 0; i < arrayCount; i++) {
        NSMutableArray <EKMyThemeModel *> *array = [NSMutableArray array];
        [_vMyThemeReplyDataSource addObject:array];
    }
    
    //初始化page数组
    _vPageArray = [NSMutableArray arrayWithArray:@[@(1), @(1)]];
    //初始化cell高度数组
    _vCellHeightArray = @[@(66), @(75)];
    //初始化当前显示的tableView在数组中的下标
    _vCurrentIndex = 0;
    
    //默认一进入的时候,第0个tableView的头部视图下拉刷新加载网络数据
    [_vTableViewArray[_vCurrentIndex].mj_header beginRefreshing];
}


#pragma mark - 上下拉刷新控件监听事件
- (void)mRefreshDataWithCurrentIndex:(NSInteger)currentIndex {
    UITableView *currentTableView = _vTableViewArray[currentIndex];
    
    //先获取到当前tableView的现在的page参数,再根据上下拉控件的动画情况生成需要发送给后台的page参数
    NSInteger currentPage = _vPageArray[currentIndex].integerValue;
    if (currentTableView.mj_header.isRefreshing) {
        currentPage = 1;
        [currentTableView.mj_footer resetNoMoreData];
    } else if (currentTableView.mj_footer.isRefreshing) {
        currentPage ++;
    }
    [EKMyThemeModel mRequestMyThemeDataSourceWithType:currentIndex
                                                 page:currentPage
                                                  uid:(_vUid ? _vUid : @"")
                                             callBack:^(NSString *netErr, NSArray<EKMyThemeModel *> *data) {
                                                 if (netErr) {
                                                     if ([netErr isEqualToString:@"沒有更多數據"]) {
                                                         [currentTableView mEndRefresh];
                                                         [self.view showError:netErr];
                                                         [currentTableView.mj_footer endRefreshingWithNoMoreData];
                                                     } else {
                                                         [self.view showError:netErr];
                                                         [currentTableView mEndRefresh];
                                                     }
                                                 } else {
                                                     if (currentTableView.mj_header.isRefreshing) {
                                                         //处理下拉刷新的情况
                                                         _vMyThemeReplyDataSource[currentIndex] = [NSMutableArray arrayWithArray:data];
                                                         [currentTableView.mj_header endRefreshing];
                                                         _vPageArray[currentIndex] = @(currentPage);
                                                     } else if (currentTableView.mj_footer.isRefreshing) {
                                                         //处理上拉刷新的情况
                                                         if (data.count) {
                                                             //处理有数据返回的情况
                                                             [_vMyThemeReplyDataSource[currentIndex] addObjectsFromArray:data];
                                                             [currentTableView.mj_footer endRefreshing];
                                                             _vPageArray[currentIndex] = @(currentPage);
                                                         } else {
                                                             [currentTableView.mj_footer endRefreshingWithNoMoreData];
                                                         }
                                                     }
                                                     [currentTableView reloadData];
                                                 }
                                             }];
}


#pragma mark - UITableViewDataSource
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger index = [_vTableViewArray indexOfObject:tableView];
    NSInteger count = _vMyThemeReplyDataSource[index].count;
    tableView.mj_footer.hidden = !count;
    return count;
}


//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [_vTableViewArray indexOfObject:tableView];
    if (0 == index) {
        EKMyThemeCell *myThemeCell = [tableView dequeueReusableCellWithIdentifier:myThemeCellID forIndexPath:indexPath];
        myThemeCell.vMyThemeModel = _vMyThemeReplyDataSource[index][indexPath.row];
        return myThemeCell;
    } else {
        EKMyReplyCell *myReplyCell = [tableView dequeueReusableCellWithIdentifier:myReplyCellID forIndexPath:indexPath];
        myReplyCell.vMyThemeModel = _vMyThemeReplyDataSource[index][indexPath.row];
        return myReplyCell;
    }
}


#pragma mark - UITableViewDelegate
//返回高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [_vTableViewArray indexOfObject:tableView];
    return _vCellHeightArray[index].floatValue;
}


//点击时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //跳转到帖子详情
    NSInteger index = [_vTableViewArray indexOfObject:tableView];
    EKMyThemeModel *model = _vMyThemeReplyDataSource[index][indexPath.row];
    NSDictionary *parameter = @{@"tid" : @(model.tid),
                                @"password" : @"0",
                                @"pid" : model.pid
                                };
    [super showNextViewControllerName:@"EKThemeDetailViewController" params:parameter isPush:YES];
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
    if (_vMyThemeReplyDataSource[index].count) {
        return;
    }
    [_vTableViewArray[index].mj_header beginRefreshing];
}

@end
