/**
 -  FBEditUserInfoPersenter.h
 -  BKMobile
 -  Created by ligb on 2017/8/10.
 -  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
 -  说明：
 */

#import <Foundation/Foundation.h>

@class FBInfoDataModel;

@interface FBEditUserInfoPersenter : NSObject

- (void)getEditData:(void (^)(FBInfoDataModel *fbModel))block;

- (void)commitFBEditInfo:(NSDictionary *)info block:(void(^)(BKNetworkModel *model,NSString *message))block;

@end
