
/**
 -  UserHelper.m
 -  BKMobile
 -  Created by HY on 17/1/9.
 -  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
 */

#import "BKUserHelper.h"
#import "AppDelegate.h"

@implementation BKUserHelper

+ (void)setCookie{
    int randomNum = [self getRandomNumber:1000 to:9999];
    NSString *randomAndUid = [NSString stringWithFormat:@"%i%@", randomNum, USERID];
    NSData *nsdata = [randomAndUid
                      dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    NSMutableDictionary *cookiePropertiesUser = [NSMutableDictionary dictionary];
    if (LOGINSTATUS) {
        [cookiePropertiesUser setObject:@"ilink_stamp_value" forKey:NSHTTPCookieName];
    }else{
        [cookiePropertiesUser setObject:@"ilink_stamp_logout_value" forKey:NSHTTPCookieName];
    }
    [cookiePropertiesUser setObject:base64Encoded forKey:NSHTTPCookieValue];
    [cookiePropertiesUser setObject:@"eshop.baby-kingdom.com" forKey:NSHTTPCookieDomain];
    [cookiePropertiesUser setObject:@"/" forKey:NSHTTPCookiePath];
    [cookiePropertiesUser setObject:@"0" forKey:NSHTTPCookieVersion];
    [cookiePropertiesUser setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
    
    
    NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookiePropertiesUser];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
    
}

#pragma mark - 设置kmall缓存，判断用户登录状态，同步登录或退出kmall网站，shopping页面用到
+ (NSString *)setKmallWebCookies {
    int randomNum = [self getRandomNumber:1000 to:9999];
    NSString *randomAndUid = [NSString stringWithFormat:@"%i%@", randomNum, USERID];
    NSData *nsdata = [randomAndUid
                      dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    NSString *cookie = @"";

    if (TOKEN.length) {
        cookie = [@"ilink_stamp_value" stringByAppendingFormat:@"=%@",base64Encoded];
    } else {
        cookie = [@"ilink_stamp_logout_value" stringByAppendingFormat:@"=%@",base64Encoded];
    }
    return cookie;
}


+ (int)getRandomNumber:(int)from to:(int)to{
    return (int)(from + (arc4random() % (to - from + 1)));
}


//存储图片路径
+ (NSString *)saveImagePath:(UIImage *)image{
    //先创建用户文件夹，再在用户文件夹存入要图片文件
    NSString *path = [[self getLibraryFilePathManager] stringByAppendingPathComponent:kCacheUpImagePhotoKey];
    
    //如果不存在则创建临时存储目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if(![fileManager fileExistsAtPath:path]){
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
    NSString *tempName = [NSString stringWithFormat:@"img_%d.jpg",arc4random_uniform(10000)];
    path = [path stringByAppendingPathComponent:tempName];
    //保存图片文件
    BOOL isSave = [UIImageJPEGRepresentation(image, 0.7) writeToFile:path options:NSAtomicWrite error:&error];
    NSLog(@"图片保存状态 = %d",isSave);
    return tempName;
}


//获取图片路径
+ (NSString *)getImagePath:(NSString *)file{
    //先创建用户文件夹，再在用户文件夹存入要图片文件
    NSString *path = [[[self getLibraryFilePathManager] stringByAppendingPathComponent:kCacheUpImagePhotoKey] stringByAppendingPathComponent:file];
    return path;
}


+ (NSString *)getLibraryFilePathManager{
    //在Library下的创建用户文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *userFile = [NSString stringWithFormat:@"User_%@",USERID];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:userFile];
    return  path;
}

+ (BOOL)removeFilePath:(NSString *)path{
    //删除上传图片文件存储目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if([fileManager fileExistsAtPath:path]){
        BOOL succeed = [fileManager removeItemAtPath:path error:&error];
        NSLog(@"图片文件夹删除成功");
        return succeed;
    }
    return NO;
    
}


+ (BOOL)removeImagePath {
    //删除要上传的图片文件夹
    NSString *path = [self getLibraryFilePathManager];
    //删除上传图片文件存储目录
    return [self removeFilePath:path];
}


#pragma mark - 数据统计，跟踪用户信息
+ (void)trackingUserDataForType:(NSString *)eventType dicExtraData:(NSMutableDictionary *)dicExtraData{
    // THIS IS AN EXAMPLE OF SENDING TRACKING LOG
}

@end


