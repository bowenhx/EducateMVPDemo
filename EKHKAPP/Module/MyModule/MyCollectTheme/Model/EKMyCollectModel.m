/**
 -  EKMyCollectModel.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/27.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是后台返回的"我的收藏"的model
 */

#import "EKMyCollectModel.h"

@implementation EKMyCollectModel
/**
 请求"我的收藏"后台数据
 
 @param type "我的收藏"的三种类型数据
 @param page 页码参数
 @param callBack 完成回调
 */
+ (void)mRequestMyCollectModelDataSourceWithType:(EKMyCollectModelType)type
                                            page:(NSInteger)page
                                        callBack:(void(^)(NSString *netErr, NSArray <EKMyCollectModel *> *data))callBack {
    NSArray *typeArray = @[@"thread", @"forum", @"group", @"all"];
    NSDictionary *parameter = @{@"token" : TOKEN,
                                @"type" : typeArray[type],
                                @"page" : @(page)};
    [EKHttpUtil mHttpWithUrl:kUserMyCollectURL
                   parameter:parameter
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (netErr) {
                            callBack(netErr, nil);
                        } else {
                            if (1 == model.status) {
                                NSMutableArray <EKMyCollectModel *> *tempArray = [NSMutableArray array];
                                if (model.data && [model.data isKindOfClass:[NSArray class]]) {
                                    for (NSDictionary *dictionary in model.data) {
                                        [tempArray addObject:[EKMyCollectModel yy_modelWithDictionary:dictionary]];
                                    }
                                    callBack(nil, tempArray.copy);
                                }
                            } else {
                                if ([model.message isEqualToString:@"沒有更多數據"]) {
                                    callBack(nil, nil);
                                } else {
                                    callBack(model.message, nil);
                                }
                            }
                        }
                    }];
}


- (NSString *)description {
    return [self yy_modelDescription];
}
@end
