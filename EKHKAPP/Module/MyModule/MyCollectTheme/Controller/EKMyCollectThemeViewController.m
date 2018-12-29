/**
 -  EKMyCollectThemeViewController.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/27.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"个人中心"界面进入的"主题收藏"界面
 */

#import "EKMyCollectThemeViewController.h"
#import "EKMyThemeCell.h"
#import "EKThemeDetailViewController.h"

@interface EKMyCollectThemeViewController () <UITableViewDataSource, UITableViewDelegate>
//主体的tableView
@property (weak, nonatomic) IBOutlet UITableView *vTableView;
//后台返回的数据源数组
@property (strong, nonatomic) NSMutableArray <EKMyCollectModel *> *vMyCollectThemeDataSource;
//记录当前的page参数
@property (assign, nonatomic) NSInteger vPage;
@end

@implementation EKMyCollectThemeViewController
#pragma mark - 初始化UI
- (void)mInitUI {
    self.title = @"主題收藏";
    self.automaticallyAdjustsScrollViewInsets = NO;
    //注册cell
    UINib *myCollectNib = [UINib nibWithNibName:@"EKMyThemeCell" bundle:nil];
    [_vTableView registerNib:myCollectNib forCellReuseIdentifier:myThemeCellID];
    _vTableView.tableFooterView = [[UIView alloc] init];
    _vTableView.rowHeight = 66;
    _vTableView.separatorColor = [UIColor EKColorSeperateWhite];
    _vTableView.separatorInset = UIEdgeInsetsZero;
    
    //添加上下拉刷新控件
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(mLoadData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _vTableView.mj_header = header;
    _vTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(mLoadData)];
    _vTableView.mj_footer.hidden = YES;
}


#pragma mark - 初始化数据
- (void)mInitData {
    _vMyCollectThemeDataSource = [NSMutableArray array];
    _vPage = 1;
    [_vTableView.mj_header beginRefreshing];
}


#pragma mark - 上下拉刷新控件监听事件
- (void)mLoadData {
    //先获取到当前tableView的现在的page参数,再根据上下拉控件的动画情况生成需要发送给后台的page参数
    NSInteger currentPage = _vPage;
    if (_vTableView.mj_header.isRefreshing) {
        currentPage = 1;
        [_vTableView.mj_footer resetNoMoreData];
    } else if (_vTableView.mj_footer.isRefreshing) {
        currentPage ++;
    }
    [EKMyCollectModel mRequestMyCollectModelDataSourceWithType:EKMyCollectModelTypeThread
                                                          page:currentPage
                                                      callBack:^(NSString *netErr, NSArray<EKMyCollectModel *> *data) {
                                                          if (netErr) {
                                                              [self.view showError:netErr];
                                                              [_vTableView mEndRefresh];
                                                          } else {
                                                              if (_vTableView.mj_header.isRefreshing) {
                                                                  //处理下拉刷新的情况
                                                                  _vMyCollectThemeDataSource = [NSMutableArray arrayWithArray:data];
                                                                  _vPage = currentPage;
                                                                  [_vTableView.mj_header endRefreshing];
                                                              } else if (_vTableView.mj_footer.isRefreshing) {
                                                                  //处理上拉刷新的情况
                                                                  if (data.count) {
                                                                      //处理有数据返回的情况
                                                                      [_vMyCollectThemeDataSource addObjectsFromArray:data];
                                                                      _vPage = currentPage;
                                                                      [_vTableView.mj_footer endRefreshing];
                                                                  } else {
                                                                      //处理没有数据返回的情况
                                                                      [_vTableView.mj_footer endRefreshingWithNoMoreData];
                                                                  }
                                                              }
                                                              [_vTableView reloadData];
                                                          }
                                                      }];
}


#pragma mark - UITableViewDataSource
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    tableView.mj_footer.hidden = !_vMyCollectThemeDataSource.count;
    return _vMyCollectThemeDataSource.count;
}


//返回cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EKMyThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:myThemeCellID forIndexPath:indexPath];
    cell.vMyCollectModel = _vMyCollectThemeDataSource[indexPath.row];
    return cell;
}


//开启侧滑编辑效果
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


#pragma mark - UITableViewDelegate
//点击时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //跳转到"帖子详情"界面
    EKMyCollectModel *myCollectModel = _vMyCollectThemeDataSource[indexPath.row];
    EKThemeDetailViewController *detailViewController = [[EKThemeDetailViewController alloc] init];
    detailViewController.tid = [NSNumber numberWithInteger:myCollectModel.id.integerValue];
    [self.navigationController pushViewController:detailViewController animated:YES];
}


//设置侧滑文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"取消收藏";
}


//设置侧滑取消收藏逻辑
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EKMyCollectModel *myCollectModel = _vMyCollectThemeDataSource[indexPath.row];
        NSDictionary *parameter = @{@"token" : TOKEN,
                                    @"favid" : @(myCollectModel.favid)};
        [self.view showHUDActivityView:@"正在取消收藏..." shade:NO];
        [EKHttpUtil mHttpWithUrl:kCollectCancelURL parameter:parameter response:^(BKNetworkModel *model, NSString *netErr) {
            [self.view removeHUDActivity];
            if (netErr) {
                [self.view showError:netErr];
            } else {
                if (1 == model.status) {
                    [_vMyCollectThemeDataSource removeObjectAtIndex:indexPath.row];
                    [_vTableView reloadData];
                    [self.view showSuccess:model.message];
                } else {
                    [self.view showError:model.message];
                }
            }
        }];
    }
}


@end
