/**
 -  BKThemeListDataModel.m
 -  BKHKAPP
 -  Created by HY on 2017/8/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BKThemeListDataModel.h"
#import "BKThemeListModel.h"

@implementation BKThemeListDataModel

//lists数组转换为BKThemeListModel模型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"lists" : [BKThemeListModel class] };
}

@end
