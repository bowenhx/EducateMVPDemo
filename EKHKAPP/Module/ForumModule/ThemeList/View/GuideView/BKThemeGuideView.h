/**
 -  BKThemeGuideView.h
 -  BKHKAPP
 -  Created by HY on 2017/8/25.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：主题列表和主题详情的引导层
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/**
 引导页面的类型枚举
 
 - ThemeGuideImageType_ThemeList: 主题列表页类型
 - ThemeGuideImageType_TjemeDetail: 帖子详情页面类型
 */
typedef NS_ENUM(NSInteger, ThemeGuideImageType) {
    ThemeGuideImageType_ThemeList = 0,
    ThemeGuideImageType_TjemeDetail = 1
};


@interface BKThemeGuideView : UIView

@property (readwrite, nonatomic) ThemeGuideImageType vGuideType;




@end
