/**
 - AppDelegate+BKPushNotification.h
 - BKMobile
 - Created by HY on 2017/8/8.
 - Copyright © 2017年 BaByKingdom All rights reserved.
 - 说明：AppDelegate的分类，专业处理推送模块   //TODO: 推送模块，在重构后，一定要测试代码
 */

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate (BKPushNotification) <UNUserNotificationCenterDelegate>

//注册远程推送
- (void)mRegisterPushNotification;

@end
