//
//  BADPopupWindow.h
//  EKHKAPP
//
//  Created by HY on 2018/3/24.
//  Copyright © 2018年 BaByKingdom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BADWindow.h"
#import "BADModel.h"
#import "PopupView.h"
#import "InterstitialView.h"

@interface BADPopupWindow : BADWindow

/**
 初始化
 
 @param  model 传递过来的广告model
 @return 返回
 */
- (instancetype)initWithModel:(BADModel *)model;

@end
