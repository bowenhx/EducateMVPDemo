/**
 -  EKSearchUserModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/22.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是后台返回的"搜索用户"数据model
 */

#import "EKSearchUserModel.h"

@implementation EKSearchUserModel

+ (void)mRequestAddFriendWithUid:(NSString *)uid
                            note:(NSString *)note
                             gid:(NSInteger)gid
                        callBack:(void(^)(NSString *netErr, NSString *message))callBack {
    NSDictionary *parameter = @{@"token" : TOKEN,
                                @"uid" : uid,
                                @"note" : note,
                                @"gid" : @(gid).description};
    [EKHttpUtil mHttpWithUrl:kFriendAddOrAgreeURL
                   parameter:parameter
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (netErr) {
                            callBack(netErr, nil);
                        } else {
                            callBack(nil, model.message);
                        }
                    }];
}


+ (void)mRequestDeleteFriendWithUid:(NSString *)uid callBack:(void (^)(BOOL, NSString *))callBack {
    NSDictionary *parameter = @{@"token" : TOKEN,
                                @"uid" : uid};
    [EKHttpUtil mHttpWithUrl:kFriendDeleteOrIgnoreURL
                   parameter:parameter
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (netErr) {
                            callBack(NO, netErr);
                        } else {
                            if (1 == model.status) {
                                callBack(YES, model.message);
                            } else {
                                callBack(NO, model.message);
                            }
                        }
                    }];
}

- (NSString *)description {
    return [self yy_modelDescription];
}
@end
