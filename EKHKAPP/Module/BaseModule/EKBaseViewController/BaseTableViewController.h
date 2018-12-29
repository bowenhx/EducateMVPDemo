/**
 - BKMobile
 - BaseTableViewController.h
 - Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
 - Created by ligb on 16/12/7.
 - 说明：TableviewController 基类，涉及tableView的初始化，下拉刷新，上拉加载更多等操作，使用时需要指定tableView样式即可
 */


#import "EKBaseViewController.h"



typedef NS_ENUM(NSInteger, BTableStyle) {
    BTableViewStylePlain = 0,       // regular table view
    BITableViewStyleGrouped         // preferences style table view
};

/**
 子类有tableView需要写入tableView 代理方法，这里不做代理实现
 */
@interface BaseTableViewController : EKBaseViewController<UITableViewDelegate, UITableViewDataSource>


/**
 子类需指定table样式即可初始化tableView，--- <不 指 定 不 初 始 化>
 */
@property (nonatomic, assign) BTableStyle style;


/**
 子类需要设置tableView，特殊tableView 需要指定frame，默认整个屏幕
 */
@property (nonatomic , strong) UITableView *tableView;


/**
 数据源，使用self.dataSource即可初始化
 */
@property (nonatomic , strong) NSMutableArray *dataSource;


/**
 普通的tableView 上面添加线条
 */
- (void)addTabViewTopLineView;

/**
 添加下拉刷新block，block 是刷新回调方法，添加后立马刷新，后面还可以使用：
 [self.tableView.header beginRefreshing];
  @param block 回调刷新方法，
 */
- (void)addHeaderRefreshingBlock:(void (^)(void))block;


/**
 添加上拉加载更多方法,默认隐藏footer，
 子类使用：[self.tableView.footer beginRefreshing];
 @param block 回调加载更多方法
 */
- (void)addFooterRefreshingBlock:(void (^)(void))block;


/**
 隐藏上拉刷新或者上拉加载更多状态
 */
- (void)endRefresh;

@end
