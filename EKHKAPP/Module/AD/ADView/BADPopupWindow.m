//
//  BADPopupWindow.m
//  EKHKAPP
//
//  Created by HY on 2018/3/24.
//  Copyright © 2018年 BaByKingdom. All rights reserved.
//

#import "BADPopupWindow.h"
#import "BADWindow.h"
#import "BADRequest.h"
#import "BADConfig.h"


@implementation BADPopupWindow

#pragma mark - dealloc
- (void)dealloc {
    NSLog(@"%s",__func__);
}

#pragma mark - 初始化
- (instancetype)initWithModel:(BADModel *)model {
    self = [super init];
    if (self) {
        self.bkAdModel = model;
        [self mSettingAdView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


@end





