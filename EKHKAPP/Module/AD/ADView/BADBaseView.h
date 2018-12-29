/**
 -  BADBaseView.h
 -  ADSDK
 -  Created by HY on 2017/3/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  banner，popup，fullScreen，三种广告都继承于BADBaseView
 */

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <objc/runtime.h>
#import "BADConfig.h"
#import "BADModel.h"


@class BAVideoPlay;

@protocol BADBaseViewDelegate <NSObject>

@optional
/**
 点击广告view触发的事件
 
 @param url 点击后跳转的链接
 */
- (void)mTouchAdViewWithUrl:(NSString *)url;

@end


@interface BADBaseView : UIView 

/** delegate */
@property (nonatomic, weak) id <BADBaseViewDelegate> baseDelegate;

//广告数据模型
@property (nonatomic, strong) BADModel *bkAdModel;

@property (nonatomic, strong) BADDetailModel *infoModel;

//webView 加载的url内容
@property (nonatomic, copy) NSString *content;

/**
 初始设置方法

 @param bkAdModel 广告模型类
 */
- (void)mSettingViewWithModel:(BADDetailModel *)bkAdModel;


/**
 广告加载完成后调用
 */
- (void)didFinishLoadAdView;


/**
 点击广告view事件,子类需要重写父类方法，隐藏被点击的广告
 */
- (void)mTouchAdViewEvent;


@end

