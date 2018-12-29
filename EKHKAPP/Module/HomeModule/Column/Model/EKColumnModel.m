/**
 -  EKColumnModel.m
 -  EKHKAPP
 -  Created by ligb on 2017/9/11.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "EKColumnModel.h"


@implementation EKColumnModel

//lists数组转换为BKThemeListModel模型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"subforums" : [EKForumCollectModel class] };
}


+ (void)mGetEKColumnModel:(void(^)(NSArray<EKColumnModel *> *array))block {
    NSArray *arr = [BKSaveData getArray:kPreferForumInfoKey];
    if (arr.count) {
        NSMutableArray *modelsArray = [NSMutableArray arrayWithCapacity:arr.count];
        if ([arr isKindOfClass:[NSArray class]]) {
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [modelsArray addObject:[EKColumnModel yy_modelWithJSON:obj]];
            }];
        }
        block(modelsArray);
    } else {
        [self mRequestForumCollectData:block];
    }
}

+ (void)mRequestForumCollectData:(void(^)(NSArray<EKColumnModel *> *array))block {
    [EKHttpUtil mHttpWithUrl:kCollectListURL parameter:@{@"token": TOKEN, @"type": @"forum", @"page": @1} response:^(BKNetworkModel *model, NSString *netErr) {
        if (netErr) {
             block(@[]);
        } else {
            if (model.status) {
                NSArray *data = model.data;
                NSMutableArray *modelsArray = [NSMutableArray arrayWithCapacity:data.count];
                if ([data isKindOfClass:[NSArray class]]) {
                    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [modelsArray addObject:[EKColumnModel yy_modelWithJSON:obj]];
                    }];
                    
                    [BKSaveData setArray:data key:kPreferForumInfoKey];
                    block(modelsArray);
                }
            } else {
                 block(@[]);
            }
        }
    }];
}


@end
