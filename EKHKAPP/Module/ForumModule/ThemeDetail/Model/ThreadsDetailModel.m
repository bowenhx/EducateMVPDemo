//
//  BoardSubModel.m
//  BKMobile
//
//  Created by ligb on 16/5/25.
//  Copyright © 2016年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "ThreadsDetailModel.h"
#import "MotifTypeModel.h"

@implementation ThreadsDetailModel

- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"typeid"]) {
        self.Typeid = [value integerValue];
    }
    
    if ([key isEqualToString:@"threadtypes"])
    {
        if ([value isKindOfClass:[NSArray class]]) {
            NSMutableArray *arrData = [NSMutableArray array];
            
            [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MotifTypeModel *model = [[MotifTypeModel alloc] init];
                [model setValuesForKeysWithDictionary:obj];
                [arrData addObject:model];
            }];
            
            self.threadtypes = arrData;
        }
    }
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (void)setNilValueForKey:(NSString *)key
{
    //NSLog(@"%s",__func__);
}


@end

