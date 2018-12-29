//
//  NewCourseView.m
//  EduKingdom
//
//  Created by HY on 16/7/7.
//  Copyright © 2016年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import "NewCourseView.h"
#import "CourseTableViewCell.h"

@implementation NewCourseView

+(NewCourseView *)mGetInstance{
    NewCourseView *view = [[[NSBundle mainBundle] loadNibNamed:@"NewCourseView" owner:nil options:nil] firstObject];
    if (view) {
        [view mInit];
    }
    return view;
}
//初始化
- (void)mInit {
    self.vTableView.delegate = self;
    self.vTableView.dataSource = self;
    vResultListArray = [[NSMutableArray alloc] init];
    
    //添加刷新控件
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [_vTableView.mj_footer resetNoMoreData];
        [self mReloadData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    _vTableView.mj_header = header;
    [_vTableView.mj_header beginRefreshing]; //自动刷新
    
    _vTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page += 1;
        [self mReloadData];
    }];
}

-(void)mReloadData{
    NSString *strPage = [NSString stringWithFormat:@"%zd",_page];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:strPage forKey:@"page"];//分页
    [CourseSearchModel loadSearchResultData:dic pageType:1 block:^(NSArray *data, NSString *netErr) {
        [self.vTableView mEndRefresh];
        if (netErr) {
            [self showHUDTitleView:netErr image:nil];
        }
        if (data.count > 0) {
            if (1 == _page) {
                [vResultListArray removeAllObjects];
            }
            [vResultListArray addObjectsFromArray:data];
        }else{
            //请求成功，但是data中已经没有值，代表没有更多数据返回
            [self.vTableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.vTableView reloadData];
    }];
}


#pragma mark -
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
    self.vTableView.mj_footer.hidden = vResultListArray.count == 0;
    return 1;
}

//返回个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return vResultListArray.count;
}

//返回高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

//点击单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    CourseSearchModel *model = [vResultListArray objectAtIndex:indexPath.row];
    if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(mSelectRowClick:)]) {
        [self.vDelegate mSelectRowClick:model];
    }
    
}


@end
