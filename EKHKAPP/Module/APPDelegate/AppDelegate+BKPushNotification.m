/**
 - AppDelegate+BKPushNotification.m
 - BKMobile
 - Created by HY on 2017/8/8.
 - Copyright © 2017年 BaByKingdom All rights reserved.
 - 说明：AppDelegate的分类，专业处理推送模块
 */

#import "AppDelegate+BKPushNotification.h"
#import "EKLoginViewController.h"
#import "BKUserHelper.h"
#import "EKThemeDetailViewController.h"
#import "EKRemotePushAlertController.h"

@implementation AppDelegate (BKPushNotification)
#pragma mark - 远程推送注册
//注册远程推送
- (void)mRegisterPushNotification {
    //注册推送
    if(iOS10) {
        //iOS10注册推送，获取授权
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"用户允许推送，注册通知成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@", settings);
                }];
            } else {
                NSLog(@"用户不允许推送，注册通知失败");
            }
        }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    } else {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)  categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}


//注册远程推送成功回调
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //客户端把deviceToken取出来发给服务端，push消息的时候要用。
    NSString* token = [NSString stringWithFormat:@"%@",deviceToken];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [BKSaveData setString:token key:kDeviceTokenKey];
    DLog(@"deviceToken= %@",token);
    
    //设置页面的推送开关，如果打开，把新生成的token发送到后台，才能接收到推送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kDeviceTokenNotification object:nil];
}


//注册远程推送失败回调
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DLog(@"注册远程失败 error = %@",error);
}


#pragma mark - ios10以下的推送代理方法
//程序在前台,接收到推送时调用
//程序在后台(程序未被杀死时),接收到通知,并且是通过点击通知的方式进入app的话,也会调用这个方法
-           (void)application:(UIApplication *)application
 didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo
       fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    [self mHandleNotificationLogic:userInfo];
}


#pragma mark - ios10以上的推送代理方法
//ios10以上，接收到推送通知（ios10本地通知跟远程通知合二为一）
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    [self mHandleNotificationLogic:notification.request.content.userInfo];
}


//ios10以上，处理点击通知的事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler {
    [self mHandleNotificationLogic:response.notification.request.content.userInfo];
}


#pragma mark - 自定义的方法,用来处理后台推送
/**
 处理推送

 @param dic 后台返回的推送的字典参数
 */
-(void)mHandleNotificationLogic:(NSDictionary *)dic{
    NSDictionary *aps = dic[@"aps"];
    if ([aps[@"type"] isEqualToString:@"JX"]) {
        //先提取出后面逻辑分支中可能会用到的变量
        NSString *openurl = aps[@"openurl"];
        NSString *title = aps[@"title"];
        UIViewController *currentController = self.window.visibleViewController;
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            //在前台接收到JX推送的话,得显示弹窗
            EKRemotePushAlertController *alertController = [EKRemotePushAlertController remotePushAlertControllerWithMessage:aps[@"title"]];
            if ([currentController isKindOfClass:[EKLoginViewController class]]) {
                //如果当前是登录界面,则需要在点击"查看"时,关闭登录界面后,再跳转到指定控制器,以避免导航栏消失BUG
                alertController.vCheckHandler = ^{
                    EKLoginViewController *loginViewController = (EKLoginViewController *)currentController;
                    [loginViewController dismissLoginViewWithCompletion:^{
                        [self mOpenControllerWithURL:openurl title:title viewController:self.window.visibleViewController];
                    }];
                };
            } else {
                alertController.vCheckHandler = ^{
                    [self mOpenControllerWithURL:openurl title:title viewController:currentController];
                };
            }
            [currentController presentViewController:alertController animated:YES completion:nil];
        } else {
            //从后台进入程序的话,直接跳转控制器
            [self mOpenControllerWithURL:openurl title:title viewController:currentController];
        }
    } else if ([aps[@"type"] isEqualToString:@"PM"]){
        //PM类型,发送通知,显示小红点
        [[NSNotificationCenter defaultCenter] postNotificationName:kRemotePushNotification object:nil userInfo:nil];
    }
}


/**
 收到推送时使用到的控制器跳转方法

 @param url 后台返回的URL
 @param title 后台返回的标题
 @param viewController 从哪个控制器进行跳转
 */
- (void)mOpenControllerWithURL:(NSString *)url title:(NSString *)title viewController:(UIViewController *)viewController {
    if (([url rangeOfString:@"openthread://"].location != NSNotFound) ||
        ([url rangeOfString:@"sendthread://"].location != NSNotFound)) {
        //解析URL
        NSArray *dirURL = [url componentsSeparatedByString:@"/"];
        NSNumber *tid = [dirURL objectAtIndex:4];//帖子ID
        EKThemeDetailViewController *detailViewController = [[EKThemeDetailViewController alloc] init];
        detailViewController.tid = tid;
        [viewController.navigationController pushViewController:detailViewController animated:YES];
    } else {
        [EKWebViewController showWebViewWithTitle:title forURL:url from:viewController];
    }
}


@end
