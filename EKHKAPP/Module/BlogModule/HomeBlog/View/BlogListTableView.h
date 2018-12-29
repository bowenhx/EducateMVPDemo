/**
 -  BlogListTableView.h
 -  EKHKAPP
 -  Created by HY on 2017/11/1.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：日志页面 列表 tableview
 */

#import <UIKit/UIKit.h>
#import "BlogTypeModel.h"
#import "BlogListModel.h"
#import "BlogViewController.h"

@interface BlogListTableView : UIView

@property (nonatomic , strong) BlogViewController *controller;

@property (nonatomic , strong) UITableView *tabView;

//绑定分类catid 对象
@property (nonatomic , strong ) BlogTypeModel *blogTypeModel;

//绑定导航条大分类order
@property (nonatomic , copy)NSString *order;

@property (nonatomic , assign) NSInteger page;

//记录第一次点击刷新，用于第二次点击不再刷新该页面 yes代表第一次点击，no代表非第一次点击
@property (nonatomic , assign) BOOL isFirstTouch;

////手動下拉刷新,page 变化时的刷新
//- (void)pullLoadAction;

////手動上拉加载,page 有变化
//- (void)uploadingAction;

//自動刷新:这里只是刷新，不再做page 修改，用于外部调用
- (void)requestLoadData;

@end
