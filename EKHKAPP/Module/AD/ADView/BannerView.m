/**
 -  BannerView.m
 -  ADSDK
 -  Created by HY on 17/2/21.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BannerView.h"

@interface BannerView()

@end

@implementation BannerView

#pragma mark - dealloc
- (void)dealloc {
    NSLog(@"%s",__func__);
}

#pragma mark - 初始化方法
- (id)init {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
