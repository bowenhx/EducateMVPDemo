/**
 - BKMobile
 - OpenThreadViewVC.h
 - Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
 - Created by Guibin on 15/12/1.
 - 说明： 打开或关闭主题
 */

#import "EKBaseViewController.h"
#import "ThreadsDetailModel.h"
@interface OpenThreadViewVC : EKBaseViewController

@property (nonatomic) BOOL isClosed;
@property (nonatomic, strong) NSDictionary *threadInfo;
@property (nonatomic) BOOL isFromThread;

/**
 进入打开或关闭主题页面

 @param vc ： 当前controller
 @param model 主题model
 */
+ (void)push:(UIViewController *)vc model:(ThreadsDetailModel *)model;


@end
