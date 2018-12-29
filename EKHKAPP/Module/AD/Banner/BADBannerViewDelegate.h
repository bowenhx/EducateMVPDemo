/**
 - BADBannerViewDelegate.h
 - BADSdk
 - Created by HY on 2017/12/13.
 - Copyright © 2017年 BaByKingdom. All rights reserved.
 - 说明：banner广告的代理方法
 */

#import <Foundation/Foundation.h>

@class BADBannerView;

@protocol BADBannerViewDelegate <NSObject>

@optional

#pragma mark Ad Request Lifecycle Notifications

/**
 告诉委托对象，请求成功，接收到返回的bannerviwe

 @param bannerView 当前请求到的bannerview
 */
- (void)adViewDidReceiveAd:(BADBannerView *)bannerView;


/**
 告诉委托对象，请求失败

 @param bannerView 当前bannerview
 @param error 失败信息
 */
- (void)adView:(BADBannerView *)bannerView didFailToReceiveAdWithError:(NSString *)error;


/**
 告诉委托对象，banner广告被点击了，跳转
 
 @param bannerView 当前bannerview
 @param url 点击跳转的链接
 */
- (void)adView:(BADBannerView *)bannerView didTouchBannerViewWithUrl:(NSString *)url;


@end

