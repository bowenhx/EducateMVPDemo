//
//  BaseItemView.m
//  EduKingdom
//
//  Created by ligb on 16/7/5.
//  Copyright © 2016年 com.mobile-kingdom.ekapps. All rights reserved.
//
#define ITEM_COLOR  @"#35bd6c"  //item select color

#define ITEM_BY  8
#define ITEM_BW  100    //item  button width
#define ITEM_BH  30     //item  button height
#define HEAD_H   55     // head View height
#define LINE_H   15     // head View line height


#import "CustomItemView.h"
#import "EKCornerSelectMenuView.h"


@interface CustomItemView () <UIScrollViewDelegate, EKCornerSelectMenuViewDelegate> {
    EKCornerSelectMenuView *_headView;
}
@end

@implementation CustomItemView

- (void)addItemView:(NSArray *)views title:(NSArray *)titles height:(float)height{
    
    _headView = [[EKCornerSelectMenuView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 285) / 2, 30, 285, 30)
                                                   titleArray:titles
                                                     delegate:self
                                                         type:EKCornerSelectMenuViewTypeNormal selectedIndex:0];
    [self addSubview:_headView];

    
    //设置contentSize
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * views.count, _scrollView.h);
    
    for (int i= 0; i< views.count; i++) {
        UIView *iView = views[i];
        [_scrollView addSubview:iView];
        [iView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_scrollView).offset(i * SCREEN_WIDTH);
            make.top.width.height.equalTo(_scrollView);
        }];
    }
}


#pragma mark - EKCornerSelectMenuViewDelegate
//自定义头部视图的代理方法,点击时调用
- (void)mEKCornerSelectMenuView:(EKCornerSelectMenuView *)selectMenuView didClickWithIndex:(NSInteger)index {
    [self endEditing:YES];
    self.itemIndex = index;
        [self.scrollView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:YES];
    if (self.itemsEcentAction) {
        self.itemsEcentAction (index);
    }
}


#pragma mark ScrollViewDelegate
//scrollView滚动结束时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 得到每页宽度
    CGFloat pageWidth = SCREEN_WIDTH;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    //滑动判断如果滑动的page 没有变化就不去改变页面
    if (self.itemIndex == currentPage) {
        return;
    }
    self.itemIndex = currentPage;
    _headView.vSelectedIndex = currentPage;
}


//scrollView滚动即将开始时调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self endEditing:YES];
}


#pragma mark - 懒加载
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor EKColorBackground];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        //设置scrollView的布局约束
        CGFloat scrollViewTopMargin = 29;
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(_headView.mas_bottom).offset(scrollViewTopMargin);
        }];
    }
    return _scrollView;
}

@end



