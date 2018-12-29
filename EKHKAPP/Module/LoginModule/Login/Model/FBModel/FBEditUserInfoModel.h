/**
 -  FBEditUserInfoModel.h
 -  BKMobile
 -  Created by ligb on 2017/8/9.
 -  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
 -  说明：
 */

#import <Foundation/Foundation.h>


@interface FBEditUserInfoModel : NSObject

//首次登陆facebook
+ (void)facebookUserInfoEidt:(NSDictionary *)info back:(void(^)(BKNetworkModel *fbmodel, NSString *error))block;

@end
