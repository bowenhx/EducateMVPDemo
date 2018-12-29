//
//  ThreadActivityView.h
//  BKMobile
//
//  Created by 薇 颜 on 15/11/10.
//  Copyright © 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//
/**
 *  帖子内容页的活动信息展示块
 */
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ActivityStatus) {
    ActivityStatusNormal = 0,       /**<可以报名*/
    ActivityStatusFull = 1,         /**<名额已满*/
    ActivityStatusAlready = 2,      /**<已报名*/
    ActivityStatusAddMaterial = 3, /**<完善资料*/
    ActivityStatusCheck = 4, /**<已报名,等待审核*/
};

typedef NS_ENUM(NSInteger, ActivityisOver) {
    ActivityisOverNO = 0,       /**<未结束*/
    ActivityisOverYES = 1       /**<活动已结束*/
};

typedef NS_ENUM(NSInteger, ActivityViewType) {
    ActivityViewTypeIsHaveCost = 0,     /**<有活动费用*/
    ActivityViewTypeIsNoCost = 1        /**<没有活动费用*/
};

@protocol ThreadActivityViewDelegate <NSObject>

- (void)threadActivityViewChangeStatus:(ActivityStatus)status;

@end
@interface ThreadActivityView : UIView


@property (nonatomic, assign) ActivityStatus activityStatus;
@property (nonatomic, assign) ActivityisOver activityisOver;
@property (nonatomic, strong) NSDictionary *threadacts;/**<活动贴传递过来的信息*/
@property (nonatomic, strong) NSNumber *tid;        /**<帖子ID*/
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, assign) id<ThreadActivityViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withActivityViewType:(ActivityViewType)activityViewType;

- (void)changeStatus:(ActivityStatus)status;
@end
