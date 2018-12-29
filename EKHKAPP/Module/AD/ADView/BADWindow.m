/**
 -  BADWindow.m
 -  ADSDK
 -  Created by HY on 17/2/23.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BADWindow.h"
#import "BADRequest.h"
#import "BADConfig.h"

@interface BADWindow () {
    int _vTag; //定义关闭按钮的tag值
    CGFloat _vPopupPointY; //popupview的y坐标
    int _mInterstitialTag; //每一次生成新的全屏广告后，随机赋值一个tag，用来标示延迟关闭时间到时候用不用关闭当前全屏广告
}
@end

@implementation BADWindow

#pragma mark - dealloc
- (void)dealloc {
    _vSmallPopView = nil;
    _vBigPopView = nil;
    _vFullView = nil;
    NSLog(@"%s",__func__);
}

#pragma mark - 设置广告view显示逻辑
- (void)mSettingAdView {
    _vTag = 10; //给tag设定初始值
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor redColor].CGColor;
    if ([self.bkAdModel.display_type isEqualToString:const_BAD_DisplayType_Popup]) {
        [self mInstancePopupAd];
    } else if ([self.bkAdModel.display_type isEqualToString:const_BAD_DisplayType_Fullscreen]) {
        [self mInstanceFullScreenAd];
    }
}

#pragma mark - 生成弹窗广告
- (void)mInstancePopupAd {
    /** 生成pop广告
     【bannerinfo_pop】用来放大尺寸的广告， 【bannerinfo】用来放小尺寸的广告；
     【bannerinfo_pop】用【animation】的动画显示完成后，停留时间【expirytime】；
     【expirytime】停留时间结束后，广告内容缩小到 【bannerinfo】广告尺寸，显示对应的广告内容；
     */
    
    //放大尺寸的pop广告模型
    BADDetailModel *bigInfoModel = self.bkAdModel.bannerinfo_pop;
    
    CGFloat pointY = SCREEN_HEIGHT - bigInfoModel.height - self.bkAdModel.vPopupBottomHeight;
    _vPopupPointY = pointY;
    self.frame = CGRectMake(0, pointY, SCREEN_WIDTH, bigInfoModel.height);
    
    //创建大弹窗广告
    __weak __typeof(self) weakSelf = self;
    _vBigPopView =  [[PopupView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - bigInfoModel.width)/2, 0, bigInfoModel.width, bigInfoModel.height)];
    _vBigPopView.showADViewAnimate = ^(BOOL show) {
        [weakSelf mShowAnamition:show];
    };
    _vBigPopView.bkAdModel = self.bkAdModel;
    [_vBigPopView mSettingViewWithModel:bigInfoModel];
    [self addSubview:_vBigPopView];
    [self mInitCloseBtn:bigInfoModel.cbposition cbdelay:bigInfoModel.cbdelay]; //添加一个关闭按钮
    
    //创建小尺寸广告
    BADDetailModel *smallModel = self.bkAdModel.ad_detail;
    if ([smallModel.content isKindOfClass:[NSString class]]) {
        _vSmallPopView = [[PopupView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - smallModel.width)/2, 0, smallModel.width, smallModel.height)];
        _vSmallPopView.bkAdModel = self.bkAdModel;
        _vSmallPopView.showADViewAnimate = ^(BOOL show) {
            //大尺寸的广告显示以后，经过expirytime秒，显示缩小尺寸的pop广告
            if (bigInfoModel.expirytime > 0) {
                [weakSelf performSelector:@selector(mShowLittlePopupView) withObject:weakSelf afterDelay:bigInfoModel.expirytime];
            }
        };
        [_vSmallPopView mSettingViewWithModel:smallModel];
    }
}

#pragma mark - 生成全屏广告
- (void)mInstanceFullScreenAd {
    //规定全屏广告window层级位于pop window上面
    self.windowLevel = UIWindowLevelStatusBar;
    
    _mInterstitialTag = arc4random() % 10000;
    
    //** 生成全屏广告 */
    BADDetailModel *infoModel = self.bkAdModel.ad_detail;
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    //创建全屏广告
    __weak typeof(self) weakSelf = self;
    _vFullView = [[InterstitialView alloc] init];
    _vFullView.showADViewAnimate = ^(BOOL show) {
        [weakSelf mShowAnamition:show];
    };
    
    _vFullView.hidden = YES;
    self.hidden = YES;
    _vFullView.bkAdModel = self.bkAdModel;
    [_vFullView mSettingViewWithModel:infoModel];
    _vFullView.center = self.center; //居中放到window中
    [self addSubview:_vFullView];
    [self mInitCloseBtn:infoModel.cbposition cbdelay:infoModel.cbdelay]; //添加一个关闭按钮
    
    //全屏广告自动隐藏逻辑,经过expirytime后自动隐藏广告
    if (infoModel.expirytime > 0) {
        [self performSelector:@selector(mHiddenInterstitialAdView:) withObject:@(_mInterstitialTag) afterDelay:infoModel.expirytime];
    }
    
}

#pragma mark - 广告view的显示动画
- (void)mShowAnamition:(BOOL)show {
    
    CGRect selfFrame = self.frame;
        
    //广告动画显示 [0:沒有 1:溶入 2:由左入 3:由右入 4:向上入 5:向下入]
    NSInteger BKADAnimationType = self.bkAdModel.animation;
    
    BKADAnimationType = 1;
        
    switch (BKADAnimationType) {
        case ADAnimationType_None:
        {
            if (show) {
                self.hidden = NO; //window显示
                _vFullView.hidden = NO;
            } else {
                self.hidden = YES;
                [self removeAdWindowView];
            }
        }
            break;
        case ADAnimationType_Into: //溶解进入
        {
            if (show) {
                self.alpha = 0;
                [UIView transitionWithView:self duration:self.bkAdModel.action_duration options:UIViewAnimationOptionTransitionCrossDissolve animations:^ {
                    self.alpha = 1.0;
                    self.hidden = NO; //window显示
                    _vFullView.hidden = NO;
                } completion:nil];
            } else {
                [UIView animateWithDuration:self.bkAdModel.action_duration animations:^{
                    self.alpha = 0;
                } completion:^(BOOL finished) {
                    [self removeAdWindowView];
                }];
            }
        }
            break;
        case ADAnimationType_FromLeft: //从左进入
        {
            selfFrame.origin.x = - SCREEN_WIDTH;
            [self addAnimation:UIViewAnimationOptionTransitionFlipFromLeft frame:selfFrame show:show];
        }
            break;
        case ADAnimationType_FromRight: //从右进入
        {
            selfFrame.origin.x = SCREEN_WIDTH;
            [self addAnimation:UIViewAnimationOptionTransitionFlipFromRight frame:selfFrame show:show];
        }
            break;
        case ADAnimationType_FromTop: //从上进入
        {
            selfFrame.origin.y = - SCREEN_HEIGHT;
            [self addAnimation:UIViewAnimationOptionTransitionFlipFromTop frame:selfFrame show:show];
        }
            break;
        case ADAnimationType_FromDown: //从下进入
        {
            selfFrame.origin.y = SCREEN_HEIGHT;
            [self addAnimation:UIViewAnimationOptionTransitionFlipFromBottom frame:selfFrame show:show];
        }
            break;
        default:
            break;
    }

}


#pragma mark - 添加关闭按钮
- (void)mInitCloseBtn:(NSInteger)cbposition cbdelay:(NSInteger)cbdelay {
    /*
     关闭按钮的位置：[-0=不显示关闭按钮；1=左上角；2=右上角；3=左下角；4=右下角]（displaytype=popup、fullscreen两种类型的时候才有关闭按钮）
     */
    //关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.tag = _vTag;
    [closeBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [closeBtn setImage:[UIImage imageNamed:@"bkad_close_btn"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(mHiddenAdView) forControlEvents:UIControlEventTouchUpInside];
    
    closeBtn.hidden = YES;
    //定义关闭按钮的左右边距
    NSInteger edge;
    if ([self.bkAdModel.display_type isEqualToString:const_BAD_DisplayType_Popup]) {
        edge = 0;
    } else {
        if (IPHONEX) {
            edge = 30;
        } else {
            edge = 10;
        }
    }

    NSInteger BKADCloseBtnDisplayType = cbposition;
    
    switch (BKADCloseBtnDisplayType) {
        case ADCloseBtnDisplayType_None:
        {
            [closeBtn setFrame:CGRectMake(edge, edge, 0, 0)];//不显示
        }
            break;
        case ADCloseBtnDisplayType_leftTop:
        {
            [closeBtn setFrame:CGRectMake(edge, edge, DEF_BKAD_CLOSEBTN_W_H, DEF_BKAD_CLOSEBTN_W_H)];
        }
            break;
        case ADCloseBtnDisplayType_rightTop:
        {
            [closeBtn setFrame:CGRectMake(self.bounds.size.width - DEF_BKAD_CLOSEBTN_W_H - edge, edge, DEF_BKAD_CLOSEBTN_W_H, DEF_BKAD_CLOSEBTN_W_H)];
        }
            break;
        case ADCloseBtnDisplayType_leftDown:
        {
            [closeBtn setFrame:CGRectMake(edge, self.bounds.size.height - DEF_BKAD_CLOSEBTN_W_H - edge, DEF_BKAD_CLOSEBTN_W_H, DEF_BKAD_CLOSEBTN_W_H)];
        }
            break;
        case ADCloseBtnDisplayType_rightDown:
        {
            [closeBtn setFrame:CGRectMake(self.bounds.size.width - DEF_BKAD_CLOSEBTN_W_H - edge, self.bounds.size.height - DEF_BKAD_CLOSEBTN_W_H - edge, DEF_BKAD_CLOSEBTN_W_H, DEF_BKAD_CLOSEBTN_W_H)];
        }
            break;
        default:
            break;
    }
    
    [self addSubview:closeBtn];
    //关闭按钮显示的判断，根据cbdelay字段的时间
    [self performSelector:@selector(mShowCloseBtn:) withObject:closeBtn afterDelay:cbdelay];
}

#pragma mark -remo广告view
- (void)removeAdWindowView {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRemoveADWindowActionKey object:self];
}

#pragma mark -延迟显示关闭按钮
- (void)mShowCloseBtn:(UIButton *)sender {
    sender.hidden = NO;
}

#pragma mark - 隐藏广告
- (void)mHiddenAdView {
    [self mShowAnamition:NO];
}

#pragma mark - 隐藏广告
- (void)mHiddenInterstitialAdView:(id)sender {
    int temp = [sender intValue];
    if (_mInterstitialTag == temp) {
        [self mShowAnamition:NO];
    }
}

#pragma mark - 添加动画
- (void)addAnimation:(UIViewAnimationOptions)option frame:(CGRect)frame show:(BOOL)show {
    if (show) {
        self.frame = frame;
        CGRect rect = self.bounds;

        if (self.frame.size.height < self.frame.size.width) {
            //这里控制pop view 广告动画停留在底部，不控制就会停留在顶部
            rect.origin.y = _vPopupPointY;
        }
        
        _vFullView.hidden = NO;
        self.hidden = NO;
        [UIView animateWithDuration:self.bkAdModel.action_duration delay:0 options:option animations:^{
            self.frame = rect;
        } completion:nil];
    } else {
        [UIView animateWithDuration:self.bkAdModel.action_duration delay:0 options:option animations:^{
            [self setFrame:frame];
        } completion:^(BOOL finished) {
            [self removeAdWindowView];
        }];
    }
    
}


#pragma mark - 显示小尺寸的pop广告
- (void)mShowLittlePopupView {
    _vBigPopView.hidden = YES;
    [_vBigPopView removeFromSuperview];
    [self removeFromSuperview];
    
    if (_vSmallPopView) {
        //显示缩小尺寸的pop广告
        BADDetailModel *infoModel = self.bkAdModel.ad_detail;
        [self addSubview:_vSmallPopView];
        [self mInitCloseBtn:infoModel.cbposition cbdelay:0]; //添加一个关闭按钮
        
        //动画，尺寸缩小
        CGRect rect = self.vSmallPopView.bounds;
        rect.origin.y = SCREEN_HEIGHT - rect.size.height - infoModel.vPopupBottomHeight;
        [UIView animateWithDuration:self.bkAdModel.action_duration animations:^{
            self.frame = rect;
        }];
        
        //这里加一个判断，如果小尺寸广告的参数expirytime>0,经过expirytime后自动隐藏广告
        if (infoModel.expirytime > 0) {
            [self performSelector:@selector(mHiddenAdView) withObject:nil afterDelay:infoModel.expirytime];
        }
    }
    
}

@end




