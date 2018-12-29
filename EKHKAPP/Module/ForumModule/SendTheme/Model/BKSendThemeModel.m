/**
 -  BKSendThemeModel.m
 -  BKHKAPP
 -  Created by ligb on 2017/8/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BKSendThemeModel.h"


@implementation BKSendThemeModel

- (void)getReportMessage:(void(^)(NSArray <BKReportModel *>*array))block {
    [EKHttpUtil mHttpWithUrl:kReportReasonURL parameter:nil response:^(BKNetworkModel *model, NSString *netErr) {
        if (model.status) {
            NSArray *array = model.data;
            NSMutableArray *reportData = [NSMutableArray arrayWithCapacity:array.count];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [reportData addObject:[BKReportModel yy_modelWithJSON:obj]];
            }];
            block (reportData);
        }
    }];
}

- (void)mSendReportURL:(NSString *)url
                params:(NSDictionary *)params
               handler:(void(^)(NSString *message, BOOL status))handler {
    [EKHttpUtil mHttpWithUrl:url parameter:params response:^(BKNetworkModel *model, NSString *netErr) {
        if (netErr) {
            handler (netErr, NO);
        } else {
            handler (model.message, model.status);
        }
    }];
}

- (void)mSendThemeURL:(NSString *)url param:(NSDictionary *)params files:(NSArray *)files precent:(void(^)(float precent))precentblock block:(void(^)(BKNetworkModel *model, NSString *netErr))block {
    [[BKNetworking share] upload:url params:params files:files precent:^(float precent) {
        precentblock(precent);
    } completion:^(BKNetworkModel *model, NSString *netErr) {
        block(model, netErr);
    }];
}


@end
