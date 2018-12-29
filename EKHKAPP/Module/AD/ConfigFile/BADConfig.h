/**
 -  BADConfig.h
 -  ADSDK
 -  Created by HY on 2017/5/23.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  广告模块的配置文件，包含宏定义，常量定义等
 */

#import <Foundation/Foundation.h>

//广告view出场的动画类型
typedef NS_ENUM(NSInteger, BKADAnimationType) {
    /**
     * 0:沒有
     */
    ADAnimationType_None,
    /**
     * 1:溶入
     */
    ADAnimationType_Into,
    /**
     * 2:由左入
     */
    ADAnimationType_FromLeft,
    /**
     * 3:由右入
     */
    ADAnimationType_FromRight,
    /**
     * 4:向上入
     */
    ADAnimationType_FromTop,
    /**
     * 5:向下入
     */
    ADAnimationType_FromDown,
};


//关闭按钮的位置
typedef NS_ENUM(NSInteger, BKADCloseBtnDisplayType) {
    /**
     * 0:沒有
     */
    ADCloseBtnDisplayType_None,
    /**
     * 1:左上角
     */
    ADCloseBtnDisplayType_leftTop,
    /**
     * 2:右上角
     */
    ADCloseBtnDisplayType_rightTop,
    /**
     * 3:左下角
     */
    ADCloseBtnDisplayType_leftDown,
    /**
     * 4:右下角
     */
    ADCloseBtnDisplayType_rightDown,
};


//广告请求地址
static NSString * const_BAD_REQUEST_URL = @"http://202.67.195.120/reqmads";

/** 定义广告类型 */
static NSString *const const_BAD_DisplayType_Banner = @"banner";
static NSString *const const_BAD_DisplayType_Popup  = @"popup";
static NSString *const const_BAD_DisplayType_Fullscreen  = @"fullscreen";

/** 定义广告内容的类型 */
//static NSString *const const_BKAD_ImageType = @"image";
//static NSString *const const_BKAD_HtmlType  = @"html";
//static NSString *const const_BKAD_TextType  = @"text";
//static NSString *const const_BKAD_VideoType = @"video";

///** 定义点击传参时的常量值 */
//static char const_BKAD_touchImageAdKey; //点击图片类型的广告，传参对应的key值
//static char const_BKAD_touchTextAdKey;  //点击文本类型的广告，传参对应的key值
//static char const_BKAD_touchVideoAdKey; //点击视频类型的广告，传参对应的key值

/** 广告view上，关闭按钮的宽高 */
#define DEF_BKAD_CLOSEBTN_W_H    30

@interface BADConfig : NSObject

@end
