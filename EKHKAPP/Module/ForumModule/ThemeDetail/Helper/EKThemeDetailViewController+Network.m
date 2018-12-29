//
//  EKThemeDetailViewController+Network.m
//  BKMobile
//
//  Created by HY on 16/6/17.
//  Copyright © 2016年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "EKThemeDetailViewController+Network.h"

@implementation EKThemeDetailViewController (Network)

#pragma mark 请求列表数据
- (void)loadDataSource {

    __weak typeof(self)selfWeak = self;
    //设置刷新文字
    [MJRefreshGifHeader setHeader:gifHeader foot:gifFooter page:_pageInteger];
    NSDictionary *dicInfor = @{@"token":TOKEN,
                                 @"tid":self.tid,
                                @"page":@(_pageInteger),
                           @"ordertype":@(_ordertype),
                            @"authorid":@(_authorid),
                               @"model":[BKTool getDeviceName],
                                  @"pw":@(self.password)};
    //进入页面加载loading
//    [self playLoading];
    [self.view showHUDActivityView:@"正在加載..." shade:NO];
    [EKHttpUtil mHttpWithUrl:kThemeDetailURL parameter:dicInfor response:^(BKNetworkModel *model, NSString *netErr) {
        [selfWeak.view removeHUDActivity];
        [selfWeak finishRefreshAction];
        selfWeak.navLeftView.userInteractionEnabled = YES;
        if (netErr) {
            [selfWeak.view showHUDTitleView:netErr image:nil];
        } else if (model.status == 1) {
            if ([model.data isKindOfClass:[NSDictionary class]]) {
                NSArray *dataArray = model.data[@"lists"];
                [_tempData removeAllObjects]; //清除数组，只存放最新一次请求到的数据
                if (_pageInteger == 1) {
                    if ([dataArray isKindOfClass:[NSArray class]] && dataArray.count) {
                        //获取楼主取，第一页的第一个id
                        selfWeak.navTitleView.tag = [dataArray[0][@"authorid"] integerValue];
                    }
                }
                
                ///需求更改后：清除所有数据，当前页面只显示最新一页的数据，之前是加载更多，累积添加数据
                if ([dataArray isKindOfClass:[NSArray class]] && dataArray.count) {
                    [_tempData setArray:dataArray];
                } else {
                    [selfWeak.view showHUDTitleView:@"沒有更多數據" image:nil];
                }
                
                
                //设置列表最大页码数
                [selfWeak loadMaxPage:model.data[@"page"]];
                //修改head 标题数据
                NSDictionary *threadsDic = model.data[@"threads"];
                if ([threadsDic isKindOfClass:[NSDictionary class]] && threadsDic.allKeys.count) {
                    [selfWeak changeHeadData:threadsDic];
                }
                //去合并数据显示数据
                [selfWeak uniteLoadData];
                
                //活动贴的数据
                selfWeak.dictThreadacts = model.data[@"threadacts"];
                //投票貼數據
                selfWeak.dictThreadpolls = model.data[@"threadpolls"];
                //当前数据页数和列表最大页数相等时变为没有更多数据状态
                if (_pageInteger == _maxPageNum) {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [_tableView.mj_footer resetNoMoreData];
                }
            } else {
                [selfWeak.view showHUDTitleView:model.message image:nil];
            }
            if (selfWeak.password) {
                //進入該頁面后，當密碼不為空時，存到本地字典中
                NSString *forumID = [NSString stringWithFormat:@"%@_%@",kForumPasswordKey,selfWeak.tid];
                NSDictionary *dic = [BKSaveData getDictionary:kForumPasswordKey];
                NSMutableDictionary *addPawDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [addPawDic setObject:@(selfWeak.password) forKey:forumID];
                [BKSaveData setDictionary:addPawDic key:kForumPasswordKey];
            }
            
        } else if (model.status == -1) {
            //需要输入密码访问,需要密碼時
            NSDictionary *forumDic = [BKSaveData getDictionary:kForumPasswordKey];
            NSString *forumID = [NSString stringWithFormat:@"%@_%@",kForumPasswordKey,selfWeak.tid];
            if (forumDic) {
                //當字典有值，取出對應的密碼來验证
                NSString *pw = forumDic[forumID];
                if (pw == nil || [pw isEqual:[NSNull null]]) {
                    //弹出密码输入框
                    [selfWeak addAlertViewAction];
                    
                } else {
                    selfWeak.password = [pw integerValue];
                    //验证密码请求
                    [selfWeak loadDataSource];
                }
                
            } else {
                //弹出密码输入框
                [selfWeak addAlertViewAction];
            }
            
        } else {
            [self.view showHUDTitleView:model.message image:nil];
            if ([model.message hasPrefix:@"沒有更多"])
                [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    
}

/**
 *  合并广告和远程数据
 */
- (void)uniteLoadData {
    //添加统计
    NSString *googleString = [NSString stringWithFormat:@"tid=%@&fid=%ld&page=%li",self.tid, (long)self.thModel.fid, (long)_pageInteger];
    NSDictionary *parameter = @{@"tid": @(self.thModel.tid).description,
                                @"fid" : @(self.thModel.fid).description,
                                @"page": @(_pageInteger).description};
    [super mAddAnalyticsWithPageIndex:kThemeDetailPageIndex
                 googleString:googleString
                    parameter:parameter];

    //需求更改后：清除所有数据，当前页面只显示最新一页的数据
    if (self.dataSource.count)  [self.dataSource removeAllObjects];
    
    //合并数据源
    NSArray *arrModels = [InvitationDataModel uniteData:_tempData adViews:self.vBannerArray delegate:self];
    
    [self.dataSource setArray:arrModels];
    
    //这里先去reload 计算number Rows
    [_tableView reloadData];
    
    //再去去定位到具体的楼层
    [self locationFloor];
}
- (void)locationFloor
{
    if (_pageInteger == 1 || _isLoadMore) {
        //设置表滚动到最顶部
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    } else {
        //设置表滚动到最底部
        if (self.dataSource.count > 0) {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count -1 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }

    /**
     *  定位到对应的回复楼层
     */
    if ( self.pid ) {
        ///遍历是第几楼层
        __block NSInteger index = 0;
        [self.dataSource enumerateObjectsUsingBlock:^(InvitationDataModel *data, NSUInteger idx, BOOL *stop) {
            if (data.pid == self.pid) {
                index = idx;
                *stop = true;
                return ;
            }
        }];
        
        NSInteger row = [_tableView numberOfRowsInSection:1];
        if (index < row) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                /**
                 *  显示回复的最新帖子
                 */
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                self.pid = 0;  //第一次进入定位以后，设置为0
            });
        }
    }
}


#pragma mark - 楼层定位处理
- (void)floorLocation:(NSInteger)pid {
    __weak typeof(self)selfWeak = self;
    [EKHttpUtil mHttpWithUrl:kThemeRedirectURL parameter:@{@"token":TOKEN,@"ptid":self.tid,@"pid":@(pid),@"order":@(_ordertype)} response:^(BKNetworkModel *model, NSString *netErr) {
        if (model.status == 1) {
            _pageInteger = [model.data[@"page"] integerValue];
            [selfWeak loadDataSource];
        }
    }];
}

#pragma mark - 取消收藏
-(void)cancelCollectClick:(UIButton *)btn{
    __weak typeof(self)selfWeak = self;
    [EKHttpUtil mHttpWithUrl:kCollectCancelURL parameter:@{@"token":TOKEN,@"favid":@(selfWeak.thModel.favid)} response:^(BKNetworkModel *model, NSString *netErr) {
        NSInteger reqStatus = model.status;
        if (netErr) {
            [selfWeak.view showHUDTitleView:netErr image:nil];
        } else if (reqStatus == 1) {
            btn.selected = !btn.selected;
            [selfWeak.view showSuccess:model.message];
            //修改数据源中
            selfWeak.thModel.favid = 0;
            [selfWeak updataCollectStatus];
        } else {
            [selfWeak.view showError:model.message];
        }
        btn.enabled = YES;
    }];
}

#pragma mark - 添加收藏
- (void)addCollectClick:(UIButton *)btn {
    __weak typeof(self)selfWeak = self;
    [EKHttpUtil mHttpWithUrl:kCollectAddURL parameter:@{@"token":TOKEN,@"type":@"thread",@"id":selfWeak.tid} response:^(BKNetworkModel *model, NSString *netErr) {
        NSInteger reqStatus = model.status;
        if (netErr) {
            [selfWeak.view showHUDTitleView:netErr image:nil];
        } else if (reqStatus == 1) {
            btn.selected = !btn.selected;
            [selfWeak.view showSuccess:model.message];
            //修改数据源中
            selfWeak.thModel.favid = [model.data[@"favid"] integerValue];
            [selfWeak updataCollectStatus];
        } else {
            [selfWeak.view showError:model.message];
        }
        btn.enabled = YES;
    }];
}

- (void)finishRefreshAction
{
    if ( [_tableView.mj_header isRefreshing] ) {
        [_tableView.mj_header endRefreshing];
    } else if ( [_tableView.mj_footer isRefreshing] ) {
        [_tableView.mj_footer endRefreshing];
    }
}

@end
