/**
 -  EKHomeListModel.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/19.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:"首页"四个列表的后台数据(论坛话题列表/bk milk文章列表/tv数据列表/kmall产品列表)
 */

#import "EKHomeListModel.h"

@implementation EKHomeListModel
+ (void)mRequestHomeListDataWithTabID:(NSString *)tabID
                             callBack:(void(^)(NSString *netErr, EKHomeListModel *homeListModel))callBack {
    NSDictionary *parameter = @{@"token" : TOKEN,
                                @"tabid" : tabID};
    [EKHttpUtil mHttpWithUrl:kHomeListURL
                   parameter:parameter
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (netErr) {
                            callBack(netErr, nil);
                        } else {
                            if (1 == model.status) {
                                if (model.data && [model.data isKindOfClass:[NSDictionary class]]) {
                                    EKHomeListModel *homeListModel = [EKHomeListModel yy_modelWithDictionary:model.data];
                                    callBack(nil, homeListModel);
                                }
                            } else {
                                callBack(model.message, nil);
                            }
                        }
                    }];
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"thread" : [EKHomeThreadModel class],
             @"milk" : [EKHomeMilkModel class],
             @"tv" : [EKHomeTVModel class],
             @"kmall" : [EKHomeKMallModel class]};
}
@end
