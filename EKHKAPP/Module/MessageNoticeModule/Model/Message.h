//
//  Message.h
//  BKMobile
//
//  Created by ligb on 17/05/16.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MessageBubbleFactory.h"
@interface Message : NSObject

//pmid
@property (nonatomic, strong) NSString *pmid;

//文字
@property (nonatomic, copy) NSString *message;

//时间
@property (nonatomic, copy) NSString *dateline;

//发送者头像
@property (nonatomic, strong) NSString *msgfromavatar;

//发送者名字
@property (nonatomic, strong) NSString *msgfrom;

//发消息者UID
@property (nonatomic, strong) NSString *msgfromid;

//秒格式的时间
@property (nonatomic, assign) NSInteger time;

//类型发送还是接收
@property (nonatomic, assign) BubbleMessageType bubbleMessageType;

//消息富文本
@property (nonatomic, strong) NSAttributedString *attributeString;

//记录内容高度
@property (nonatomic, assign) CGFloat cellHeight;

@end

/*
{
    dateline = "17-3-22 14:18";
    isnew = 0;
    message = "[smiley]:callme:[/smiley][smiley]:money$$:[/smiley]";
    msgfrom = andev;
    msgfromavatar = "http://ucenter.baby-kingdom.com/avatar.php?uid=745313&size=small";
    msgfromid = 745313;
    msgto = digichoi;
    msgtoavatar = "http://ucenter.baby-kingdom.com/avatar.php?uid=91893&size=small";
    msgtoid = 91893;
    pmid = 1520239918;
    subject = "";
    time = 1490163491;
 },
 {
 dateline = "17-3-6 17:25";
 isnew = 0;
 message = "Ghhh[img]http://www.edu-kingdom.com/static/image/smiley/default/bb24.gif[/img]";
 msgfrom = andev;
 msgfromavatar = "http://ucenter.baby-kingdom.com/avatar.php?uid=745313&size=small";
 msgfromid = 745313;
 msgto = digichoi;
 msgtoavatar = "http://ucenter.baby-kingdom.com/avatar.php?uid=91893&size=small";
 msgtoid = 91893;
 pmid = 1519055601;
 subject = Ghhh;
 time = 1488792331;
 },
 */

