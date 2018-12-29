/**
 -  EKSchoolListViewController.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/12.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:从"学校"界面跳入的"学校列表"界面,可从点击单元格或者点击搜索按钮进入
 */

#import "EKSchoolListViewController.h"
#import "EKSchoolListModel.h"
#import "EKSchoolListCell.h"
#import "BKThemeListViewController.h"
//cell的缓存标识符
static NSString * schoolListCellID = @"EKSchoolListCellID";

@interface EKSchoolListViewController () <UITableViewDelegate, UITableViewDataSource>
//主体的tableView
@property (weak, nonatomic) IBOutlet UITableView *vTableView;
//后台返回的学校数据源
@property (nonatomic, strong) NSArray <EKSchoolListModel *> *vSchoolListModelDataSource;
@end

@implementation EKSchoolListViewController
- (void)dealloc {
    NSLog(@"dealloc = %s",__func__);
}

#pragma mark - 初始化UI
- (void)mInitUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    UINib *cellNib = [UINib nibWithNibName:@"EKSchoolListCell" bundle:nil];
    [_vTableView registerNib:cellNib forCellReuseIdentifier:schoolListCellID];
    _vTableView.tableFooterView = [[UIView alloc] init];
    _vTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _vTableView.rowHeight = 47;
}


#pragma mark - 初始化数据
- (void)mInitData {
    [self.view showHUDActivityView:@"正在加載..." shade:NO];
    if (_areaID) {
        [EKSchoolListModel mRequestSchoolListModelDataWithAreaID:_areaID CallBack:^(NSArray<EKSchoolListModel *> *data, NSString *netErr) {
            [self.view removeHUDActivity];
            if (netErr) {
                [self.view showError:netErr];
            } else {
                _vSchoolListModelDataSource = data;
                [_vTableView reloadData];
            }
        }];
    } else if (_keyword) {
        [EKSchoolListModel mRequestSchoolListModelDataWithKeyword:_keyword callBack:^(NSArray<EKSchoolListModel *> *data, NSString *netErr) {
            [self.view removeHUDActivity];
            if (netErr) {
                [self.view showError:netErr];
            } else {
                _vSchoolListModelDataSource = data;
                [_vTableView reloadData];
            }
        }];
    }
}


#pragma mark - UITableViewDataSource
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _vSchoolListModelDataSource.count;
}


//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EKSchoolListCell *schoolListCell = [tableView dequeueReusableCellWithIdentifier:schoolListCellID];
    schoolListCell.vIndexPath = indexPath;
    schoolListCell.vSchoolListModel = _vSchoolListModelDataSource[indexPath.row];
    return schoolListCell;
}


#pragma mark - UITableViewDelegate
//点击cell的时候调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //跳转到对应的"主题列表"界面
    EKSchoolListModel *schoolListModel = _vSchoolListModelDataSource[indexPath.row];
    BKThemeListViewController *themeListViewController = [[BKThemeListViewController alloc] init];
    themeListViewController.vFid = schoolListModel.fid;
    [self.navigationController pushViewController:themeListViewController animated:YES];
}

@end
