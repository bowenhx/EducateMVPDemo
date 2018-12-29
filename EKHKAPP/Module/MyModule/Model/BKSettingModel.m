/**
 -  BKSettingModel.m
 -  BKHKAPP
 -  Created by calvin_Tse on 2017/9/6.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:"设置"界面使用的model
 */

#import "BKSettingModel.h"

@implementation BKSettingModel
+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (instancetype)init {
    if (self = [super init]) {
        //设置默认字号
        _font = DetailSize_Middle;
        _motifFont = MotifSize_Max;
    }
    return self;
}
@end
