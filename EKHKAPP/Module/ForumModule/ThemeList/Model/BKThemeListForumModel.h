/**
 -  BKThemeListForumModel.h
 -  BKHKAPP
 -  Created by HY on 2017/8/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：主题列表页面，表头view的板块信息数据
 */

#import <Foundation/Foundation.h>
#import "EKThemeModlistModel.h"

@interface BKThemeListForumModel : NSObject

@property (nonatomic , copy) NSString *name;
@property (nonatomic , copy) NSString *icon;
@property (nonatomic , copy) NSArray *threadtypes;
@property (nonatomic , copy) NSArray *modlist;
@property (nonatomic , assign) NSInteger fid;
@property (nonatomic , assign) NSInteger threads;
@property (nonatomic , assign) NSInteger posts;
@property (nonatomic , assign) NSInteger todayposts;
@property (nonatomic , assign) NSInteger membernum;
@property (nonatomic , assign) NSInteger requiredtype;
@property (nonatomic , assign) NSInteger favid;
@property (nonatomic , assign) NSInteger ismoderator;

@end

