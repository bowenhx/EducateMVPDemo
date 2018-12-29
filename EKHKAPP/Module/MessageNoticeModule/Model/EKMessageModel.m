/**
 -  EKMessageModel.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/3.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"消息提醒"界面的后台返回的"消息"数据
 */

#import "EKMessageModel.h"

@implementation EKMessageModel
/**
 请求"消息"数据
 
 @param page page参数
 @param callBack 完成回调(注意,返回的数据源是model不是数组,数组得通过lists属性获得)
 */
+ (void)mRequestMessageModelWithPage:(NSInteger)page
                            callBack:(void(^)(NSString *netErr, EKMessageModel *messageModel))callBack {
    NSDictionary *parameter = @{@"token" : TOKEN,
                                @"page" : @(page)};
    [EKHttpUtil mHttpWithUrl:kMessageListURL
                   parameter:parameter
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (netErr) {
                            callBack(netErr, nil);
                        } else {
                            if (1 == model.status) {
                                if (model.data && [model.data isKindOfClass:[NSDictionary class]]) {
                                    EKMessageModel *messageModel = [EKMessageModel yy_modelWithDictionary:model.data];
                                    callBack(nil, messageModel);
                                }
                            } else {
                                callBack(model.message, nil);
                            }
                        }
                    }];
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"lists" : [EKMessageListModel class]};
}


- (NSString *)description {
    return [self yy_modelDescription];
}
@end
