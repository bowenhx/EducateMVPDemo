/**
 -  BKHKConstant.h
 -  BKHKAPP
 -  Created by HY on 2017/8/7.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  项目中常用常量定义，包含唯一key值定义，通知名
 */

#import <UIKit/UIKit.h>

#pragma mark - 唯一key值定义

//定义项目名称@“EK” （用于统计app启动次数）
UIKIT_EXTERN NSString *const kEK;

//分享图片名称
UIKIT_EXTERN NSString *const kShareImageName;

//itunes APP ID
UIKIT_EXTERN NSString *const kITunesAppID;

//微信 KEY
UIKIT_EXTERN NSString *const kWeChatKey;

//友盟 KEY
UIKIT_EXTERN NSString *const kUMengKey;

//保存当前用户的登录时间key
UIKIT_EXTERN NSString *const kTodayLoginKey;

//用户密码加密key
UIKIT_EXTERN NSString *const kUserPasswordKey;

//保存生成加密索引key
UIKIT_EXTERN NSString *const kUserPasswordIndexKey;

//启动页广告data key
UIKIT_EXTERN NSString *const kStartAdLaunchKey;

//发帖时保存填写的数据key
UIKIT_EXTERN NSString *const kCommentKey;

//收藏板块数据key
UIKIT_EXTERN NSString *const kCollectListKey;

//保存表情文件key
UIKIT_EXTERN NSString *const kSmileyKey;

//保存讨论区页面的所有数据
UIKIT_EXTERN NSString *const kAllForumKey;

//保存手机注册推送获得的token值
UIKIT_EXTERN NSString *const kDeviceTokenKey;

//用來保存用戶查看主題密碼 注意这里：保存不同板块的密码，拼接格式为
//[NSString stringWithFormat:@"%@_%@",kForumPasswordKey,fid];
UIKIT_EXTERN NSString *const kForumPasswordKey;

//用来保存相册的密码
UIKIT_EXTERN NSString *const kPhotoAlbumPasswordKey;

//保存帖子详情排序状态 0 表示顺序，1 表示倒序
UIKIT_EXTERN NSString *const kTopicDetailOrderKey;

//保存设置中帖子详情字体大小号状态,  默认为0   1 表示小号， 0 表示中号  2表示大号
UIKIT_EXTERN NSString *const kTopicDetailFontSizeKey;

//设置中的远程推送开关,打开保存值为1，关闭保存值为0
UIKIT_EXTERN NSString *const kNotificationsSwitchKey;

//主题列表和主题详情页的使用指引
UIKIT_EXTERN NSString *const kThemeOrDetailGuideImageKey;

//保存未读消息记录的索引key
UIKIT_EXTERN NSString *const kUnreadMessageCountKey;

//保存后台返回的iAx广告id信息
UIKIT_EXTERN NSString *const kIaxAdInfoKey;

//保存用户喜爱的年级信息和板块信息
UIKIT_EXTERN NSString *const kPreferForumInfoKey;

//保存用户是否已经选择完首次启动时的喜爱年级和板块
UIKIT_EXTERN NSString *const kIsFinishFirstLaunchChooseKey;

//保存首页是否应该加载第0个标签的数据
UIKIT_EXTERN NSString *const kIsHomeLoadFirstItemDataKey;

//保存用户头像URL字符串
UIKIT_EXTERN NSString *const kUserAvatarURLStringKey;




#pragma mark - 通知

//用户登录成功，通知
UIKIT_EXTERN NSString *const kLoginSuccessNotification;

//用户选择完首次启动页的数据时,发出的通知
UIKIT_EXTERN NSString *const kFirstLaunchSelectFinishNotification;

UIKIT_EXTERN NSString *const kHomeVoteRefreshNotification;

UIKIT_EXTERN NSString *const kHomePushNextNotification;

//用户发布日志成功后，发出的通知
UIKIT_EXTERN NSString *const kPublishBlogSuccessNotification;

UIKIT_EXTERN NSString *const kUpdataRevertNotification;

//选择tabbar上的按钮，改变了 通知
UIKIT_EXTERN NSString *const kTabbarIndexChangeNotification;

//表示有推送消息，要显示小红点
UIKIT_EXTERN NSString *const kRemotePushNotification;

//表示没有新的推送消息,不要显示小红点
UIKIT_EXTERN NSString *const kNoRemotePushNotification;

//deviceToken通知
UIKIT_EXTERN NSString *const kDeviceTokenNotification;

//更新收藏列表通知
UIKIT_EXTERN NSString *const kUpdateCollectListNotification;


UIKIT_EXTERN NSString *const kForumCollectNotification;

//群组退出加入通知
UIKIT_EXTERN NSString *const kGroupChangeNotification;

//帖子详情中的CoreText 高度更新
UIKIT_EXTERN NSString *const kUpdateCoreTextHeightNotification;

//回复帖子更新通知
UIKIT_EXTERN NSString *const kUpdatePostReplyNotification;

//编辑帖子更新通知
UIKIT_EXTERN NSString *const kUpdatePostEditNotification;

//外部打开APP到帖子详情的通知
UIKIT_EXTERN NSString *const kOpenTopicDetailNotification;

//用户警告重新登录通知
UIKIT_EXTERN NSString *const kQuitLoginNotifation;

//从其他页面，返回到主题列表，需要刷新主题列表通知，比如：移动主题，开启关闭主题后返回到列表
UIKIT_EXTERN NSString *const kRefreshThemeListNotifation;





#pragma mark - 占位图placeHolder名字
//首页的BKMilk cell使用的占位图
UIKIT_EXTERN NSString *const kPlaceHolderBKMilk;

//背景为灰色的占位图
UIKIT_EXTERN NSString *const kPlaceHolderGray;

//背景为白色的占位图
UIKIT_EXTERN NSString *const kPlaceHolderWhite;

//帖子详情的富文本内容内使用的占位图
UIKIT_EXTERN NSString *const kPlaceHolderThemeDetail;

//头像部分使用的占位图
UIKIT_EXTERN NSString *const kPlaceHolderAvatar;

//活动贴使用的占位图
UIKIT_EXTERN NSString *const kPlaceHolderActivity;

//版块头像使用的占位图
UIKIT_EXTERN NSString *const kPlaceHolderForumAvatar;



