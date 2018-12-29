/**
 -  EKForumCollectModel.h
 -  EKHKAPP
 -  Created by ligb on 2017/9/12.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明： 板块收藏model
 */

#import <Foundation/Foundation.h>

@interface EKForumCollectModel : NSObject

@property (nonatomic, copy) NSString    *name;
@property (nonatomic, copy) NSString    *icon;
@property (nonatomic, copy) NSString    *url;
@property (nonatomic, copy) NSString    *lastsubject;
@property (nonatomic, copy) NSString    *lastdateline;

@property (nonatomic, assign) NSInteger fid;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger todayposts;
@property (nonatomic, assign) NSInteger threads;
@property (nonatomic, assign) NSInteger replies;
@property (nonatomic, assign) NSInteger views;
@property (nonatomic, assign) NSInteger ispassword;

@end

//收藏列表
/**

 {
 "favid": "1019098",
 "uid": "91893",
 "id": "3",
 "idtype": "fid",
 "spaceuid": "0",
 "description": "",
 "dateline": "昨天16:15",
 "icon": "http://www.edu-kingdom.com/data/attachment/common/ec/common_3_icon.png",
 "url": "https://www.edu-kingdom.com/BAPI/index.php?mod=forum&op=forumdisplay&ver=3.0.0&app=android&fid=3",
 "name": "教育講場",
 "fid": "3",
 "lasttid": "3526754",
 "lastsubject": "家長群組何時變成投訴討論區？（Esther Chu）",
 "lastdateline": "15分鐘前",
 "lastauthor": "elbar",
 "views": "0",
 "replies": "151991",
 "threads": "21692",
 "todayposts": "8",
 "ispassword": "0"
 },  
 */
