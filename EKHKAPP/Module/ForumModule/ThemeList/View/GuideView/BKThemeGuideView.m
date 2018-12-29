/**
 -  BKThemeGuideView.m
 -  BKHKAPP
 -  Created by HY on 2017/8/25.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BKThemeGuideView.h"

@interface BKThemeGuideView() {
    NSInteger   _index;
    UIImageView *_imageView;
}

@end

@implementation BKThemeGuideView

//初始化
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//懒加载
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _imageView;
}

//赋值
- (void)setVGuideType:(ThemeGuideImageType)vGuideType{
    _index = 0;
    _vGuideType = vGuideType;
    if (_vGuideType == ThemeGuideImageType_ThemeList) {
        [self.imageView setImage:[UIImage imageNamed:IPHONE5 ? @"vi_zy_bk_5" : @"vi_zy_bk"]];
    } else {
        if (IPHONEX) {
            [self.imageView setImage:[UIImage imageNamed:@"guide_x"]];
        } else {
            [self.imageView setImage:[UIImage imageNamed:IPHONE5 ? @"guide_i5" : @"guide"]];
        }
        
    }
    [self addSubview:_imageView];
}

//点击view
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _index ++;
    if (_vGuideType == ThemeGuideImageType_ThemeList) {
        [self removeFromSuperview];
        return;
    }
    
    switch (_index) {
        case 1: {
            [_imageView setImage:[UIImage imageNamed:IPHONE5 ? @"vi_tz_fx_5" : @"vi_tz_fx"]];
            break;
        }
        case 2: {
            [_imageView setImage:[UIImage imageNamed:IPHONE5 ? @"vi_tz_yc_5" : @"vi_tz_yc"]];
            break;
        }
        default:{
            [self removeFromSuperview];
            break;
        }
    }
}

@end
