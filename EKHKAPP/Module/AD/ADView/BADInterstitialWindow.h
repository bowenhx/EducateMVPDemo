//
//  BADInterstitialWindow.h
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

@interface BADInterstitialWindow : BADWindow

+ (BADInterstitialWindow *)sharedInstance;

- (void)mInitSettingModel:(BADModel *)model;

@end
