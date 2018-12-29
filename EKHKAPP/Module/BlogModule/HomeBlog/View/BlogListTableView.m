/**
 -  BlogListTableView.m
 -  EKHKAPP
 -  Created by HY on 2017/11/1.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：日志页面 列表 tableview的数据为分页请求，每次只展示一页数据
 */

#import "BlogListTableView.h"
#import "BlogListCell.h"
#import "BlogListModel.h"
#import "EKUserInformationViewController.h"
#import "BlogWebViewController.h"

static NSString *BLOG_CELL = @"BlogListCell";

@interface BlogListTableView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) NSMutableArray *dataSource;
@property (nonatomic , assign) BOOL changePage;
//Yes代表下拉刷新，No代表上啦加载更多
@property (nonatomic , assign) BOOL isPullRefresh;

@end;

@implementation BlogListTableView

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _page = 1;
        //添加刷新方法
        [self addRefreshing];
    }
    return self;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UITableView *)tabView{
    if (!_tabView) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabView.translatesAutoresizingMaskIntoConstraints = NO;
        _tabView.backgroundColor = [UIColor EKColorBackground];
        [self addSubview:_tabView];
        
        [_tabView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self);
        }];

        //注册xib
        [_tabView registerNib:[UINib nibWithNibName:BLOG_CELL bundle:nil] forCellReuseIdentifier:BLOG_CELL];
    }
    return _tabView;
}

#pragma mark - 刷新模块：添加表头表尾的刷新控件
- (void)addRefreshing{
    
    //添加刷新功能
    [self.tabView mGifRefresh:self action:@selector(mRefreshAction)];
    [self.tabView mGifLoadMore:self action:@selector(mLoadMoreAction)];

}

#pragma mark - 刷新模块：下拉刷新
- (void)mRefreshAction{
    _isPullRefresh = YES;
    if (!_changePage) {
        _changePage = YES;
    } else {
        _page --;
        if (_page < 1) {
            _page = 1;
        }
    }
    [_tabView.mj_footer resetNoMoreData];
    [self refreshData];
}

#pragma mark - 刷新模块：上拉加载更多
- (void)mLoadMoreAction{
    _isPullRefresh = NO;
    _page ++;
    [self refreshData];
}

#pragma mark - 该方法用于外部调用：这里只是刷新，不再做page修改
- (void)requestLoadData{
    _changePage = NO;
    [_tabView.mj_header beginRefreshing];
}

#pragma mark - 网络请求
- (void)refreshData{
    self.controller.vSelectMenuView.userInteractionEnabled = NO;
    [self showHUDActivityView:@"正在加載..." shade:NO];
    NSString *catId = [NSString stringWithFormat:@"%ld",(long)_blogTypeModel.catid];

    //设置刷新控件的文字，下拉刷新第几页等文字
    [_tabView mSettingRefreshTitleWithPage:_page];
    
    [BlogListModel mRequestBlogListWithId:catId order:_order page:_page block:^(NSArray *data, NSString *netErr) {
        
        self.controller.vSelectMenuView.userInteractionEnabled = YES;
        [self removeHUDActivity];
        [_tabView mEndRefresh];
        
        if (netErr) {
            [self showHUDTitleView:netErr image:nil];
            if ([netErr isEqualToString:NOT_DATA_MESSAGE]) {
                [_tabView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [self.dataSource setArray:data];
            [_tabView reloadData];
            [_tabView layoutIfNeeded];
            //表滚动逻辑
            if (_isPullRefresh && _page != 1) {
                [self mTableScrollToBottom];
            } else {
                [self mTableScrollToTop];
            }
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    _tabView.mj_footer.hidden = self.dataSource.count ? NO : YES;
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BlogListCell *cell = [_tabView dequeueReusableCellWithIdentifier:BLOG_CELL forIndexPath:indexPath];
    [cell mRefreshBlogCell:_dataSource[indexPath.row] type:EKBlogCellTypeWithNormalBlog];
    
    //用戶頭像操作
    cell.userIcon.tag = indexPath.row;
    [cell.userIcon addTarget:self action:@selector(mTouchUserIconClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BlogListModel *model = _dataSource[indexPath.row];
    if (model.blogid == 0) {
        return 50;
    }
    return model.vHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BlogListModel *model = _dataSource[indexPath.row];
    BlogWebViewController *webVC = [[BlogWebViewController alloc] init];
    webVC.name = model.subject;
    webVC.ispassword = model.ispassword;
    webVC.uid = [NSString stringWithFormat:@"%d",(int)model.uid];
    webVC.tid = [NSString stringWithFormat:@"%d",(int)model.blogid];
    [self.controller.navigationController pushViewController:webVC animated:YES];
}

- (void)mTouchUserIconClick:(UIButton *)btn{
    BlogListModel *model = [_dataSource objectAtIndex:btn.tag];
    if (model.uid == [USERID integerValue]) {
        //点击用户自己，不可以查看资料
        return;
    }
    EKUserInformationViewController *userInformationViewController = [[EKUserInformationViewController alloc] init];
    userInformationViewController.userImageURLString = model.avatar;
    userInformationViewController.uid = [NSString stringWithFormat:@"%d",(int)model.uid];
    userInformationViewController.name = model.username;
    [self.controller.navigationController pushViewController:userInformationViewController animated:YES];
}

#pragma mark - 其他逻辑
 //设置表滚动到最顶部
- (void)mTableScrollToTop {
    //reloadDate会在主队列执行，而dispatch_get_main_queue会等待机会，直到主队列空闲才执行。防止滚动不精确
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tabView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    });
}

//设置表滚动到最底部
- (void)mTableScrollToBottom {

    if (_dataSource.count > 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat row = _dataSource.count - 1;
            [_tabView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    }
}

@end
