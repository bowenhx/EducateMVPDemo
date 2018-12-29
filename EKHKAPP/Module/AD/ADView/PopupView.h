/**
 -  BAPopupView.h
 -  ADSDK
 -  Created by HY on 17/2/21.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "BADBaseView.h"

@interface PopupView : BADBaseView

//控制广告window 显示与隐藏，show为yes代表显示，no代表不显示
@property (nonatomic , copy) void (^showADViewAnimate)(BOOL show);

@end
