/**
 - BADAdSize.h
 - BADSdk
 - Created by HY on 2017/12/19.
 - Copyright © 2017年 BaByKingdom. All rights reserved.
 - 说明：banner广告的 预定义size大小
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//广告文档规定的banner广告size
typedef NS_ENUM(NSInteger, BADAdSize) {
    BADADSIZE_STANDARD,
    BADADSIZE_LARGE,
    BADADSIZE_LEADERBOARD,
    BADADSIZE_MEDIUMRECTANGLE,
    BADADSIZE_SMARTBANNER,
    BADADSIZE_CUSTOM
};

//只有当【display_type=banner】的时候才适用
//广告尺寸大小参数分别为：Standard、Large、Leaderboard、MediumRectangle、SmartBanner、Custom

//• Standard【广告尺寸 320*50】
//• Large 【广告尺寸 320*100】
//• Leaderboard 【广告尺寸 728*90】
//• MediumRectangle 【广告尺寸 300*250】
//• SmartBanner 【广告尺寸 屏幕宽度*32|50|90】
//屏幕高度 <= 400, 广告高度设定为 32
//屏幕高度 > 720, 广告高度设定为  90
//400 < 屏幕高度 <= 720, 广告高度设定为 90
//• Custom 【自定义】

//post参数中
//ad_width 只有当【display_type=banner】并且【banner_size=Custom】才适用，自定义广告尺寸【宽】
//ad_height 只有当【display_type=banner】并且【banner_size=Custom】才适用，自定义广告尺寸【高】


