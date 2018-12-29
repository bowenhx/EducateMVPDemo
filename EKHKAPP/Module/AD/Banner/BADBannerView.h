/**
 - BADBannerView.h
 - BADSdk
 - Created by HY on 2017/12/13.
 - Copyright © 2017年 BaByKingdom. All rights reserved.
 - 说明：Banner广告
 */

#import <UIKit/UIKit.h>
#import "BADRequest.h"
#import "BADAdSize.h"
#import "BADConfig.h"
#import "BADBannerViewDelegate.h"

@interface BADBannerView : UIView

#pragma mark - Initialization

/// Example ad unit ID
@property(nonatomic, copy) NSString *adUnitID;

/// 广告尺寸
@property(nonatomic, assign) BADAdSize adSize;

///【BADAdSize=Custom】才适用，自定义广告尺寸【宽】
@property(nonatomic, copy) NSString *adWidth;

///【BADAdSize=Custom】才适用，自定义广告尺寸【高】
@property(nonatomic, copy) NSString *adHeight;

/// 可选的委托对象，监听bannerview的生命周期
@property(nonatomic, weak) id <BADBannerViewDelegate> delegate;

/// 保存后台返回广告的高度，外部可使用
@property(nonatomic, assign) CGFloat vBannerHeight;


/**
 初始化banner广告
 
 @param adSize 预定义广告大小
 @return 返回一个BADBannerView
 */
- (instancetype)initWithAdSize:(BADAdSize)adSize;


/**
 加载广告请求

 @param request 请求类，携带请求参数
 */
- (void)loadRequest:(BADRequest *)request;

@end
