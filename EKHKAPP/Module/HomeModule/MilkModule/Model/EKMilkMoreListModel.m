/**
 -  EKMilkMoreListModel.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/29.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是BKMilk界面,后台返回的列表数据
 */

#import "EKMilkMoreListModel.h"

@implementation EKMilkMoreListModel
+ (void)mRequestMilkMoreListDataWithTabid:(NSString *)tabid
                                     page:(NSInteger)page
                                 callBack:(void(^)(NSString *netErr, NSArray <EKMilkMoreListModel *> *data))callBack {
    NSDictionary *parameter = @{@"token" : TOKEN,
                                @"key" : tabid,
                                @"page" : @(page).description};
    [EKHttpUtil mHttpWithUrl:kMilkMoreURL
                   parameter:parameter
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (netErr) {
                            callBack(netErr, nil);
                        } else {
                            if (model.data && [model.data isKindOfClass:[NSArray class]]) {
                                NSMutableArray <EKMilkMoreListModel *> *tempArray = [NSMutableArray array];
                                for (NSDictionary *dictionary in model.data) {
                                    EKMilkMoreListModel *milkMoreListModel = [EKMilkMoreListModel yy_modelWithDictionary:dictionary];
                                    [tempArray addObject:milkMoreListModel];
                                }
                                callBack(nil, tempArray.copy);
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
