/**
 -  BKThemeListDataModel.h
 -  BKHKAPP
 -  Created by HY on 2017/8/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：请求主题列表后，后台返回的外层模型，data中包含以下四个字段，四个字段分别对应不同的model
 */

#import <Foundation/Foundation.h>
#import "BKThemeListForumModel.h"

@interface BKThemeListDataModel : NSObject

//BKThemeListModel,主题列表cell的数据model
@property (nonatomic, strong) NSArray *lists;

//BKThemeListForumModel,主题列表页面表头view的板块信息数据,字典
@property (nonatomic, strong) BKThemeListForumModel *forum;

//page为分页相关参数，使用到了内部的max_page属性
@property (nonatomic, strong) NSDictionary *page;

//next为获取下一级的主题详情api的相关信息
@property (nonatomic, strong) NSDictionary *next;

@end


