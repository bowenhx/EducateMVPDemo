
//
//  ReportModel.m
//  BKMobile
//
//  Created by HY on 16/5/26.
//  Copyright © 2016年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "ReportModel.h"

@implementation ReportModel

- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"id"]) {
        self.mId = [value integerValue];
    }
}

#pragma mark KVC 安全设置
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{}
- (void)setNilValueForKey:(NSString *)key
{}

@end
