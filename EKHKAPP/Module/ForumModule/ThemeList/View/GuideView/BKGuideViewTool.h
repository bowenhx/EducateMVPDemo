/**
 -  BKGuideViewTool.h
 -  BKHKAPP
 -  Created by HY on 2017/8/28.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：
 */

#import <Foundation/Foundation.h>
#import "BKThemeGuideView.h"

@interface BKGuideViewTool : NSObject

/**
 主题列表和主题详情页面显示引导页的方法
 
 @param type 页面类型
 */
+ (void)mShowGuideView:(ThemeGuideImageType)type;

@end
