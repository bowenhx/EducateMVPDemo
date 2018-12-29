/**
 - BADInterstitial.m
 - BADSdk
 - Created by HY on 2017/12/13.
 - Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BADInterstitial.h"
#import "BADInterstitialWindow.h"

@interface BADInterstitial() <BADBaseViewDelegate>
//
@property (nonatomic, strong) BADInterstitialWindow *fullScreenWindow;

@end;

@implementation BADInterstitial

- (void)dealloc {
    _fullScreenWindow.hidden = YES;
    [_fullScreenWindow removeFromSuperview];
    _fullScreenWindow = nil;
    NSLog(@"%s",__func__);
}


#pragma mark - 单例
+ (BADInterstitial *)sharedInstance {
    static dispatch_once_t predicate;
    static BADInterstitial * instance;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSString *)adUnitID {
    return _adUnitID;;
}

- (void)loadRequest:(BADRequest *)request {
    request.vDisplayType = const_BAD_DisplayType_Fullscreen;
    [request mADRequesWithUnitId:self.adUnitID finishAction:^(BADModel *adModel, NSString *netErr) {
        if (adModel) {
            [self mSettingInterstitialWithModel:adModel];
        }
    }];
}

- (void)mSettingInterstitialWithModel:(BADModel *)model {
    _fullScreenWindow = [BADInterstitialWindow sharedInstance];
    [_fullScreenWindow mInitSettingModel:model];
    _fullScreenWindow.vFullView.baseDelegate = self;
}



#pragma mark - BADBaseViewDelegate 点击广告view触发的事件
- (void)mTouchAdViewWithUrl:(NSString *)url {
    NSLog(@"== %s",__func__);
    if (self.delegate && [self.delegate respondsToSelector:@selector(adView:didTouchInterstitialViewWithUrl:)]) {
        [self.delegate adView:self didTouchInterstitialViewWithUrl:url];
    }
}

@end
