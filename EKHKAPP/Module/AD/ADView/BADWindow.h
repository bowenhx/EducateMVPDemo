/**
 -  BADWindow.h
 -  ADSDK
 -  Created by HY on 17/2/23.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  弹窗广告和全屏广告的入口window，在这里两种广告公用了显示动画和关闭按钮模块代码
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BADModel.h"
#import "PopupView.h"
#import "InterstitialView.h"

//通知名字，用作删除全屏和pop 广告view 的引用对象
static NSString *const kNotificationRemoveADWindowActionKey = @"kNotificationRemoveADWindowActionKey";

@interface BADWindow : UIWindow <BADBaseViewDelegate>

//广告数据模型
@property (nonatomic, strong) BADModel *bkAdModel;

//弹窗大广告view
@property (nonatomic, strong) PopupView *vBigPopView;

//弹窗小尺寸广告
@property (nonatomic, strong) PopupView *vSmallPopView;

//全屏广告view
@property (nonatomic, strong) InterstitialView *vFullView;


//设置广告
- (void)mSettingAdView;



@end
