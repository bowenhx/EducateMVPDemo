/**
 -  BKUserModel.h
 -  BKHKAPP
 -  Created by HY on 2017/8/9.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：用户登录以后，得到的user对象
 */

#import <Foundation/Foundation.h>
#import "BKUserGroupModel.h"

/**
 BKUserModel实现了NSCoding，用于用户的本地存储
 */
@interface BKUserModel : NSObject <NSCoding>

#pragma mark - 属性
@property (copy, nonatomic) NSString *adminid;
@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *groupid;
@property (copy, nonatomic) NSString *grouptitle;
@property (copy, nonatomic) NSString *loginovertime;
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *username;
@property (strong, nonatomic) BKUserGroupModel *groups;


#pragma mark - 业务方法

/**
 用户登录的网络请求

 @param userName 用户名
 @param password 用户密码
 @param callBack 登录结果
 */
- (void)mLoginWithWithUserName:(NSString*)userName password:(NSString*)password callBack:(void (^)(NSString *message))callBack;


/**
 用户登录成功后，保存数据等操作

 @param userData 登录成功后获得的用户信息
 @param password 用户密码
 @param isHome 是否进入首页，yes代表需要发送登录成功的通知，no不用发送登录成功通知用于fb登录情况
 */
- (void)mLoginSuccessWithData:(NSDictionary *)userData password:(NSString*)password isHome:(BOOL)isHome;


/**
 用户退出登录的处理

 @param callBack 退出登录后完成的回调
 */
+ (void)mLogOutWithCallBack:(void(^)(NSString *netErr))callBack;


/**
 清空当前用户信息
 */
+ (void)mClearUserInfo;

@end

