/**
 - BKMobile
 - RegisterViewController.h
 - Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
 - Created by Guibin on 15/10/21.
 - 说明：注册页面
 */

#import <UIKit/UIKit.h>

@interface RegisterViewController : EKBaseViewController

@property (nonatomic , copy) void (^ pushHomePageVC )(NSDictionary *info);
@end
