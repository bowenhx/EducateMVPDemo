/**
 -  EKHomeVoteOptionsModel.m
 -  EKHKAPP
 -  Created by ligb on 2017/9/20.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "EKHomeVoteOptionsModel.h"

@interface EKHomeVoteOptionsModel ()

@end

@implementation EKHomeVoteOptionsModel

+ (BOOL)mIsSelectedValue:(NSNumber *)value withForInSet:(NSArray *)array {
    __block BOOL isValue = NO;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            NSNumber *tempObj = (NSNumber *)obj;
            //            NSInteger tager = tempObj.integerValue;
            if ([value isEqual:tempObj]) {
                isValue = YES;
            }
        }
    }];
    return isValue;
}

@end
