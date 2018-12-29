/**
 -  EKHomeTableView.h
 -  EKHKAPP
 -  Created by ligb on 2017/9/14.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：首页tableView
 */

#import <UIKit/UIKit.h>
#import "EKHomeTopUpDownAdvertiseModel.h"
#import "BKLoopImageView.h"
#import "BKLoopViewModel.h"
#import "EKHomeListModel.h"
#import "EKHomeActivityModel.h"
#import "EKHomeVoteModel.h"
#import "EKHomeADModel.h"
#import "BADBannerView.h"

@protocol EKHomeTableViewDelegate;

@interface EKHomeTableView : UIView

@property (nonatomic, strong) UITableView *vTableView;

//置顶左侧上下广告后台数据源
@property (nonatomic, strong) NSArray <EKHomeTopUpDownAdvertiseModel *> *vHomeTopUpDownAdvertiseDataSource;

//轮播banner后台数据源
@property (nonatomic, strong) NSArray <BKLoopViewModel *> *vHomeLoopImageViewDataSource;

//后台返回的列表数据源,包含论坛话题列表/bk milk文章列表/tv数据列表/kmall产品列表
@property (nonatomic, strong) EKHomeListModel *vHomeListModel;

//投票数据
@property (nonatomic, strong) EKHomeVoteModel *vOteModel;

//存储banner广告的数组
@property (nonatomic, strong) NSMutableArray <BADBannerView *> *vHomeBannerArray;

//自定义表头view
@property (nonatomic, strong) BKLoopImageView *vLoopImgView;

//代理对象
@property (nonatomic, weak) id <EKHomeTableViewDelegate> delegate;

/**
 更新活动日期的数据
 */
- (void)updataActivityDate;

@end


@protocol EKHomeTableViewDelegate <NSObject>
/**
 点击某个cell的时候调用

 @param indexPath cell的索引
 */
- (void)mHomeTableViewCellDidClickAtIndexpath:(NSIndexPath *)indexPath;


/**
 点击活动cell 调用

 @param activityModel 活动model
 */
- (void)mHomeTableViewTopActivityData:(EKHomeActivityEventModel *)activityModel;


/**
 置顶左侧上下广告的两个按钮,点击的时候调用

 @param index 点击的button的索引,0为上,1为下
 */
- (void)mHomeTableViewTopUpDownAdvertiseButtonDidClickWithIndex:(NSInteger)index;


/**
 BKMilk cell的组头点击的时候调用
 */
- (void)mHomeTableViewMilkMoreButtonDidClick;


/**
 TV cell 内 的"播放"按钮被点击的时候调用

 @param index 回传当前点击的tv cell的索引
 */
- (void)mHomeTableViewTVCellDidClickWithIndex:(NSInteger)index;


/**
 KMall cell 内的collectionViewCell被点击的时候调用

 @param index 回传当前点击的KMall cell 的index
 */
- (void)mHomeTableViewKMallCellDidClickWithIndex:(NSInteger)index;


/**
 投票时候，如果当前用户未登录，跳转到登录页面
 */
- (void)mUserNotLogigWithPush;

@end
