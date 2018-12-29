/**
 -  BKLoopViewModel.h
 -  BKHKAPP
 -  Created by HY on 2017/8/16.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：首页头部滚动view的模型类
 */

#import "BKLoopViewModel.h"

@implementation BKLoopViewModel
+ (void)mRequestLoopViewDataWithCallBack:(void (^)(NSArray <BKLoopViewModel *>*data))callBack {
    [EKHttpUtil mHttpWithUrl:kHomeRecommendURL
                   parameter:nil
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (1 == model.status) {
                            if (model.data && [model.data isKindOfClass:[NSDictionary class]]) {
                                id listArray = model.data[@"lists"];
                                if (listArray && [listArray isKindOfClass:[NSArray class]]) {
                                    NSMutableArray *tempArray = [NSMutableArray array];
                                    for (NSDictionary *dictionary in listArray) {
                                        [tempArray addObject:[BKLoopViewModel yy_modelWithDictionary:dictionary]];
                                    }
                                    callBack(tempArray.copy);
                                }
                            }
                        }
                    }];
}


- (NSString *)description {
    return [self yy_modelDescription];
}
@end
