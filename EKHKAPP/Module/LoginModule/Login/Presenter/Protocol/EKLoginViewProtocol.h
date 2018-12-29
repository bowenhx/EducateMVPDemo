//
//  EKLoginViewProtocol.h
//  EKHKAPP
//
//  Created by ligb on 2017/10/16.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EKLoginViewProtocol <NSObject>

/**
 用户点击登录以后的结果
 
 @param isSuccess 返回登录成功或者失败,yes代表登录成功，no代表失败
 */
- (void)mLoginResultWithSuccess:(BOOL)isSuccess message:(NSString *)message;

/**
 发送网络请求之前，显示加载框
 */
- (void)mShowHUDActivity;

/**
 网络请求后，隐藏加载框
 */
- (void)mHiddenHUDActivity;

@end
