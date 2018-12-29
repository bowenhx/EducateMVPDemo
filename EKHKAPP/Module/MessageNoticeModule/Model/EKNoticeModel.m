/**
 -  EKNoticeModel.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/3.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"消息提醒"界面的"提醒"列表的后台数组model
 */

#import "EKNoticeModel.h"

@implementation EKNoticeModel
/**
 请求"提醒"后台数据
 
 @param page page参数
 @param callBack 完成回调
 */
+ (void)mRequestNoticeModelDataSourceWithPage:(NSInteger)page
                                     callBack:(void(^)(NSString *netErr, EKNoticeModel *noticeModel))callBack {
    NSDictionary *parameter = @{@"token" : TOKEN,
                                @"page" : @(page)};
    [EKHttpUtil mHttpWithUrl:kNoticeListURL
                   parameter:parameter
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (netErr) {
                            callBack(netErr, nil);
                        } else {
                            if (1 == model.status) {
                                if (model.data && [model.data isKindOfClass:[NSDictionary class]]) {
                                    EKNoticeModel *noticeModel = [EKNoticeModel yy_modelWithDictionary:model.data];
                                    //对lists数组字段内的各个对象的type属性做处理,转成本地的vType枚举值属性
                                    for (EKNoticeListModel *listModel in noticeModel.lists) {
                                        [listModel mTypeChange];
                                    }
                                    callBack(nil, noticeModel);
                                }
                            } else {
                                callBack(model.message, nil);
                            }
                        }
                    }];
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"lists" : [EKNoticeListModel class]};
}


- (NSString *)description {
    return [self yy_modelDescription];
}
@end
