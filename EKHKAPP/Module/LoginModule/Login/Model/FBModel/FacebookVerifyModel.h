//
//  FacebookVerifyModel.h
//  BKMobile
//
//  Created by ligb on 2017/7/26.
//  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FacebookVerifyModel : NSObject

//facebook 登陆验证请求
+ (void)verifyUserInfo:(NSDictionary *)info back:(void(^)(BKNetworkModel *fbmodel, NSString *error))block;

//首次登陆facebook 
+ (void)facebookRegister:(NSDictionary *)info back:(void(^)(BKNetworkModel *fbmodel, NSString *error))block;

@end
