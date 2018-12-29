/**
 -  FBInfoDataModel.m
 -  BKMobile
 -  Created by ligb on 2017/8/10.
 -  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
 */

#import "FBInfoDataModel.h"

@implementation FBItemModel
@end


@interface FBInfoDataModel ()

@end

@implementation FBInfoDataModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"gender"    : FBItemModel.class,
             @"age"       : FBItemModel.class,
             @"pregnancy" : FBItemModel.class,
             @"family"    : FBItemModel.class,
             @"child"     : FBItemModel.class,
             @"school"    : FBItemModel.class,
             @"income"    : FBItemModel.class,
             @"category"  : FBItemModel.class,
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    [self enumerateKeysDict:dic[@"birthday"] birthday:@"birthday"];
    [self enumerateKeysDict:dic[@"childitem"] birthday:@"childitem"];
    return YES;
}

- (void)enumerateKeysDict:(NSDictionary *)dic birthday:(NSString *)birkey{
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSArray *temp = obj;
        NSMutableArray <FBItemModel *> * tempArray = [NSMutableArray arrayWithCapacity:temp.count];
        
        [temp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tempArray addObject:[FBItemModel yy_modelWithJSON:obj]];
        }];
        if ([birkey isEqualToString:@"birthday"]) {
            if ([key isEqualToString: @"year"]) {
                self.birthday_year = tempArray;
            } else if ([key isEqualToString: @"month"]) {
                self.birthday_month = tempArray;
            }
        } else {
            if ([key isEqualToString: @"year"]) {
                self.childitem_year = tempArray;
            } else if ([key isEqualToString: @"month"]) {
                self.childitem_month = tempArray;
            } else if ([key isEqualToString: @"gender"]) {
                self.childitem_gender = tempArray;
            } else if ([key isEqualToString: @"school"]) {
                self.childitem_school = tempArray;
            }
        }
        
    }];
}

@end







