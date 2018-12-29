//
//  MotifTypeModel.m
//  BKMobile
//
//  Created by ligb on 16/5/27.
//  Copyright © 2016年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "MotifTypeModel.h"

@implementation MotifTypeModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //NSLog(@"%s",__func__);
    if ([key isEqual:@"id"]) {
        self.ID = [value integerValue];
    }
}
- (void)setNilValueForKey:(NSString *)key
{
    //NSLog(@"%s",__func__);
}

@end
