/**
 -  EKHomeItemView.m
 -  EKHKAPP
 -  Created by ligb on 2017/9/13.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明："首页"顶部的横向标签栏
 */

#import "EKHomeItemView.h"

const NSInteger ItemSubViewWidth  = 110;
const float ItemSubViewSpace      = 0.2f;
const float ItemSubViewAngle      = 0.8f;

@interface SubItemView : UIView
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL status;
@end

@implementation SubItemView

- (instancetype)initWithFrame:(CGRect)frame isFirst:(BOOL)isFirst{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.isFirst = isFirst;
    }
    return self;
}

- (void)setStatus:(BOOL)status {
    _status = status;
    if (_status) {
        _bgColor = [UIColor EKColorYellow];
    } else {
        _bgColor = [UIColor EKColorGray];
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 1.0f);
    
    //开始画折现图起始坐标
    CGContextMoveToPoint(contextRef, 0, 0);
    CGContextAddLineToPoint(contextRef, _isFirst ? 0 : self.w * ItemSubViewSpace, self.h * .5);
    CGContextAddLineToPoint(contextRef, 0, self.h);
    CGContextAddLineToPoint(contextRef, self.w * ItemSubViewAngle, self.h);
    CGContextAddLineToPoint(contextRef, self.w, self.h * .5);
    CGContextAddLineToPoint(contextRef, self.w * ItemSubViewAngle, 0);
    CGContextClosePath(contextRef);
    
    if (_status) {
        CGContextSetFillColorWithColor(contextRef, _bgColor.CGColor);
        CGContextFillPath(contextRef);
    } else {
        CGContextSetRGBStrokeColor(contextRef, .72,.72,.72, 1);
        CGContextStrokePath(contextRef);
    }

}

@end




@interface EKHomeItemView ()
@property (nonatomic, strong) UIScrollView *vScrollView;
@property (nonatomic, strong) SubItemView *itemView;
@property (nonatomic, strong) NSMutableArray <SubItemView *> *subItemViewArray;
@end

@implementation EKHomeItemView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)]) {
        _subItemViewArray = [NSMutableArray array];
        [self mInitUI];
    }
    return self;
}


#pragma mark - 实例化UI
- (void)mInitUI {
    self.backgroundColor = [UIColor EKColorGray];
    _vScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _vScrollView.showsVerticalScrollIndicator = NO;
    _vScrollView.showsHorizontalScrollIndicator = NO;
    _vScrollView.scrollEnabled = YES;
    [self addSubview:_vScrollView];
}


- (void)setVTitles:(NSArray<NSString *> *)vTitles {
    _vTitles = vTitles;
    _vScrollView.contentSize = CGSizeMake(ItemSubViewWidth * ItemSubViewAngle * vTitles.count + ItemSubViewWidth * .2, self.h);
    
    [vTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SubItemView *iView = [[SubItemView alloc] initWithFrame:CGRectMake(0, 0, ItemSubViewWidth, self.h) isFirst:!idx];
        //添加到数组中进行管理
        [_subItemViewArray addObject:iView];
        [iView setCenter:CGPointMake(ItemSubViewWidth / 2 + ItemSubViewWidth * idx - ItemSubViewWidth * ItemSubViewSpace * idx, self.h / 2)];
        UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [touchBtn setTitle:obj forState:UIControlStateNormal];
        [touchBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        touchBtn.frame = iView.bounds;
        touchBtn.tag = idx;
        [iView addSubview:touchBtn];
        [_vScrollView addSubview:iView];
        [touchBtn addTarget:self action:@selector(didSelectItemAction:) forControlEvents:UIControlEventTouchUpInside];

    }];
}


#pragma mark - subItemView监听事件
- (void)didSelectItemAction:(UIButton *)sender {
    SubItemView *iView = (SubItemView *)sender.superview;
    if ([iView isEqual:_itemView]) {
        return;
    }
    _itemView.status = NO;
    iView.status = YES;
    _itemView = iView;
    
    //执行代理方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(mHomeItemViewDidClickWithIndex:)]) {
        [self.delegate mHomeItemViewDidClickWithIndex:sender.tag];
    }
}


- (void)setVIndex:(NSInteger)vIndex {
    SubItemView *iView = _subItemViewArray[vIndex];
    if ([iView isEqual:_itemView]) {
        return;
    }
    
    _itemView.status = NO;
    iView.status = YES;
    _itemView = iView;
    
    //如果选中的标签超出了scrollView的宽度,则让scrollView滚动到标签那里让它显示出来
    if (_itemView.maxX > _vScrollView.w) {
        [_vScrollView scrollRectToVisible:_itemView.frame animated:YES];
    }
    
    //执行代理方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(mHomeItemViewDidClickWithIndex:)]) {
        [self.delegate mHomeItemViewDidClickWithIndex:vIndex];
    }
}


@end


