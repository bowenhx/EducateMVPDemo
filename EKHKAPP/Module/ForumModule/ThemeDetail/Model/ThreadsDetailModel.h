/**
 - BKMobile
 - BoardSubModel.h
 - Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
 - Created by Guibin on 16/5/25.
 - 说明：帖子详情中报名活动处理
 */

#import <Foundation/Foundation.h>

@interface ThreadsDetailModel : NSObject

@property(nonatomic , copy) NSString *author;

@property (nonatomic , copy) NSString *fname;

@property (nonatomic , copy) NSString *subject;

@property (nonatomic , copy) NSArray *threadtypes;

@property (nonatomic , copy) NSString *test;

@property (nonatomic , assign) NSInteger activityisover;//活动贴报名是否结束 0 未结束； 1 活动已结束

@property (nonatomic , assign) NSInteger activitystatus;//报名状态 0 可以报名； 1 名额已满； 2 已报名; 3 完善资料; 4 已报名审核不通过

@property (nonatomic , assign) NSInteger authorid;

@property (nonatomic , assign) NSInteger closed;

@property (nonatomic , assign) NSInteger favid;

@property (nonatomic , assign) NSInteger fid;

@property (nonatomic , assign) NSInteger ismoderator;

@property (nonatomic , assign) NSInteger replies;

@property (nonatomic , assign) NSInteger requiredtype;

@property (nonatomic , assign) NSInteger special;

@property (nonatomic , assign) NSInteger threadtype;//帖子类型：0 普通帖子，1 投票帖子， 4 活动帖子

@property (nonatomic , assign) NSInteger tid;

@property (nonatomic , assign) NSInteger Typeid;

@property (nonatomic , assign) NSInteger views;


@end
/**
{
    activityisover = 0;
    activitystatus = 0;
    author = "\U5927\U773c\U59b9123";
    authorid = 2154180;
    closed = 0;
    favid = 0;
    fid = 6987;
    fname = "\U7247\U7247\U5c08\U5340 - \U63db\U7247\U65b0\U624b";
    ismoderator = 1;
    replies = 0;
    requiredtype = 1;
    special = 0;
    subject = "\U82b1\U738b\U7247\U7247\U908a\U5ea6\U62b5\U8cb7";
    test = dateline365;
    threadtype = 0;
    threadtypes =     (
                       {
                           icon = "";
                           id = 519;
                           name = "\U63db\U7247\U65b0\U624b";
                           typeid = 519;
                       },
                       {
                           icon = "";
                           id = 525;
                           name = "\U7d93\U9a57\U5206\U4eab";
                           typeid = 525;
                       },
                       {
                           icon = "";
                           id = 531;
                           name = "\U5176\U4ed6\U7528\U54c1";
                           typeid = 531;
                       }
                       );
    tid = 17883633;
    typeid = 519;
    views = 21;
}

 
 */
