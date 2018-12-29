/**
 -  SaveUser.m
 -  BKSDK
 -  Created by HY on 16/11/24.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 */

#import "BKSaveUser.h"
#import <BKSDK/BKSDK.h>

static NSString *userDB = @"user.db";
static BKUserModel *currUser;

@implementation BKSaveUser

#pragma mark - 保存用户信息
+ (void)mSaveUser:(BKUserModel *)user {
    NSString *cachePath = [BKTool getDocumentsPath:userDB];
    BOOL result = [NSKeyedArchiver archiveRootObject:user toFile:cachePath]; //归档
    if (result) {
        currUser = user;
    }
    
}


#pragma mark - 获取用户信息
+ (BKUserModel *)mGetUser {
    if (nil != currUser) {
        return currUser;
    }
    NSString *cachePath = [BKTool getDocumentsPath:userDB];
    BKUserModel *user = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
    return user;
}


@end
