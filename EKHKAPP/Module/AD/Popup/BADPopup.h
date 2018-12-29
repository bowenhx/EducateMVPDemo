//
//  BADPopupPlay.h
//  BADSdk
//
//  Created by ligb on 2017/12/29.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BADRequest.h"
@class BADPopup;

@protocol BADPopupViewDelegate <NSObject>

/**
 告诉委托对象，popup广告被点击了，内部web打开跳转链接
 
 @param popupView 当前被点击的popupview
 @param url 点击跳转的链接
 */
- (void)adView:(BADPopup *)popupView didTouchPopupViewWithUrl:(NSString *)url;

@end


@interface BADPopup : NSObject

/// Required value passed in with initWithAdUnitID:.
@property (nonatomic, readonly, copy) NSString *adUnitID;

/// 例如：弹窗广告如果在一级界面，不能遮挡底部tabbar，需要传递距离底部高度
@property (nonatomic, assign) CGFloat vBottomHeight;

/// 可选的委托对象，监听bannerview的生命周期
@property(nonatomic, weak) id <BADPopupViewDelegate> delegate;


/**
 初始化popup广告
 
 @param adUnitID 广告id
 @return 返回一个BADPopup
 */
- (instancetype)initWithAdUnitID:(NSString *)adUnitID;


/**
 加载广告请求
 
 @param request 请求类，携带请求参数
 */
- (void)loadRequest:(BADRequest *)request;


@end
