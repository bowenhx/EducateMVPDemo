/**
 -  MyBlogViewController.m
 -  EKHKAPP
 -  Created by HY on 2017/11/2.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：我的日志页面
 */

#import "MyBlogViewController.h"
#import "BlogListCell.h"
#import "BlogWebViewController.h"
#import "PublishBlogViewController.h"

static NSString *BLOG_CELL = @"BlogListCell";

@interface MyBlogViewController () <UITableViewDelegate,UITableViewDataSource>

//UITableView
@property (weak, nonatomic) IBOutlet UITableView *vTableView;

//表数据源
@property (nonatomic , strong) NSMutableArray *dataSource;

//分页请求的page
@property (nonatomic , assign) NSInteger page;

@end

@implementation MyBlogViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPublishBlogSuccessNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的日誌";
    [self.vRightBarButton setTitle:@"發佈" forState:UIControlStateNormal];
    _vTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _vTableView.translatesAutoresizingMaskIntoConstraints = NO;
    _vTableView.allowsSelection = YES; //避免cell点击无响应
    [_vTableView registerNib:[UINib nibWithNibName:BLOG_CELL bundle:nil] forCellReuseIdentifier:BLOG_CELL];
    [self addRefreshing];
    
    //发布日志成功后，刷新当前页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mRefreshFirstPageData) name:kPublishBlogSuccessNotification object:nil];
}

- (void)mRefreshFirstPageData {
    _page = 1;
    [_dataSource removeAllObjects];
    [_vTableView.mj_footer resetNoMoreData];
    [self mRequestData];
}

#pragma mark - 刷新模块：添加表头表尾的刷新控件
- (void)addRefreshing{
    //添加下拉刷新功能
    @WEAKSELF(self);
    MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [selfWeak mRefreshFirstPageData];
    }];
    [gifHeader beginRefreshing];
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    _vTableView.mj_header = gifHeader;
    
    //添加上拉加载更多功能
    MJRefreshBackGifFooter *gifFooter = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        selfWeak.page ++;
        [selfWeak mRequestData];
    }];
    _vTableView.mj_footer = gifFooter;
}

//数据请求
- (void)mRequestData {
    [self.view showHUDActivityView:@"正在加載..." shade:NO];
    [BlogListModel mRequestMyBlogListWithPage:_page block:^(NSArray *data, NSString *netErr) {
        [self.view removeHUDActivity];
        [_vTableView mEndRefresh];
        if (netErr) {
            [self.view showHUDTitleView:netErr image:nil];
            if ([netErr hasPrefix:@"沒有更多"]) {
                [_vTableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [self.dataSource addObjectsFromArray:data];
            [_vTableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BlogListCell *cell = [tableView dequeueReusableCellWithIdentifier:BLOG_CELL forIndexPath:indexPath];
    [cell mRefreshBlogCell:_dataSource[indexPath.row] type:EKBlogCellTypeWithMyBlog];
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
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - 导航栏右侧,发布按钮
- (void)mTouchRightBarButton {
    DLog(@"发布日志");
    PublishBlogViewController *vc = [[PublishBlogViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 其他逻辑
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
