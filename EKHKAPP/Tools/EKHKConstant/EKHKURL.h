/**
 -  EKHKURL.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/15.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:项目中所有有关URL的定义
 */

#import <UIKit/UIKit.h>

//基本URL地址
UIKIT_EXTERN NSString *const kBaseURL;

//关于我们
UIKIT_EXTERN NSString *const kAboutUsURL;

//AppStore评论
UIKIT_EXTERN NSString *const kAppStoreCommentURL;

//下载地址
UIKIT_EXTERN NSString *const kDownloadURL;

//首次启动界面
UIKIT_EXTERN NSString *const kFirstLaunchURL;

//首次启动界面,传递用户选择的年级和板块等信息(个人觉得可看做统计)
UIKIT_EXTERN NSString *const kFirstLaunchRecordURL;

//網站地址（分享使用到这个url）
UIKIT_EXTERN NSString *const kWebURL;

//URL scheme
UIKIT_EXTERN NSString *const kURLScheme;





#pragma mark - 登录
//用户登录
UIKIT_EXTERN NSString *const kLoginURL;

//faceBook登录
UIKIT_EXTERN NSString *const kFaceBookLoginURL;

//该api可用于首次fb登录后的账户关联注册。
UIKIT_EXTERN NSString *const kFacebookRegister;

//完善facebook 資料api ver=3.0
UIKIT_EXTERN NSString *const kFacebookUserInfo;

//注册
UIKIT_EXTERN NSString *const kRegisterURL;

//用户退出登录
UIKIT_EXTERN NSString *const kLoginoutURL;

//找回密码
UIKIT_EXTERN NSString *const kFindPasswordURL;

//表情
UIKIT_EXTERN NSString *const kSmileyURL;



#pragma mark - 首页
//首页置顶横向标签栏数据
UIKIT_EXTERN NSString *const kHomeTopItemURL;

//首页列表精选
UIKIT_EXTERN NSString *const kHomeListURL;

//首页四个icon
UIKIT_EXTERN NSString *const kHomeIconURL;

//首页置顶左侧上下广告
UIKIT_EXTERN NSString *const kHomeTopUpDownAdvertiseURL;

//首页表头显示的推荐数据
UIKIT_EXTERN NSString *const kHomeRecommendURL;

//EK導師庫點擊后打開到web頁面地址
UIKIT_EXTERN NSString *const kHomeTutorURL;

//搜索论坛和用户
UIKIT_EXTERN NSString *const kHomeSearchForumOrUserURL;

//获取搜索框关键词
UIKIT_EXTERN NSString *const kHomeSearchKeyWordURL;

//获取投票数据
UIKIT_EXTERN NSString *const kHomeVoteKeyURL;

//获取首页广告数据
UIKIT_EXTERN NSString *const kHomeBannerADURL;




#pragma mark - BKMilk
//BK Milk的 "更多"
UIKIT_EXTERN NSString *const kMilkMoreURL;


#pragma mark - 日志
//最新/推荐 日志列表
UIKIT_EXTERN NSString *const kBlogListURL;

//日志列表分类
UIKIT_EXTERN NSString *const kBlogTypeURL;

//我的日志列表
UIKIT_EXTERN NSString *const kBlogMyURL;

//发布日志
UIKIT_EXTERN NSString *const kBlogPostURL;

//查看日志详情
UIKIT_EXTERN NSString *const kBlogDetailURL;

//获取亲子活动
UIKIT_EXTERN NSString *const kParentChildActivityURL;






#pragma mark - 课程搜索
//搜索结果
UIKIT_EXTERN NSString *const kCourseSearchResultURL;

//最新课程
UIKIT_EXTERN NSString *const kCourseSearchNewestURL;

//课程目录
UIKIT_EXTERN NSString *const kCourseSearchCatalogURL;

//获取三个下拉列表
UIKIT_EXTERN NSString *const kCourseSearchCourseURL;

//补习台
UIKIT_EXTERN NSString *const kCourseSearchRemediationURL;






#pragma mark - 我的
//用户资料
UIKIT_EXTERN NSString *const kUserInformationURL;

//用户头像上传
UIKIT_EXTERN NSString *const kUserAvatarUploadURL;

//我的主题
UIKIT_EXTERN NSString *const kUserMyTopicURL;

//我的回复
UIKIT_EXTERN NSString *const kUserMyReplyURL;

//我的收藏
UIKIT_EXTERN NSString *const kUserMyCollectURL;

//添加收藏
UIKIT_EXTERN NSString *const kUserAddCollectURL;

//取消收藏
UIKIT_EXTERN NSString *const kUserCancelCollectURL;

//隐私条例
UIKIT_EXTERN NSString *const kUserPrivacyURL;



#pragma mark - 好友
//好友列表
UIKIT_EXTERN NSString *const kFriendListURL;

//添加或同意好友添加
UIKIT_EXTERN NSString *const kFriendAddOrAgreeURL;

//刪除或忽略好友
UIKIT_EXTERN NSString *const kFriendDeleteOrIgnoreURL;

//打招呼相关操作
UIKIT_EXTERN NSString *const kFriendGreetURL;






#pragma mark - 相册
//相册
UIKIT_EXTERN NSString *const kPhotoAlbumURL;






#pragma mark - 举报管理
//举报
UIKIT_EXTERN NSString *const kReportURL;

//举报管理
UIKIT_EXTERN NSString *const kReportAdminURL;

//删除举报
UIKIT_EXTERN NSString *const kReportDeleteURL;

//处理举报
UIKIT_EXTERN NSString *const kReportDealURL;

//举报理由
UIKIT_EXTERN NSString *const kReportReasonURL;





#pragma mark - 管理
//主题常规管理
UIKIT_EXTERN NSString *const kManageThemeURL;

//屏蔽/解除屏蔽
UIKIT_EXTERN NSString *const kManageURL;

//警告/解除警告
UIKIT_EXTERN NSString *const kManageWarnURL;

//禁言/解除禁言 禁訪問/解除禁止訪問
UIKIT_EXTERN NSString *const kManageBanURL;





#pragma mark - 学校
//学校情报区域列表
UIKIT_EXTERN NSString *const kSchoolListURL;

//某区域学校板块列表
UIKIT_EXTERN NSString *const kSchoolAreaURL;

//搜索學校
UIKIT_EXTERN NSString *const kSchoolSearchURL;




#pragma mark - 论坛
//板块列表
UIKIT_EXTERN NSString *const kForumListURL;

//精简板块列表
UIKIT_EXTERN NSString *const kForumSimpleURL;

//主题列表
UIKIT_EXTERN NSString *const kThemeListURL;

//主题详情
UIKIT_EXTERN NSString *const kThemeDetailURL;

//发布主题
UIKIT_EXTERN NSString *const kThemeReleaseURL;

//发布帖子(跟帖/回复/引用)
UIKIT_EXTERN NSString *const kPostReleaseURL;

//点评帖子
UIKIT_EXTERN NSString *const kPostCommentURL;

UIKIT_EXTERN NSString *const kThemeRedirectURL;

UIKIT_EXTERN NSString *const kThemeCommentListURL;

//编辑帖子
UIKIT_EXTERN NSString *const kPostEditURL;

//活动贴 报名/取消报名
UIKIT_EXTERN NSString *const kActivityURL;

//投票贴
UIKIT_EXTERN NSString *const kVoteURL;






#pragma mark - 收藏
//收藏列表
UIKIT_EXTERN NSString *const kCollectListURL;

//添加收藏
UIKIT_EXTERN NSString *const kCollectAddURL;

//取消收藏
UIKIT_EXTERN NSString *const kCollectCancelURL;

//板块推荐
UIKIT_EXTERN NSString *const kForumRecommendURL;





#pragma mark - 讯息
//消息列表
UIKIT_EXTERN NSString *const kMessageListURL;

//消息详情列表
UIKIT_EXTERN NSString *const kMessageDetailURL;

//发送消息
UIKIT_EXTERN NSString *const kMessageSendURL;

//删除消息
UIKIT_EXTERN NSString *const kMessageDeleteURL;

//提醒列表
UIKIT_EXTERN NSString *const kNoticeListURL;

//未读消息数
UIKIT_EXTERN NSString *const kUnreadMessageCountURL;





#pragma mark - 错误日志
//错误日志
UIKIT_EXTERN NSString *const kErrorLogURL;




