/**
 -  AppDelegate+EKAppConfig.h
 -  EKHKAPP
 -  Created by ligb on 2017/9/12.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：AppDelegate的分类，专业处理AppDelegate中的配置信息
 */

#import "AppDelegate.h"

@interface AppDelegate (BKAppConfig)

/**
 统一设置网络请求服务器地址及配置参数
 */
- (void)mSettingHttpParameter;


/**
 统一设置谷歌统计和友盟统计
 */
- (void)mSetStatisticsAnalytics;


/**
 设置广告applicationID
 */
- (void)mSetBADApplicationID;


/**
 *  获取网络表情数据
 */
- (void)downloadSmileyData;


/**
 获取未读消息提醒数
 */
- (void)requestUnreadMessageNoticeCount;


/**
 清除用户头像本地缓存
 */
- (void)clearUserAvatarCache;


/**
 程序异常处理
 */
- (void)exceptionHandler;


/**
 从外部打开APP,url判断
 */
- (void)mOpenFromUrlShemes:(NSURL *)url;


/**
 进入app，用户自动退出判断
 */
- (void)mUserLogoutSetting;


/**
 进入app，先清空本地存储的广告id数据，重新从后台获取，防止后台页面和id更新
 */
- (void)mRemoveAdUnitId;

- (void)mRequestSetingMeimei;

@end
