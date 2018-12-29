//
//  BADMobileAds.h
//  BADSdk
//
//  Created by ligb on 2017/12/15.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BADMobileAds : NSObject

@property (nonatomic, strong, readonly) NSDictionary *vParames;

/// Returns the shared BADMobileAds instance.
+ (BADMobileAds *)sharedInstance;

/// Configures the SDK using the settings associated with the given application ID.
+ (void)configureWithApplicationID:(NSString *)applicationID;

@end


