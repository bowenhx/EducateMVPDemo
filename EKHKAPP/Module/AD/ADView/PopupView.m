/**
 -  BAPopupView.m
 -  ADSDK
 -  Created by HY on 17/2/21.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "PopupView.h"

@interface PopupView()

@end

@implementation PopupView

#pragma mark - dealloc
- (void)dealloc {
    NSLog(@"%s",__func__);
}


//判断点击广告后跳转的逻辑
- (void)mTouchAdViewEvent {
    [super mTouchAdViewEvent];
    
//    //点击后动画隐藏广告，TODO：这里需求没有要求点击后隐藏广告，暂时不添加
//    if (self.showADViewAnimate) {
//        self.showADViewAnimate (NO);
//    }
}

#pragma mark - pop广告加载完成后的逻辑
- (void)didFinishLoadAdView {
    [super didFinishLoadAdView];
    
    //显示pop广告
    if (self.showADViewAnimate) {
        self.showADViewAnimate (YES);
    }
}

@end
