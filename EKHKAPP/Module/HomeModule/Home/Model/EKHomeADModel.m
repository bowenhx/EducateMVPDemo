
//
//  EKHomeADModel.m
//  EKHKAPP
//
//  Created by HY on 2017/11/15.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import "EKHomeADModel.h"

@implementation EKHomeADModel


+ (void)mRequestHomeAD:(void(^)(NSString *netErr, NSArray<EKHomeADModel *>*homeADSource))callBack {
    
    NSString *width = [NSString stringWithFormat:@"%f",SCREEN_WIDTH];
    NSDictionary *parameter = @{@"token" : TOKEN, @"width" : width, @"tabid" : @"1", @"ipad":@"0"};
    [EKHttpUtil mHttpWithUrl:kHomeBannerADURL parameter:parameter response:^(BKNetworkModel *model, NSString *netErr) {
        if (netErr) {
            //加载错误时候，需要隐藏两个广告位
            callBack(netErr, nil);
        } else {
            if (1 == model.status) {
                NSMutableArray <EKHomeADModel *> *tempArray = [NSMutableArray array];
                if (model.data && [model.data isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dictionary in model.data) {
                        EKHomeADModel *homeItemModel = [EKHomeADModel yy_modelWithDictionary:dictionary];
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


@end
