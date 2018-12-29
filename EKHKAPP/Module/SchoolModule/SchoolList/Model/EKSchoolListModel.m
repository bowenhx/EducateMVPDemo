/**
 -  EKSchoolListModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/12.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:后台返回的"学校列表"的model
 */

#import "EKSchoolListModel.h"

@implementation EKSchoolListModel

+ (void)mRequestSchoolListModelDataWithAreaID:(NSString *)areaID
                                     CallBack:(void(^)(NSArray <EKSchoolListModel *> *data, NSString *netErr))callBack {
    NSDictionary *parameter = @{@"areaid" : areaID};
    [EKHttpUtil mHttpWithUrl:kSchoolAreaURL
                   parameter:parameter
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (netErr) {
                            callBack(nil, netErr);
                        } else {
                            if (model.status) {
                                if (model.data && [model.data isKindOfClass:[NSArray class]]) {
                                    NSMutableArray *tempArray = [NSMutableArray array];
                                    for (NSDictionary *dictionary in model.data) {
                                        [tempArray addObject:[EKSchoolListModel yy_modelWithDictionary:dictionary]];
                                    }
                                    callBack(tempArray.copy, nil);
                                }
                            } else {
                                callBack(nil, model.message);
                            }
                        }
                    }];
}


+ (void)mRequestSchoolListModelDataWithKeyword:(NSString *)keyword
                                      callBack:(void(^)(NSArray <EKSchoolListModel *> *data, NSString *netErr))callBack {
    NSDictionary *parameter = @{@"token" : TOKEN,
                                @"keyword" : keyword};
    [EKHttpUtil mHttpWithUrl:kSchoolSearchURL
                   parameter:parameter
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (netErr) {
                            callBack(nil, netErr);
                        } else {
                            if (model.data && [model.data isKindOfClass:[NSArray class]]) {
                                NSMutableArray *tempArray = [NSMutableArray array];
                                for (NSDictionary *dictionary in model.data) {
                                    [tempArray addObject:[EKSchoolListModel yy_modelWithDictionary:dictionary]];
                                }
                                callBack(tempArray.copy, nil);
                            } else {
                                callBack(nil, model.message);
                            }
                        }
                    }];
}


@end
