//
//  EKLoginPresenter.h
//  EKHKAPP
//
//  Created by ligb on 2017/10/16.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKLoginViewProtocol.h"

@interface EKLoginPresenter : NSObject

@property (nonatomic, weak) id<EKLoginViewProtocol> vLoginViewProtocol;

/**
 用户登录的操作
 
 @param userName 用户名
 @param password 用户密码
 */
- (void)mLoginWithWithUserName:(NSString*)userName password:(NSString*)password;

- (void)mSaveUserInfo:(NSDictionary *)info password:(NSString *)password isHome:(BOOL)isHome;
@end
