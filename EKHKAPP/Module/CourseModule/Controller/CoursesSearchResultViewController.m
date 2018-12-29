//
//  CoursesSearchResultViewController.m
//  EduKingdom
//
//  Created by HY on 16/7/6.
//  Copyright © 2016年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import "CoursesSearchResultViewController.h"
#import "CourseTableViewCell.h"
#import "CourseSearchModel.h"

@interface CoursesSearchResultViewController ()

@end

@implementation CoursesSearchResultViewController
- (void)dealloc {
    NSLog(@"%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = self.vNavTitle;
    vResultListArray = [[NSMutableArray alloc] init];
    __weak typeof(self)weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.vTableView.mj_footer resetNoMoreData];
        [weakSelf mReloadData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    _vTableView.mj_header = header;
    [_vTableView.mj_header beginRefreshing]; //自动刷新
    _vTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page += 1;
        [weakSelf mReloadData];
    }];
}

-(void)mReloadData{
    NSString *strPage = [NSString stringWithFormat:@"%zd",_page];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.vSourceParameter];
    [dic setObject:strPage forKey:@"page"];//分页
    [CourseSearchModel loadSearchResultData:dic pageType:0 block:^(NSArray *data, NSString *netErr) {
        [self.view removeHUDActivity];
        [_vTableView mEndRefresh];
        if (netErr) {
            [self.view showHUDTitleView:netErr image:nil];
        }
        if (data.count > 0) {
            if (1 == _page) {
                [vResultListArray removeAllObjects];
            }
            [vResultListArray addObjectsFromArray:data];
        }else{
            //请求成功，但是data中已经没有值，代表没有更多数据返回
            [_vTableView.mj_footer endRefreshingWithNoMoreData];
            [self.view showHUDTitleView:@"沒有更多數據" image:nil];
        }
        [_vTableView reloadData];
    }];
}


#pragma mark UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"CourseTableViewCell";
    CourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identify owner:nil options:nil] lastObject];
    }
    if (vResultListArray.count > 0) {
        [cell mRefreshCourseCell:indexPath.row data:[vResultListArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

//返回多少个区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    _vTableView.mj_footer.hidden = vResultListArray.count == 0;
    return 1;
}

//返回个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return vResultListArray.count;
}

//返回高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}


//点击单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    CourseSearchModel *model = [vResultListArray objectAtIndex:indexPath.row];
//    [EKWebViewController showWebViewWithTitle:@"課程詳情" forURL:model.weburl from:self];
}

@end
