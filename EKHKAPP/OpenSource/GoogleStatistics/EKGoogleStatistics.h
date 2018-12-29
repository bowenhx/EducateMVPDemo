/*
 -  EKGoogleStatistics.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2018/02/02.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明: 谷歌页面统计和事件统计，附加友盟统计
 */

#import <Foundation/Foundation.h>
#import "Analytics.h"
#import "EKPageIndex.h"

@interface EKGoogleStatistics : NSObject

#pragma mark ------------------谷歌sdk封装使用-------------------

/**
 谷歌统计初始化 （在AppDelegate中）
 */
+ (void)mInitGoogleAnalytics;


/**
 谷歌的页面统计
 
 @param screenName 需要追踪统计的页面标示（需求文档有定义）
 */
+ (void)mGoogleScreenAnalytics:(NSString *)screenName;


/**
 谷歌的事件统计，可附加参数
 
 @param action 事件标示（需求文档有定义）
 @param label 附加参数（需求文档有定义）
 */
+ (void)mGoogleActionAnalytics:(NSString *)action label:(NSString *)label;




#pragma mark ------------------在父类中快捷添加统计-------------------

//在父类中统计添加谷歌和友盟统计方法
+ (void)mAddStatisticsAnalytics:(UIViewController *)controller;

//结束统计方法
+ (void)mEndStatisticsAnalytics:(UIViewController *)controller;



@end
