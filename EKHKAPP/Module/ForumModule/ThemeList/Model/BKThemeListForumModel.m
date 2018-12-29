/**
 -  BKThemeListForumModel.m
 -  BKHKAPP
 -  Created by HY on 2017/8/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BKThemeListForumModel.h"
#import "BKThemeMenuModel.h"

@implementation BKThemeListForumModel

//lists数组转换为BKThemeListModel模型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"threadtypes" : [BKThemeMenuModel class] , @"modlist" : [EKThemeModlistModel class]};
}

@end
