/**
 -  FBEditUserInfoPersenter.m
 -  BKMobile
 -  Created by ligb on 2017/8/10.
 -  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
 */

#import "FBEditUserInfoPersenter.h"
#import "FBEditUserInfoModel.h"
#import "FBInfoDataModel.h"

@interface FBEditUserInfoPersenter ()

@end

@implementation FBEditUserInfoPersenter


- (void)getEditData:(void (^)(FBInfoDataModel *fbModel))block{
    [FBEditUserInfoModel facebookUserInfoEidt:@{@"mode":@1} back:^(BKNetworkModel *fbmodel, NSString *error) {
        if (fbmodel.status == 1) {
            block([FBInfoDataModel yy_modelWithJSON:fbmodel.data]);
        }
    }];
}

- (void)commitFBEditInfo:(NSDictionary *)info block:(void(^)(BKNetworkModel *model,NSString *message))block{
    [FBEditUserInfoModel facebookUserInfoEidt:info back:^(BKNetworkModel *model, NSString *error) {
        if (error) {
            block(nil, error);
        } else{
            block(model, nil);
        }
    }];
}




@end

