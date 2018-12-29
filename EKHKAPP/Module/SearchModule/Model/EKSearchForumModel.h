/**
 -  EKSearchForumModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/22.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是后台返回的"搜索论坛"数据model
 */

#import <Foundation/Foundation.h>

@interface EKSearchForumModel : NSObject
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *dateline;
@property (nonatomic, copy) NSString *replies;
@property (nonatomic, copy) NSString *views;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *authorid;
@property (nonatomic, copy) NSString *forumname;
@property (nonatomic, assign) BOOL isnew;
@property (nonatomic, copy) NSString *folder;
@property (nonatomic, copy) NSString *fname;
@property (nonatomic, copy) NSString *attachment;
@property (nonatomic, copy) NSString *closed;

@end
