/**
 - BADInterstitial.h
 - BADSdk
 - Created by HY on 2017/12/13.
 - Copyright © 2017年 BaByKingdom. All rights reserved.
 - 说明：插屏广告
 */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BADRequest.h"
@class BADInterstitial;

@protocol BADInterstitialDelegate <NSObject>

/**
 告诉委托对象，全屏广告被点击了，内部web打开跳转链接
 
 @param interstitialView 当前被点击的全屏广告view
 @param url 点击跳转的链接
 */
- (void)adView:(BADInterstitial *)interstitialView didTouchInterstitialViewWithUrl:(NSString *)url;

@end


@interface BADInterstitial : NSObject

/// Required value passed in with initWithAdUnitID:.
@property(nonatomic, copy) NSString *adUnitID;

/// 可选的委托对象，监听bannerview的生命周期
@property(nonatomic, weak) id <BADInterstitialDelegate> delegate;



//单例
+ (BADInterstitial *)sharedInstance;


/**
 加载广告请求
 
 @param request 请求类，携带请求参数
 */
- (void)loadRequest:(BADRequest *)request;


@end
