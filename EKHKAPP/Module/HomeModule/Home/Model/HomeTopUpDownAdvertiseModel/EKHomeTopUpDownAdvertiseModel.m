/**
 -  EKHomeTopUpDownAdvertiseModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/19.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:"首页"置顶左侧上下广告后台model
 */

#import "EKHomeTopUpDownAdvertiseModel.h"

@implementation EKHomeTopUpDownAdvertiseModel
+ (void)mRequestHomeTopUpDownAdvertiseDataWithCallBack:(void(^)(NSString *netErr, NSArray <EKHomeTopUpDownAdvertiseModel *>*data))callBack {
    NSDictionary *parameter = @{@"token" : TOKEN};
    [EKHttpUtil mHttpWithUrl:kHomeTopUpDownAdvertiseURL
                   parameter:parameter
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (netErr) {
                            callBack(netErr, nil);
                        } else {
                            if (1 == model.status) {
                                if (model.data && [model.data isKindOfClass:[NSArray class]]) {
                                    NSMutableArray <EKHomeTopUpDownAdvertiseModel *> *tempArray = [NSMutableArray array];
                                    for (NSDictionary *dictionary in model.data) {
                                        [tempArray addObject:[EKHomeTopUpDownAdvertiseModel yy_modelWithDictionary:dictionary]];
                                    }
                                    callBack(nil, tempArray.copy);
                                }
                            } else {
                                callBack(model.message, nil);
                            }
                        }
                    }];
}


- (NSString *)description {
    return [self yy_modelDescription];
}
@end
