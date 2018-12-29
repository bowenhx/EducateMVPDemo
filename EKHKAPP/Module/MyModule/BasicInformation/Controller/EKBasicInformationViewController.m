/**
 -  EKBasicInformationViewController.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/30.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:从"个人中心"界面的第0个cell的"资料"按钮进入的"基本资料"界面
 */

#import "EKBasicInformationViewController.h"
#import "EKBasicInformationCell.h"

@interface EKBasicInformationViewController () <UITableViewDataSource>
//主体的tableView
@property (weak, nonatomic) IBOutlet UITableView *vTableView;
//本地生成的用户的"基本资料"界面的表格数组
@property (strong, nonatomic) NSArray <NSString *> *vTextArray;
@end

@implementation EKBasicInformationViewController
- (void)mInitUI {
    self.title = @"基本資料";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor EKColorBackground];
    _vTableView.tableFooterView = [[UIView alloc] init];
    _vTableView.backgroundColor = [UIColor EKColorBackground];
    _vTableView.rowHeight = 43;
    [_vTableView registerClass:[EKBasicInformationCell class] forCellReuseIdentifier:basicInformationCellID];
}


- (void)mInitData {
    //获取到本地写好的表格文字数组
    _vTextArray = [EKBasicInformationModel mGetInformationViewControllerTextArray];
    //如果"个人中心"跳转进来的时候,没有传递基本资料字符串数组,则在此重新向后台获取
    if (!_vBasicInformationArray.count) {
        [self.view showHUDActivityView:kStartLoadingText shade:NO];
        [EKBasicInformationModel mRequestBasicInformationModelWithCallBack:^(NSString *netErr, EKBasicInformationModel *basicInformationModel) {
            [self.view removeHUDActivity];
            if (netErr) {
                [self.view showError:netErr];
            } else {
                _vBasicInformationArray = [basicInformationModel mChangeBasicInformationModelToArray];
                [_vTableView reloadData];
            }
        }];
    }
}


#pragma mark - UITableViewDataSource
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _vBasicInformationArray.count;
}


//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:basicInformationCellID forIndexPath:indexPath];
    cell.textLabel.text = _vTextArray[indexPath.row];
    cell.detailTextLabel.text = _vBasicInformationArray[indexPath.row];
    cell.textLabel.textColor = [UIColor EKColorTitleBlack];
    cell.detailTextLabel.textColor = [UIColor EKColorTitleBlack];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

@end
