//
//  UITableView+BKRefresh.h
//  BKHKAPP
//
//  Created by HY on 2017/8/17.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (BKRefresh)


/**
 添加普通下拉刷新

 @param action 下拉刷新所执行的方法
 */
- (void)mRefresh:(id)target  action:(SEL)action;


/**
 添加普通上拉加载更多

 @param action 上拉加载更多所执行的方法
 */
- (void)mLoadMore:(id)target  action:(SEL)action;


/**
 添加gif类型下拉刷新
 
 @param action 下拉刷新所执行的方法
 */
- (void)mGifRefresh:(id)target  action:(SEL)action;


/**
 添加gif类型上拉加载更多
 
 @param action 上拉加载更多所执行的方法
 */
- (void)mGifLoadMore:(id)target  action:(SEL)action;


/**
 停止刷新
 */
- (void)mEndRefresh;


- (void)mSettingRefreshTitleWithPage:(NSInteger)page;

@end



@interface MJRefreshGifHeader (BKRefreshTitleTool)

+ (void)setHeader:(MJRefreshGifHeader *)gifHeader foot:(MJRefreshBackGifFooter *)gifFooter page:(NSInteger)page;

@end
