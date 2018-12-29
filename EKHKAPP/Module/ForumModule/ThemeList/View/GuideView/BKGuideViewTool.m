
/**
 -  BKGuideViewTool.m
 -  BKHKAPP
 -  Created by HY on 2017/8/28.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BKGuideViewTool.h"
#import "AppDelegate.h"
static const NSString * kThemeList = @"kThemeList";
static const NSString * kThemeDetail = @"kThemeDetail";

@implementation BKGuideViewTool

#pragma mark - 引导页面显示
+ (void)mShowGuideView:(ThemeGuideImageType)type {
    NSDictionary *saveDict = [BKSaveData readDicByFile:kThemeOrDetailGuideImageKey];
    NSString *guideIsShow = nil;
    if (type == ThemeGuideImageType_ThemeList) {
        guideIsShow = saveDict[kThemeList];
    } else {
        guideIsShow = saveDict[kThemeDetail];
    }
    //没有打开过帖子内容页
    if (!guideIsShow || guideIsShow.integerValue == 0) {
        //帖子内容页的指引view
        BKThemeGuideView *threadGuideView = [[BKThemeGuideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        threadGuideView.vGuideType = type;
        AppDelegate *app =(AppDelegate *)[[UIApplication sharedApplication] delegate];
        [[app window] addSubview:threadGuideView];
        [[app window] bringSubviewToFront:threadGuideView];
        
        //保存已经打开的记录
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:saveDict];
        if (type == ThemeGuideImageType_ThemeList) {
            dict[kThemeList] = @"1";
        } else {
            dict[kThemeDetail] = @"1";
        }
        [BKSaveData writeDicToFile:dict fileName:kThemeOrDetailGuideImageKey];
    }
}


@end
