/**
 -  EKHomeActivityEventModel.m
 -  EKHKAPP
 -  Created by ligb on 2017/9/20.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "EKHomeActivityEventModel.h"


@implementation EKHomeActivityEventModel
- (NSString *)description {
    return [self yy_modelDescription];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"aDescription":@"description"
             };
}
@end
