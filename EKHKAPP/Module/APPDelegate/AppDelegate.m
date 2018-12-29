/**
 - AppDelegate.m
 - EKHKAPP
 - Created by HY on 2017/9/7.
 - Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "AppDelegate.h"
#import "EKTabBarController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)share{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


#pragma mark - UIApplication生命周期
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    EKTabBarController *tabBarController = [[EKTabBarController  alloc] init];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    [BKSaveData setBool:YES key:kIsHomeLoadFirstItemDataKey];
    //配置网络请求参数
    [self mSettingAppServices];
    
    return YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    //程序进入前台时,请求一下未读消息/提醒
    if (LOGINSTATUS) {
        [[AppDelegate share] requestUnreadMessageNoticeCount];
    }
    
}


//APP进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    //统计app启动次数
    [BKTool mStatisticsAppLaunch:kEK];
}


//APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
   
}


//当从外部打开APP的时候回调的方法
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([url.absoluteString rangeOfString:kURLScheme].location != NSNotFound)  {
        [self mOpenFromUrlShemes:url];
        return YES;
    } else {
        BOOL facebookBool = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
        return facebookBool;
    }
}

#pragma mark - ---------- 其他逻辑 ----------

#pragma mark - 统一设置网络请求服务器地址及配置参数
- (void)mSettingAppServices {
    
    //程序异常处理
    [self exceptionHandler];
    
    //清空本地存储的广告id数据
    [self mRemoveAdUnitId];
    
    //配置网络请求参数
    [self mSettingHttpParameter];
    
    //统计app启动次数
    [BKTool mStatisticsAppLaunch:kEK];
    
    //用户自动退出判断
    [self mUserLogoutSetting];
    
    //统一设置谷歌统计和友盟统计
    //[self mSetStatisticsAnalytics];
    
    //注册通知
    [self registerNotification];
    
    //获取网络表情数据
    [self downloadSmileyData];
    
    //清除用户头像本地缓存
    [self clearUserAvatarCache];
    
    //设置广告application id
    //[self mSetBADApplicationID];
    
    //处理一个特殊的请求
    [self mRequestSetingMeimei];
    
}

//设置页面的推送开关，供设置页面，设置是否打开推送调用
- (void)registerNotification {
    [self mRegisterPushNotification];
}

@end
