
//
//  UITableView+BKRefresh.m
//  BKHKAPP
//
//  Created by HY on 2017/8/17.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import "UITableView+BKRefresh.h"

@implementation UITableView (BKRefresh)

#pragma mark - 添加普通下拉刷新
- (void)mRefresh:(id)target  action:(SEL)action {
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
}

#pragma mark - 上拉普通加载更多
- (void)mLoadMore:(id)target  action:(SEL)action {
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
    [self.mj_footer setHidden:YES];
}


#pragma mark - 添加gif下拉刷新
- (void)mGifRefresh:(id)target  action:(SEL)action {
    MJRefreshGifHeader* gifHeader = [MJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:action];
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    self.mj_header = gifHeader;
}

#pragma mark - 上拉gif加载更多
- (void)mGifLoadMore:(id)target  action:(SEL)action {
    MJRefreshBackGifFooter* gifFooter = [MJRefreshBackGifFooter footerWithRefreshingTarget:target refreshingAction:action];
    self.mj_footer = gifFooter;
    self.mj_footer.hidden = YES;
}

#pragma mark - 停止刷新
- (void)mEndRefresh {
    if (self.mj_header.isRefreshing) {
        [self.mj_header endRefreshing];
    } else if (self.mj_footer.isRefreshing) {
        [self.mj_footer endRefreshing];
    }
}

#pragma mark - 设置下拉刷新的文字
-(void)mSettingRefreshTitleWithPage:(NSInteger)page{
    MJRefreshGifHeader *header = (MJRefreshGifHeader *)self.mj_header;
    MJRefreshBackGifFooter *footer = (MJRefreshBackGifFooter *)self.mj_footer;
    [MJRefreshGifHeader setHeader:header foot:footer page:page];
}

@end



@implementation MJRefreshGifHeader (BKRefreshTitleTool)

+ (void)setHeader:(MJRefreshGifHeader *)gifHeader foot:( MJRefreshBackGifFooter*)gifFooter page:(NSInteger)page{
    if (page < 1) page = 1;
    dispatch_async(dispatch_get_main_queue(), ^{
//        if (page <= 1) {

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                int tempPage = (int)page - 1;
                if (tempPage < 1) {
                    tempPage = 1;
                }
            
                NSString *strIdleTemp;
                NSString *strPullingTemp;
               
                if (tempPage == 1) {
                    strIdleTemp = [NSString stringWithFormat:@"下拉加載首頁"];
                    strPullingTemp = [NSString stringWithFormat:@"鬆開加載首頁"];
                } else {
                    strIdleTemp = [NSString stringWithFormat:@"下拉加載第%d頁",tempPage];
                    strPullingTemp = [NSString stringWithFormat:@"鬆開加載第%d頁",tempPage];
                }
                NSString *strRefreshingTemp = [NSString stringWithFormat:@"正在載入..."];
                
                // 设置文字
                [gifHeader setTitle:strIdleTemp forState:MJRefreshStateIdle];
                [gifHeader setTitle:strPullingTemp forState:MJRefreshStatePulling];
                [gifHeader setTitle:strRefreshingTemp forState:MJRefreshStateRefreshing];

            });
//        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSString *strIdle = [NSString stringWithFormat:@"上拉加載第%d頁",(int)page+1];
            NSString *strPulling = [NSString stringWithFormat:@"鬆開加載第%d頁",(int)page+1];
            NSString *strRefreshing = [NSString stringWithFormat:@"正在載入..."];
            [gifFooter setTitle:strIdle forState:MJRefreshStateIdle];
            [gifFooter setTitle:strPulling forState:MJRefreshStatePulling];
            [gifFooter setTitle:strRefreshing forState:MJRefreshStateRefreshing];
        });
    });
}

@end

