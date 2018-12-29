/**
 -  ADHelper.h
 -  ADSDK
 -  Created by HY on 17/2/27.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BADGetparms : NSObject


/**
 获取系统版本信息
 */
+ (NSString *)mGetSystemVersion;


/**
 获取当前应用版本号
 */
+ (NSString *)mGetAppVersion;


/**
 获取手机唯一标识符
 */
+ (NSString *)mGetIdentifier;


/**
 获取设备型号
 */
+ (NSString *)mGetDeviceName;


/**
 获取IP地址
 */
+ (NSString *)mGetIPAddress;


@end
