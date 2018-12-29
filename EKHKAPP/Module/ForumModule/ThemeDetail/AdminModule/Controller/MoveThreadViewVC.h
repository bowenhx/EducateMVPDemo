/**
 - BKMobile
 - MoveThreadViewVC.h
 - Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
 - Created by Guibin on 15/12/1.
 - 说明： 移动主题页面
 */

#import "EKBaseViewController.h"
#import "ThreadsDetailModel.h"
@interface MoveThreadViewVC : EKBaseViewController

@property (nonatomic , copy)NSDictionary *dicInfo;

+ (void)push:(UIViewController *)vc model:(ThreadsDetailModel *)model;

@end
