/**
 -  EKHKURL.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/15.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:项目中所有有关URL的定义
 */

#import <UIKit/UIKit.h>


//基本URL地址
NSString *const kBaseURL = @"https://bapi.edu-kingdom.com/index.php";

//关于我们
NSString *const kAboutUsURL = @"https://iphone2.baby-kingdom.com/about.php";

//AppStore评论
NSString *const kAppStoreCommentURL = @"itms-apps://itunes.apple.com/cn/app/id494177799?mt=8&action=write-review";

//下载地址
NSString *const kDownloadURL = @"https://www.baby-kingdom.com/BAPI/download_app.php";

//首次启动界面
NSString *const kFirstLaunchURL = @"?mod=forum&op=startforum";

//首次启动界面,传递用户选择的年级和板块等信息(个人觉得可看做统计)
NSString *const kFirstLaunchRecordURL = @"?mod=stand&op=startlog";

//網站地址（分享使用到这个url）
NSString *const kWebURL = @"https://www.edu-kingdom.com/";

//URL scheme
NSString *const kURLScheme = @"ekapp://";


#pragma mark - 登录
//用户登录
NSString *const kLoginURL = @"?mod=member&op=login";

//faceBook登录
NSString *const kFaceBookLoginURL = @"?mod=member&op=fblogin";

//该api可用于首次fb登录后的账户关联注册。
NSString *const kFacebookRegister = @"?mod=member&op=fbregister";

//完善facebook 資料api ver=3.0
NSString *const kFacebookUserInfo = @"?mod=member&op=saveinfo";

//普通 注册
NSString *const kRegisterURL = @"?mod=member&op=register";

//用户退出登录
NSString *const kLoginoutURL = @"?mod=member&op=logout";

//找回密码
NSString *const kFindPasswordURL = @"?mod=member&op=lostpwd";

//表情
NSString *const kSmileyURL = @"?mod=misc&op=smiley";



#pragma mark - 首页
//首页置顶横向标签栏数据
NSString *const kHomeTopItemURL = @"?mod=stand&op=tablabel";

//首页置顶横向标签关联的下面的4个列表的数据
NSString *const kHomeListURL = @"?mod=stand&op=tabdata";

//首页四个icon
NSString *const kHomeIconURL = @"?mod=stand&op=eduicon";

//首页置顶左侧上下广告
NSString *const kHomeTopUpDownAdvertiseURL = @"?mod=stand&op=toprad";

//首页表头显示的推荐数据
NSString *const kHomeRecommendURL = @"?mod=stand&op=index";

//EK導師庫點擊后打開到web頁面地址
NSString *const kHomeTutorURL = @"https://www.edu-kingdom.com/tutor?app=true";

//搜索论坛和用户
NSString *const kHomeSearchForumOrUserURL = @"?mod=search&op=index";

//获取搜索框关键词
NSString *const kHomeSearchKeyWordURL = @"?mod=stand&op=searchkeyword";

//获取投票数据
NSString *const kHomeVoteKeyURL = @"?mod=stand&op=vote";

//首页两条banner广告
NSString *const kHomeBannerADURL = @"?mod=stand&op=ibanner";





#pragma mark - BKMilk
//BK Milk的 "更多"
NSString *const kMilkMoreURL = @"?mod=stand&op=milks";


#pragma mark - 日志
//最新/推荐 日志列表
NSString *const kBlogListURL = @"?mod=home&op=bloglist";

//日志列表分类
NSString *const kBlogTypeURL = @"?mod=home&op=blogtype";

//我的日志列表
NSString *const kBlogMyURL = @"?mod=home&op=blogmy";

//发布日志
NSString *const kBlogPostURL = @"?mod=home&op=blogpost";

//查看日志详情
NSString *const kBlogDetailURL = @"?mod=home&op=blogshow";

//获取亲子活动
NSString *const kParentChildActivityURL = @"?mod=stand&op=event";






#pragma mark - 课程搜索
//搜索结果
NSString *const kCourseSearchResultURL = @"?mod=stand&op=search";

//最新课程
NSString *const kCourseSearchNewestURL = @"?mod=stand&op=newest";

//课程目录
NSString *const kCourseSearchCatalogURL = @"?mod=stand&op=catalog";

//获取三个下拉列表
NSString *const kCourseSearchCourseURL = @"?mod=stand&op=seaops";

//补习台
NSString *const kCourseSearchRemediationURL = @"?mod=stand&op=tutor";






#pragma mark - 我的
//用户资料
NSString *const kUserInformationURL = @"?mod=home&op=profile";

//用户头像上传
NSString *const kUserAvatarUploadURL = @"?mod=home&op=avatar";

//我的主题
NSString *const kUserMyTopicURL = @"?mod=home&op=thread";

//我的回复
NSString *const kUserMyReplyURL = @"?mod=home&op=reply";

//我的收藏
NSString *const kUserMyCollectURL = @"?mod=home&op=favorite";

//添加收藏
NSString *const kUserAddCollectURL = @"?mod=home&op=favadd";

//取消收藏
NSString *const kUserCancelCollectURL = @"?mod=home&op=favdelete";

//隐私条例
NSString *const kUserPrivacyURL = @"https://www.edu-kingdom.com/privacy_m.php";



#pragma mark - 好友
//好友列表
NSString *const kFriendListURL = @"?mod=home&op=friend";

//添加或同意好友添加
NSString *const kFriendAddOrAgreeURL = @"?mod=home&op=friendadd";

//刪除或忽略好友
NSString *const kFriendDeleteOrIgnoreURL = @"?mod=home&op=frienddelete";

//打招呼相关操作
NSString *const kFriendGreetURL = @"?mod=home&op=poke";






#pragma mark - 相册
//相册
NSString *const kPhotoAlbumURL = @"?mod=home&op=album";






#pragma mark - 举报管理
//举报
NSString *const kReportURL = @"?mod=misc&op=report";

//举报管理
NSString *const kReportAdminURL = @"?mod=admin&op=report";

//删除举报
NSString *const kReportDeleteURL = @"?mod=admin&op=reportdel";

//处理举报
NSString *const kReportDealURL = @"?mod=admin&op=resolve";

//举报理由
NSString *const kReportReasonURL = @"?mod=misc&op=reportcustom";





#pragma mark - 管理
//主题常规管理
NSString *const kManageThemeURL = @"?mod=forum&op=moderate";

//屏蔽/解除屏蔽
NSString *const kManageURL = @"?mod=forum&op=modban";

//警告/解除警告
NSString *const kManageWarnURL = @"?mod=forum&op=modwarn";

//禁言/解除禁言 禁訪問/解除禁止訪問
NSString *const kManageBanURL = @"?mod=forum&op=memban";




#pragma mark - 学校
//学校情报区域列表
//该API与之前项目使用的API地址不一样,后台返回的字段略有不同
NSString *const kSchoolListURL = @"?mod=stand&op=newschareas";

//某区域学校板块列表
NSString *const kSchoolAreaURL = @"?mod=stand&op=school";

//搜索學校
NSString *const kSchoolSearchURL = @"?mod=stand&op=kwschool";




#pragma mark - 论坛
//板块列表
NSString *const kForumListURL = @"?mod=forum&op=index";

//精简板块列表
NSString *const kForumSimpleURL = @"?mod=forum&op=simplelist";

//主题列表
NSString *const kThemeListURL = @"?mod=forum&op=forumdisplay";

//主题详情
NSString *const kThemeDetailURL = @"?mod=forum&op=viewthread";

//发布主题
NSString *const kThemeReleaseURL = @"?mod=forum&op=newthread";

//发布帖子(跟帖/回复/引用)
NSString *const kPostReleaseURL = @"?mod=forum&op=newreply";

//点评帖子
NSString *const kPostCommentURL = @"?mod=forum&op=comment";

//楼层定位
NSString *const kThemeRedirectURL = @"?mod=forum&op=redirect";

//点评列表
NSString *const kThemeCommentListURL = @"?mod=forum&op=comments";

//编辑帖子
NSString *const kPostEditURL = @"?mod=forum&op=editpost";

//活动贴 报名/取消报名
NSString *const kActivityURL = @"?mod=forum&op=activityapplies";

//投票贴
NSString *const kVoteURL = @"?mod=forum&op=votepoll";





#pragma mark - 收藏
//收藏列表
NSString *const kCollectListURL = @"?mod=home&op=favorite";

//添加收藏
NSString *const kCollectAddURL = @"?mod=home&op=favadd";

//取消收藏
NSString *const kCollectCancelURL = @"?mod=home&op=favdelete";

//板块推荐
NSString *const kForumRecommendURL = @"?mod=stand&op=forumtj";




#pragma mark - 讯息
//消息列表
NSString *const kMessageListURL = @"?mod=home&op=pms";

//消息详情列表
NSString *const kMessageDetailURL = @"?mod=home&op=pmview";

//发送消息
NSString *const kMessageSendURL = @"?mod=home&op=sendpm";

//删除消息
NSString *const kMessageDeleteURL = @"?mod=home&op=delpm";

//提醒列表
NSString *const kNoticeListURL = @"?mod=home&op=notice";

//未读消息数
NSString *const kUnreadMessageCountURL = @"?mod=home&op=msgcount";




#pragma mark - 错误日志
//错误日志
NSString *const kErrorLogURL = @"?mod=misc&op=log";


