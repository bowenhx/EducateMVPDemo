/**
 -  BKTextConfig.h
 -  BKHKAPP
 -  Created by HY on 2017/8/9.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：项目中，文字配置类，命名规范按照“模块_文字含义+Text结尾”
 */

#import <Foundation/Foundation.h>

@interface BKTextConfig : NSObject
UIKIT_EXTERN NSString *const kAlertSelectConfirmText;

UIKIT_EXTERN NSString *const kAlertSelectCancelText;

UIKIT_EXTERN NSString *const kAlertSelectSaveText;

UIKIT_EXTERN NSString *const kAlertSelectNoSaveText;

//登录成功
UIKIT_EXTERN NSString *const kLoginModule_LoginSuccessText;

//登录成功
UIKIT_EXTERN NSString *const kLoginModule_UserNameIsNullText;

//登录成功
UIKIT_EXTERN NSString *const kLoginModule_PasswordIsNullText;

//正在加载
UIKIT_EXTERN NSString *const kStartLoadingText;

//kall，网购页面title
UIKIT_EXTERN NSString *const kHomeModule_KMallPageTitleText;

//首页web帖子，点进去web的title
UIKIT_EXTERN NSString *const kHomeModule_KChoiceTitleText;


//论坛密码错误提示
UIKIT_EXTERN NSString *const kForumModule_MotifPasswordText;

UIKIT_EXTERN NSString *const kForumModule_PasswordErrorText;

UIKIT_EXTERN NSString *const kForumModule_MotifHealthSex;

UIKIT_EXTERN NSString *const kForumModule_MotifContentText;

UIKIT_EXTERN NSString *const kForumModule_MotifContentFullText;

UIKIT_EXTERN NSString *const kForumModule_MotifContentNoFullText;

UIKIT_EXTERN NSString *const kForumModule_MotifPolity;

UIKIT_EXTERN NSString *const kForumModule_MotifContentWarnText;

UIKIT_EXTERN NSString *const kForumModule_MotifWarnPushText;

UIKIT_EXTERN NSString *const kForumModule_MotifWarnLeaveText;

UIKIT_EXTERN NSString *const kForumModule_SendThemeText;

//主题列表，加载帖子的类型：@"全部"
UIKIT_EXTERN NSString *const kThemeModule_KThemeListAllTypeText;

//主题列表，加载帖子的类型：@"精華"
UIKIT_EXTERN NSString *const kThemeModule_KThemeListChoiseTypeText;

//主题列表，加载帖子的类型：@"最新"
UIKIT_EXTERN NSString *const kThemeModule_KThemeListNewTypeText;

//主题列表和主题详情页面，选择页码view，頁碼輸入錯誤，請重新輸入
UIKIT_EXTERN NSString *const kThemeModule_pageNumberErrorText;


#pragma mark - 个人中心界面
//个人中心界面上传头像的弹窗文字
UIKIT_EXTERN NSString *const kMyModule_UploadAvatarMessage;

UIKIT_EXTERN NSString *const kMyModule_UploadFromAlbum;

UIKIT_EXTERN NSString *const kMyModule_UploadFromCamera;

//解除好友的弹窗文字
UIKIT_EXTERN NSString *const kMyModule_DeleteFriendEnquireText;

//"我的相册"进入相册输入密码时的弹窗文字
UIKIT_EXTERN NSString *const kMyModule_EnterAlbumPassword;

//"我的相册"用户未输入密码是弹出的警告
UIKIT_EXTERN NSString *const kMyModule_PleaseEnterAlbumPassword;

//"我的相册"用户输入的密码错误时弹出的警告
UIKIT_EXTERN NSString *const kMyModule_WrongAlbumPassword;

//分享统一文字
UIKIT_EXTERN NSString *const kMyModule_ShareText;

@end
