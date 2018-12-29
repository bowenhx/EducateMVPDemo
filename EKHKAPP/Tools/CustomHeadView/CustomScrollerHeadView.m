//
//  CustomScrollerHeadView.m
//  EKHKAPP
//
//  Created by ligb on 2017/9/27.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import "CustomScrollerHeadView.h"
const float BtnSapce = 10;

@interface CustomScrollerHeadView ()
@property (nonatomic, strong) UIColor *normalBgColor;
@property (nonatomic, strong) UIColor *selectBgColor;
@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, strong) UIColor *selectTextColor;
@property (nonatomic, strong) UIColor *bottomLineColor;

@property (nonatomic, strong) CALayer *lineLayer;
@property (nonatomic, strong) UIButton *tempButton;
@end


@implementation CustomScrollerHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setItemTitles:(NSArray<NSString *> *)titles selectedBgColor:(UIColor *)selectBgColor normalTextColor:(UIColor *)normalTextColor selectedTextColor:(UIColor *)selectTextColor bottomLineColor:(UIColor *)bottomLineColor {
    _selectBgColor = selectBgColor;
    _normalTextColor = normalTextColor;
    _selectTextColor = selectTextColor;
    _bottomLineColor = bottomLineColor;
    
    if (_scrollView.subviews.count) {
        [_scrollView removeFromSuperview];
    }
    
    self.titles = titles;
}


- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.h)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = NO;
        _scrollView.scrollEnabled = YES;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    CGFloat maxW = 0;
    for (int i=0; i< titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
        CGFloat maxWidth = [titles[i] boundingRectWithSize:CGSizeMake(500, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width+20;
        button.frame = CGRectMake(BtnSapce + maxW, 0, maxWidth, 30);
        [button setCenterY:self.scrollView.centerY];
        
        if (_selectBgColor) [button setBackgroundImage:[UIImage imageWithColor:_selectBgColor] forState:UIControlStateSelected];
        if (_normalTextColor) [button setTitleColor:_normalTextColor forState:UIControlStateNormal];
        if (_selectTextColor) [button setTitleColor:_selectTextColor forState:UIControlStateSelected];
        
        [self.scrollView addSubview:button];
        maxW = button.maxX;
        [button addTarget:self action:@selector(didSelectImtemAction:) forControlEvents:UIControlEventTouchUpInside];
       
        if (i == 0) {
            _tempButton = button;
            if (_selectTextColor || _selectBgColor)   button.selected = true;
            
            if (_bottomLineColor) {
                _lineLayer = [[CALayer alloc] init];
                _lineLayer.backgroundColor = _bottomLineColor.CGColor;
                [self updataLineFrame:button];
                [self.scrollView.layer addSublayer:_lineLayer];
            }
        }
        
    }
    
    self.scrollView.contentSize = CGSizeMake(maxW + BtnSapce, _scrollView.h);
}

- (void)updataLineFrame:(UIButton *)sender {
    CGRect rect = CGRectOffset(sender.frame, 0, _selectBgColor ? sender.h+4 : sender.h);
    rect.size.height = 1;
    _lineLayer.frame = rect;
    [UIView animateWithDuration:0.3f animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)didSelectImtemAction:(UIButton *)sender {
    if ([_tempButton isEqual:sender])  return;
    _tempButton.selected = false;
    sender.selected = true;
    if (_bottomLineColor) [self updataLineFrame:sender];
    _tempButton = sender;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedItemActionView:itemButton:)]) {
        [_delegate didSelectedItemActionView:self itemButton:sender];
    }
}
@end
