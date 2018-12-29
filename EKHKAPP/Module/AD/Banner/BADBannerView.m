/**
 - BADBannerView.m
 - BADSdk
 - Created by HY on 2017/12/13.
 - Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BADBannerView.h"

@interface BADBannerView () <BADBaseViewDelegate>

@property (nonatomic, strong) BADModel *vAdModel;

@end;

@implementation BADBannerView

- (void)dealloc {
    NSLog(@"%s",__func__);
}

#pragma mark - init
- (instancetype)initWithAdSize:(BADAdSize)adSize {
    self = [super init];
    if (self) {
        self.adSize = adSize;
    }
    return self;
}

#pragma mark - Making an Ad Request
- (void)loadRequest:(BADRequest *)request {
    //参数设置
    [self mSettingParameter:request];

    //网络请求
    [request mADRequesWithUnitId:self.adUnitID finishAction:^(BADModel *adModel, NSString *netErr) {
        if (adModel) {
            //请求成功
            [self mRequestSuccessWithModel:adModel];
        } else {
            //请求失败
            if (self.delegate && [self.delegate respondsToSelector:@selector(adView:didFailToReceiveAdWithError:)]) {
                [self.delegate adView:self didFailToReceiveAdWithError:netErr];
            }
        }
    }];
}

#pragma mark - banner请求成功后
- (void)mRequestSuccessWithModel:(BADModel *)model {
    BannerView *vBannerView = [[BannerView alloc] init];
    [vBannerView mSettingViewWithModel:model.ad_detail];
    vBannerView.baseDelegate = self;
    [self addSubview:vBannerView];
    self.vBannerHeight = vBannerView.infoModel.height;
    
    //回调请求到的bannerView
    if (self.delegate && [self.delegate respondsToSelector:@selector(adViewDidReceiveAd:)]) {
        [self.delegate adViewDidReceiveAd:self];
    }
}

#pragma mark - BADBaseViewDelegate 点击广告view触发的事件
- (void)mTouchAdViewWithUrl:(NSString *)url {
    NSLog(@"== %s",__func__);
    //回调点击事件
    if (self.delegate && [self.delegate respondsToSelector:@selector(adView:didTouchBannerViewWithUrl:)]) {
        [self.delegate adView:self didTouchBannerViewWithUrl:url];
    }
}

#pragma mark - 其他逻辑处理
//参数设置
- (void)mSettingParameter:(BADRequest *)request {
    request.vDisplayType = const_BAD_DisplayType_Banner;
    
    //banner的size赋值
    NSString *tempSize =  [self mFormatStringWithEnum:self.adSize];
    request.vBannerSize = tempSize;
    
    if (self.adSize == BADADSIZE_CUSTOM) {
        request.vAdWidth = self.adWidth;
        request.vAdHeight = self.adHeight;
    }
}

//枚举转换为字符串
- (NSString *)mFormatStringWithEnum:(BADAdSize)status {
    NSArray *typeArray = @[@"Standard",
                           @"Large",
                           @"Leaderboard",
                           @"MediumRectangle",
                           @"SmartBanner",
                           @"Custom"];
    NSString *sizeType = typeArray[status];
    return sizeType;
}

@end









