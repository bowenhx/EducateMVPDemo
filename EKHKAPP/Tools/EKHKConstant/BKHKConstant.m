/**
 -  BKHKConstant.h
 -  BKHKAPP
 -  Created by HY on 2017/8/7.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import <UIKit/UIKit.h>

#pragma mark - 唯一key值定义

NSString *const kEK = @"EK";

NSString *const kShareImageName = @"Icon_share";

NSString *const kITunesAppID = @"438404619";

NSString *const kUMengKey = @"57982e1de0f55a229c002b4f";

NSString *const kWeChatKey = @"wx165760e2ac083a6b";

NSString *const kTodayLoginKey = @"todayLoginKey";

NSString *const kUserPasswordKey = @"baby-kingdom";

NSString *const kUserPasswordIndexKey = @"userPasswordIndexKey";

NSString *const kStartAdLaunchKey = @"startAdLaunchKey";

NSString *const kCommentKey = @"commentKey";

NSString *const kCollectListKey = @"collectListKey";

NSString *const kSmileyKey = @"smileyKey.plist";

NSString *const kAllForumKey = @"allForumKey";

NSString *const kDeviceTokenKey = @"deviceTokenKey";

NSString *const kForumPasswordKey = @"forumPasswordKey";

NSString *const kPhotoAlbumPasswordKey = @"photoAlbumPasswordKey";

NSString *const kTopicDetailOrderKey = @"topicDetailOrderKey";

NSString *const kTopicDetailFontSizeKey = @"topicDetailFontSizeKey";

NSString *const kNotificationsSwitchKey = @"notificationsSwitchKey";

NSString *const kThemeOrDetailGuideImageKey = @"themeOrDetailGuideImageKey";

NSString *const kUnreadMessageCountKey = @"unreadMessageCountKey";

NSString *const kIaxAdInfoKey = @"iAxAdInfoKey";

NSString *const kPreferForumInfoKey = @"preferForumInfoKey";

NSString *const kIsFinishFirstLaunchChooseKey = @"isFinishFirstLaunchChooseKey";

NSString *const kIsHomeLoadFirstItemDataKey = @"isHomeLoadFirstItemDataKey";

NSString *const kUserAvatarURLStringKey = @"userAvatarURLStringKey";

#pragma mark - 通知
//用户登录成功之后发出的通知
NSString *const kLoginSuccessNotification = @"loginSuccessNotification";

//用户退出登录之后发出的通知
NSString *const kQuitLoginNotifation = @"quitLoginNotifation";

//用户选择完首次启动页的数据时,发出的通知
NSString *const kFirstLaunchSelectFinishNotification = @"firstLaunchSelectFinishNotification";

//更新投票贴数据
NSString *const kHomeVoteRefreshNotification = @"homeVoteRefreshNotification";

//需要从首页push 页面通知
NSString *const kHomePushNextNotification = @"homePushNextNotification";

//用户发布日志成功后，发出的通知
NSString *const kPublishBlogSuccessNotification = @"publishBlogSuccessNotification";

//回复帖子更新通知
NSString *const kUpdataRevertNotification = @"updataRevertNotification";

NSString *const kTabbarIndexChangeNotification = @"tabbarIndexChangeNotification";

//表示有推送消息，要显示小红点
NSString *const kRemotePushNotification = @"remotePushNotification";

//表示没有新的推送消息,不要显示小红点
NSString *const kNoRemotePushNotification = @"noRemotePushNotification";

//deviceToken通知
NSString *const kDeviceTokenNotification = @"deviceTokenNotification";

NSString *const kUpdateCollectListNotification = @"updateCollectListNotification";

NSString *const kForumCollectNotification = @"forumCollectNotification";

NSString *const kGroupChangeNotification = @"groupChangeNotification";

NSString *const kUpdateCoreTextHeightNotification = @"updateCoreTextHeightNotification";

NSString *const kUpdatePostReplyNotification = @"updatePostReplyNotification";

NSString *const kUpdatePostEditNotification = @"updatePostEditNotification";

NSString *const kOpenTopicDetailNotification = @"openTopicDetailNotification";

NSString *const kRefreshThemeListNotifation = @"refreshThemeListNotifation";

#pragma mark - 占位图placeHolder名字
//首页的BKMilk cell使用的占位图
NSString *const kPlaceHolderBKMilk = @"iv_preview_bm";

//背景为灰色的占位图
NSString *const kPlaceHolderGray = @"iv_preview_hui";

//背景为白色的占位图
NSString *const kPlaceHolderWhite = @"iv_preview";

//帖子详情的富文本内容内使用的占位图
NSString *const kPlaceHolderThemeDetail = @"iv_preview_mian";

//头像部分使用的占位图
NSString *const kPlaceHolderAvatar = @"iv_preview_round";

//活动贴使用的占位图
NSString *const kPlaceHolderActivity = @"iv_preview_hd";

//版块头像使用的占位图
NSString *const kPlaceHolderForumAvatar = @"iv_preview_round_section";
