//
//  BADPopupPlay.m
//  BADSdk
//
//  Created by ligb on 2017/12/29.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import "BADPopup.h"
#import "BADConfig.h"
#import "BADPopupWindow.h"

@interface BADPopup () <BADBaseViewDelegate>
@property (nonatomic, strong) BADPopupWindow *popupWindow;

@property (nonatomic, copy) NSString *adID;

@end

@implementation BADPopup
- (void)dealloc {
    _popupWindow.hidden = YES;
    [_popupWindow removeFromSuperview];
    _popupWindow = nil;
    NSLog(@"%s",__func__);
}
- (instancetype)initWithAdUnitID:(NSString *)adUnitID {
    if (self = [super init]) {
        self.adID = adUnitID;
    }
    return self;
}

- (NSString *)adUnitID {
    return _adID;
}

- (void)loadRequest:(BADRequest *)request {
    request.vDisplayType = const_BAD_DisplayType_Popup;
    [request mADRequesWithUnitId:self.adUnitID finishAction:^(BADModel *adModel, NSString *netErr) {
        if (adModel) {
            //如果外部有传递过来距离屏幕下方的高度，则需要记录
            if (self.vBottomHeight) {
                adModel.vPopupBottomHeight = self.vBottomHeight;
                adModel.ad_detail.vPopupBottomHeight = self.vBottomHeight;;
            }
            [self mSettingPopWithModel:adModel];
        }
    }];
}

- (void)mSettingPopWithModel:(BADModel *)model {
    _popupWindow = [[BADPopupWindow alloc] initWithModel:model];
    _popupWindow.vBigPopView.baseDelegate = self;
}


#pragma mark - BADBaseViewDelegate 点击广告view触发的事件
- (void)mTouchAdViewWithUrl:(NSString *)url {
    NSLog(@"== %s",__func__);
    //回调点击事件
    if (self.delegate && [self.delegate respondsToSelector:@selector(adView:didTouchPopupViewWithUrl:)]) {
        [self.delegate adView:self didTouchPopupViewWithUrl:url];
    }
}
@end
