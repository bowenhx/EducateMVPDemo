//
//  BADInterstitialWindow.m
//  EKHKAPP
//
//  Created by HY on 2018/3/24.
//  Copyright © 2018年 BaByKingdom. All rights reserved.
//

#import "BADInterstitialWindow.h"
#import "BADWindow.h"
#import "BADRequest.h"
#import "BADConfig.h"

@implementation BADInterstitialWindow

#pragma mark - dealloc
- (void)dealloc {
    NSLog(@"%s",__func__);
}

#pragma mark - 单例
+ (BADInterstitialWindow *)sharedInstance {
    static dispatch_once_t predicate;
    static BADInterstitialWindow * instance;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)mInitSettingModel:(BADModel *)model {
    self.bkAdModel = model;
    [self mSettingAdView];
    self.backgroundColor = [UIColor whiteColor];
}

@end





