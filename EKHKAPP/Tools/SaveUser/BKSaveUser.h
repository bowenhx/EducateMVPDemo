/**
 -  SaveUser.h
 -  BKSDK
 -  Created by HY on 16/11/24.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  使用NSKeyedArchiver存储方式，本地存取user对象
 */

#import <Foundation/Foundation.h>
#import "BKUserModel.h"

//当前用户登录状态 
#define LOGINSTATUS     [BKSaveUser mGetUser].token.length

//当前登录的user对象
#define USER            [BKSaveUser mGetUser]

//user 的 token
#define TOKEN           ([BKSaveUser mGetUser].token.length > 0 ? [BKSaveUser mGetUser].token:@"")

//user 的 id
#define USERID          ([BKSaveUser mGetUser].uid.length > 0 ? [BKSaveUser mGetUser].uid : @"")

//用户对象下包含的groups对象
#define USERGROUPS      [BKSaveUser mGetUser].groups

//用來保存用戶查看主題密碼
#define ForumPw_KEY         @"FORUMPWKEY"
#define ForumKey(pw)        [NSString stringWithFormat:@"forum_pw_%@",(pw)]

@interface BKSaveUser : NSObject

/**
 *  @brief  ##使用NSKeyedArchiver的归档，保存用户信息
 *
 *  @param  user  需要存储的用户对象
 */
+ (void)mSaveUser:(BKUserModel *)user;


/**
 *  @brief  ##获取本地存储的user对象
 *
 *  @return 返回user信息
 */
+ (BKUserModel *)mGetUser;

@end
