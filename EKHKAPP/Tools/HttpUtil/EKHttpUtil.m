/**
 -  EKHttpUtil.m
 -  EKHKAPP
 -  Created by HY on 2017/9/7.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：EK使用的网络工具类中间层
 */

#import "EKHttpUtil.h"

@implementation EKHttpUtil

+ (void)mHttpWithUrl:(NSString *)url parameter:(NSDictionary *)parameter response:(CompletionBlock)block {
    if (parameter) {
        [self startPOST:url parameters:parameter response:block];
    } else {
        [self startGET:url response:block];
    }
}

+ (void)startGET:(NSString *)urlString response:(CompletionBlock)block {
    [[BKNetworking share] get:urlString completion:^(BKNetworkModel *model, NSString *netErr) {
        [self mNetDataManageWithModel:model netErr:netErr response:block];
    }];
}

+ (void)startPOST:(NSString *)urlSring parameters:(NSDictionary *)parameters response:(CompletionBlock)block {
    [[BKNetworking share] post:urlSring params:parameters completion:^(BKNetworkModel *model, NSString *netErr) {
        [self mNetDataManageWithModel:model netErr:netErr response:block];
    }];
}

//处理网络请求过来后的数据
+ (void)mNetDataManageWithModel:(BKNetworkModel *)model netErr:(NSString *)netErr response:(CompletionBlock)block{
    if (netErr) {
        if (block) {
            block(nil, netErr);
        }
    } else {
        if (block) {
            if (-2 == model.status) {
                [BKUserModel mClearUserInfo];
                block(nil, model.message);
            } else {
                block(model, nil);
            }
        } else {
            DLog(@"当前网络回调block为空 %s",__func__);
        }
    }
}

/**
 上传图片
 
 @param URLString 地址
 @param parameter 参数
 @param image 图片
 @param percentBlock 进度回调
 @param completionBlock 完成回调
 */
+ (void)mUploadWithURLString:(NSString *)URLString
                   parameter:(NSDictionary *)parameter
                       image:(UIImage *)image
                percentBlock:(PrecentBlock)percentBlock
             completionBlock:(CompletionBlock)completionBlock {
    [[BKNetworking share] upload:URLString
                          params:parameter
                           image:image
                         precent:percentBlock
                      completion:completionBlock];
}

@end

