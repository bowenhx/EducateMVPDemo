/**
 -  EKPageIndex.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2018/2/2.
 -  Copyright © 2018年 BaByKingdom. All rights reserved.
 -  说明：定义代表各个页面的常量值，用于页面统计功能
 */

#import <Foundation/Foundation.h>

#pragma mark - 谷歌统计使用到的页面索引值

#pragma mark -------------- 页面统计 --------------

//登录
static NSString *const kLoginPageIndex = @"login";

//首页
static NSString *const kHomePageIndex = @"index";

//版块列表
static NSString *const kForumListPageIndex = @"forumList";

//回复 (包含发帖，回复等)
static NSString *const kThemeReplyPageIndex = @"reply";

//我的 - 个人中心
static NSString *const kMyCenterPageIndex = @"myInfo";

//学校
static NSString *const kSchoolPageIndex = @"school";

//课程
static NSString *const kCoursePageIndex = @"course";

//日志
static NSString *const kBlogPageIndex = @"blog";

//启动页
static NSString *const kAppStartPageIndex = @"startapp";

//查看其它用户资料
static NSString *const kUserProfilePageIndex = @"userProfile";


#pragma mark -------------- 事件统计（可附加参数） --------------
//注：含有页码参数的，统计动作添加到刷新的方法中

//退出登录
static NSString *const kLoginOutPageIndex = @"loginOut";

//分享APP
static NSString *const kShareAppPageIndex = @"ShareApp";

//分享帖子
static NSString *const kShareThemePageIndex = @"ShareThread";

//搜索 （附加参数：搜索关键字）
static NSString *const kSearchPageIndex = @"search";

//首页投票 （附加参数：帖子ID）
static NSString *const kHomeVotePageIndex = @"indexVote";

//主题列表 （附加参数：版块ID、页码）
static NSString *const kThemeListPageIndex = @"threadList";

//主题内容 （附加参数：帖子ID 、版块ID、页码）
static NSString *const kThemeDetailPageIndex = @"threadView";

//BKMilk文章列表 （附加参数：分类 ID ）
static NSString *const kBKMilkListPageIndex = @"bkMilkList";

//BKMilk文章内容 （附加参数：文章 ID）
static NSString *const kBKMilkContentPageIndex = @"bkMilkContent";

//爸妈TV内容页 （附加参数：TV ID ）
static NSString *const kParentsTvPageIndex = @"parentsTvConten";

//KMall商品详细页 （附加参数：商品 ID）
static NSString *const kKmallDetailPageIndex = @"shoppingDetail";

//消息 （附加参数：页码）
static NSString *const kMessagePageIndex = @"message";

//提醒 （附加参数：页码）
static NSString *const kNoticePageIndex = @"notice";




#pragma mark ------------------------------------------------
#pragma mark - 为了使用便捷的方式，在父类中进行页面统计，定义以下页面的ViewController类名
#pragma mark - 以下页面的“页面统计”，直接在base父类中统一处理，不用单独在页面中写方法

//登录
static NSString *const kEKLoginViewController = @"EKLoginViewController";

//首页
static NSString *const kEKHomeViewController = @"EKHomeViewController";

//我的 - 个人中心
static NSString *const kEKMyCenterViewController = @"EKMyCenterViewController";

//学校
static NSString *const kEKSchoolAreaViewController = @"EKSchoolAreaViewController";

//课程
static NSString *const kCourseBaseViewController = @"CourseBaseViewController";

//日志
static NSString *const kBlogViewController = @"BlogViewController";

//回复
static NSString *const kBKBaseSendThemeViewController = @"BKBaseSendThemeViewController";

//查看其它用户资料
static NSString *const kEKUserInformationViewController = @"EKUserInformationViewController";

