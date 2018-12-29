//
//  FacebookVerifyModel.m
//  BKMobile
//
//  Created by ligb on 2017/7/26.
//  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "FacebookVerifyModel.h"


@implementation FacebookVerifyModel

+ (void)verifyUserInfo:(NSDictionary *)info back:(void(^)(BKNetworkModel *fbmodel, NSString *error))block {
    [self mRequestHttpURL:kFaceBookLoginURL pram:info back:block];
}

+ (void)facebookRegister:(NSDictionary *)info back:(void(^)(BKNetworkModel *fbmodel, NSString *error))block{
    [self mRequestHttpURL:kFacebookRegister pram:info back:block];
}


+ (void)mRequestHttpURL:(NSString *)url pram:(NSDictionary *)info back:(void(^)(BKNetworkModel *fbmodel, NSString *error))block {
    [EKHttpUtil mHttpWithUrl:url parameter:info response:^(BKNetworkModel *model, NSString *netErr) {
        if (netErr) {
            block (nil , netErr);
        }else{
            block (model, nil);
        }
    }];
}

@end
