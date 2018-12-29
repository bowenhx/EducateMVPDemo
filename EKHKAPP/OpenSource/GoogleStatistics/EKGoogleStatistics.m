/*
 -  EKGoogleStatistics.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2018/02/02.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明: 谷歌页面统计和事件统计，和友盟统计
 */

#import "EKGoogleStatistics.h"

@implementation EKGoogleStatistics

#pragma mark ---------------------------谷歌sdk封装---------------------------------

#pragma mark - 谷歌统计初始化 （在AppDelegate中）
+ (void)mInitGoogleAnalytics{
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;
    gai.logger.logLevel = kGAILogLevelVerbose;
}

#pragma mark - 谷歌的页面统计
+ (void)mGoogleScreenAnalytics:(NSString *)screenName {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:screenName];
    [tracker set:kGAIUserId value:USERID];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

#pragma mark - 谷歌的事件统计，可附加参数
+ (void)mGoogleActionAnalytics:(NSString *)action label:(NSString *)label {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Action"
                                                          action:action
                                                           label:label
                                                           value:nil] build]];
}




#pragma mark ---------------------------封装页面统计，在父类中快捷调用---------------------------------

#pragma mark - 开始页面统计方法
//在父类中统计添加谷歌和友盟统计方法
+ (void)mAddStatisticsAnalytics:(UIViewController *)controller {
    NSString *value = [self statisticsName:controller];
    if (value) {
        //google页面统计
//        [self mGoogleScreenAnalytics:value];
//        //umeng统计
//        [MobClick beginLogPageView:value];
    } else {
        DLog(@"本页面不使用这里的统计方法 %s",__func__);
    }
}

#pragma mark - 结束统计方法
+ (void)mEndStatisticsAnalytics:(UIViewController *)controller {
    NSString *value = [self statisticsName:controller];
    if (value) {
        //结束umeng统计
        [MobClick endLogPageView:value];
    }
}


#pragma mark - 其他逻辑方法

//根据控制器,获取控制器对应的后台统计字段
+ (NSString *)statisticsName:(UIViewController *)controller{
    NSString *className = NSStringFromClass([controller class]);
    if (!className) {
        return nil;
    }
    NSString *statisticsName = [self vControllerNameDictionary][className];
    if ([BKTool isStringBlank:statisticsName]) {
        return nil;
    } else {
        return statisticsName;
    }
}



//以下页面可以在父类中，进行快捷的页面统计
+ (NSDictionary *)vControllerNameDictionary {
    NSDictionary * _vControllerNameDictionary = @{
          kEKLoginViewController : kLoginPageIndex, //登录
          kEKHomeViewController : kHomePageIndex, //首页
          kEKMyCenterViewController : kMyCenterPageIndex, //我的 - 个人中心
          kEKSchoolAreaViewController : kSchoolPageIndex, //学校
          kCourseBaseViewController : kCoursePageIndex, //课程
          kBlogViewController : kBlogPageIndex, //日志
          kEKUserInformationViewController : kUserProfilePageIndex, //查看其它用户资料
          };
    return _vControllerNameDictionary;
}


@end
