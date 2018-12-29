/**
 -  EKADViewController.h
 -  EKHKAPP
 -  Created by HY on 2018/1/17.
 -  Copyright © 2018年 BaByKingdom. All rights reserved.
 -  说明:统一处理广告的类，继承于base，如果使用广告，页面需要继承于该类
 
     使用说明：
     1：使用的viewController需要继承于EKBaseViewController
     2：请求全屏广告    [self mRequestInterstitialView];
     3：请求popup广告  [self mRequestPopupView:0];
     4：请求banner广告
         4.1: [self mRequestBannerView];
         4.2: 实现- (void)mMergeBannerAdData;方法，可以直接使用self.vBannerArray合并广告数据
 
 */

#import <UIKit/UIKit.h>
#import "EKBaseViewController.h"
#import "BADBannerView.h"
#import "BADInterstitial.h"
#import "BADPopup.h"

static int kADSpace = 4; //按照需求规定，每隔4条数据显示一条广告
static NSString *kAD = @"ad"; //标示广告类型
static NSString *kNormal = @"normal"; //普通的单元格

@interface EKADViewController : EKBaseViewController

//主题列表和主题详情，需要拼接当前板块的id。
@property (nonatomic, copy) NSString *vAdFid;


//banner广告数据源
@property (nonatomic, strong) NSMutableArray <BADBannerView *> *vBannerArray;


/**
 请求banner广告数据

 */
- (void)mRequestBannerView;


/**
 外部重写该方法，此时banner广告数据已经全部请求完成，可以直接使用vBannerArray
 */
- (void)mMergeBannerAdData;


/**
 请求全屏广告
 */
- (void)mRequestInterstitialView;


/**
 请求popup广告

 @param vBottomSpace popup广告距离屏幕下方的高度，例如一级界面要传递 49，防止遮挡下方tabbar
 */
- (void)mRequestPopupView:(CGFloat)vBottomSpace;


@end
