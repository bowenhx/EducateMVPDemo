//
//  ReportModel.h
//  BKMobile
//
//  Created by HY on 16/5/26.
//  Copyright © 2016年 com.mobile-kingdom.bkapps. All rights reserved.
//
//  举报model

#import <Foundation/Foundation.h>

@interface ReportModel : NSObject
@property (nonatomic, copy) NSString    *author;
@property (nonatomic, copy) NSString    *dateline;
@property (nonatomic, copy) NSString    *pageurl;
@property (nonatomic, copy) NSString    *subject;
@property (nonatomic, copy) NSString    *type;
@property (nonatomic, copy) NSString    *username;
@property (nonatomic, copy) NSString    *opresult;
@property (nonatomic, assign) NSInteger authorid;
@property (nonatomic, assign) NSInteger mId;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) NSInteger pid;
@property (nonatomic, assign) NSInteger tid;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) id   msglist;

@end

/*
 //举报 ，最新的
 author = "a.m.d.lee";
 authorid = 2132470;
 dateline = "2016-05-26 13:50:04";
 fid = 162;
 id = 344501;
 msglist =     (
 "Whalefall:[\U81ea\U7531\U8b1b\U5834]\U7591\U4f3calinamin\U6253\U624b",
 "wong2323:[\U81ea\U7531\U8b1b\U5834]\U5df2\U5c01"
 );
 num = 2;
 pageurl = "http://www.baby-kingdom.com/forum.php?mod=redirect&goto=findpost&pid=269503530";
 pid = 269503530;
 subject = "\U5f15\U7528\Uff1a\U6211\U524d\U6392\U8ddfBKjm\U98dfB\U96dc\Uff0c\U982d\U76ae\U540c\U9838\U7206\U77f3\U982d\U7621\Uff0c\U5345";
 tid = 17836350;
 type = post;
 uid = 1887545;
 username = Whalefall;
 
 //已经处理的
 author = "\U9ebb\U7169\U8c93";
 authorid = 753752;
 dateline = "2016-05-25 20:30:34";
 fid = 162;
 id = 344328;
 msglist =     (
 "abu_cheung:[\U81ea\U7531\U8b1b\U5834]o\U7518 bk\U5c31\U8981\U53d6\U6d88\U4e8c\U624b\U5e02\U5834\U4e86
 \n\U5462\U53e5\U8aaa\U8a71\U56b4\U91cd\U5f71\U97ff\U5728bk\U7684\U6240\U6709\U7528\U4e8c\U624b\U5e02\U5834\U7684\U6703\U54e1 \U4e5f\U4fae\U8fb1\U4e86\U4e8c\U624b\U5e02\U5834\U7684\U610f\U7fa9
 \n\U6211\U76f8\U4fe1\U7248\U4e3b\U958b\U8fa6\U662f\U65b9\U4fbf\U6703\U54e1
 \n\U800c\U4e0d\U662f\U8ce3\U4e5c\U8cb4\U6435\U4f86\U641e",
 "bktcc:[\U81ea\U7531\U8b1b\U5834]\U6a13\U4e3b\U5df2\U88dc\U5145\U4e0d\U662f\U767c\U751f\U5728bk\Uff0c\U96d9\U65b9\U90fd\U592a\U654f\U611f\U4e86"
 );
 num = 2;
 opname = chloepapa;
 opresult = "\U5ffd\U7565";
 optime = "2016-05-26 06:12:30";
 opuid = 19242;
 pageurl = "http://www.baby-kingdom.com/forum.php?mod=redirect&goto=findpost&pid=269935129";
 pid = 269935129;
 subject = "\U56de\U8986\U6a13\U4e3b:";
 tid = 17873160;
 type = post;
 uid = 39524;
 username = "abu_cheung";
 
 */
