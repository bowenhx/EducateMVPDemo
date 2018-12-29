//
//  EKThemeSubforumsModel.m
//  EKHKAPP
//
//  Created by ligb on 2017/9/30.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import "EKThemeSubforumsModel.h"

@implementation EKThemeSubforumsModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"Description":@"description"
             };
}


- (NSString *)description {
    return [self yy_modelDescription];
}
@end
