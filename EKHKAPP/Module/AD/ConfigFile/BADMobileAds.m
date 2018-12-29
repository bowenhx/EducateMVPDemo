//
//  BADMobileAds.m
//  BADSdk
//
//  Created by ligb on 2017/12/15.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import "BADMobileAds.h"
#import "BADGetparms.h"

@interface BADMobileAds()

@property (nonatomic, copy) NSString *applicationID;

@end;

@implementation BADMobileAds

+ (BADMobileAds *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceObj;
    dispatch_once(&onceObj, ^{
        sharedInstance = [[BADMobileAds alloc] init];
    });
    return sharedInstance;
}

+ (void)configureWithApplicationID:(NSString *)applicationID {
    BADMobileAds *mobileAds = [self sharedInstance];
    mobileAds.applicationID = applicationID;
}

- (NSDictionary *)vParames {
    if (!_applicationID) return nil;
    return @{
             @"device":@{
                      @"model":[BADGetparms mGetDeviceName],
                      @"os_version":[BADGetparms mGetSystemVersion],
                      @"ip_address":[BADGetparms mGetIPAddress],
                      @"identifier":[BADGetparms mGetIdentifier],
                      @"res_width":[NSString stringWithFormat:@"%f",[[UIScreen mainScreen] bounds].size.width],
                      @"res_height":[NSString stringWithFormat:@"%f",[[UIScreen mainScreen] bounds].size.height]
                      },
              @"app":@{
                      @"appid":_applicationID,
                      @"appversion":@"2.4"//[BADGetparms mGetAppVersion]
                      }
             };
}

@end




