/**
 -  EKFriendModel.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/31.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"我的好友"界面的后台返回的数据
 */

#import "EKFriendModel.h"

@implementation EKFriendModel
/**
 请求"我的好友"列表参数
 
 @param callBack 完成回调
 */
+ (void)mRequestFriendModelDataSourceWithCallBack:(void(^)(NSString *netErr, NSArray <EKFriendModel *> *data))callBack {
    NSDictionary *parameter = @{@"token" : TOKEN,
                                @"group" : @(-1)};
    [EKHttpUtil mHttpWithUrl:kFriendListURL
                   parameter:parameter
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (netErr) {
                            callBack(netErr, nil);
                        } else {
                            if (1 == model.status) {
                                if (model.data && [model.data isKindOfClass:[NSArray class]]) {
                                    NSMutableArray <EKFriendModel *> *tempArray = [NSMutableArray array];
                                    for (NSDictionary *dictionary in model.data) {
                                        EKFriendModel *friendModel = [EKFriendModel yy_modelWithDictionary:dictionary];
                                        [tempArray addObject:friendModel];
                                    }
                                    callBack(nil, tempArray.copy);
                                }
                            } else {
                                callBack(model.message, nil);
                            }
                        }
                    }];
}

@end
