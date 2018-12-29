/**
 -  EKHomeItemModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/19.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:"首页"顶部横向标签栏对应的后台model数据
 */

#import "EKHomeItemModel.h"

@implementation EKHomeItemModel
+ (void)mRequestHomeItemDataWithCallBack:(void(^)(NSString *netErr, NSArray<EKHomeItemModel *>*homeItemDataSource))callBack {
    NSDictionary *parameter = @{@"token" : TOKEN};
    [EKHttpUtil mHttpWithUrl:kHomeTopItemURL
                   parameter:parameter
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (netErr) {
                            callBack(netErr, nil);
                        } else {
                            if (1 == model.status) {
                                NSMutableArray <EKHomeItemModel *> *tempArray = [NSMutableArray array];
                                if (model.data && [model.data isKindOfClass:[NSArray class]]) {
                                    for (NSDictionary *dictionary in model.data) {
                                        EKHomeItemModel *homeItemModel = [EKHomeItemModel yy_modelWithDictionary:dictionary];
                                        [tempArray addObject:homeItemModel];
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
