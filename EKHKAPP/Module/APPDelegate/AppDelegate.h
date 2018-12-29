/**
 - AppDelegate.h
 - EKHKAPP
 - Created by HY on 2017/9/7.
 - Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import <UIKit/UIKit.h>
//@import RetchatAnalytics;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)share;

//重新注册通知
- (void)registerNotification;

@end

//专业处理AppDelegate中的配置信息
#import "AppDelegate+EKAppConfig.h"
#import "AppDelegate+BKPushNotification.h"
