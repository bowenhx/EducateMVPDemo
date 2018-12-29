/**
 - BKLoopImageView.h
 - BKMobile
 - Created by HY on 2017/8/16.
 - Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
 - 说明：自定义view，首页头部的循环播放view
 */

#import <UIKit/UIKit.h>
#import "BKLoopViewModel.h"
@class BKLoopImageView;

//代理，具体方法在下面声明
@protocol BKLoopImageViewDelegate;

@interface BKLoopImageView : UIView  <UIGestureRecognizerDelegate, UIScrollViewDelegate>

//是否自动的循环滚动view
@property BOOL isAutoPlay;

//delegate
@property (nonatomic, assign) id<BKLoopImageViewDelegate> delegate;

//轮播view的数组，数据源
@property (nonatomic , strong) NSArray *itemsArr;


/**
 初始化轮播view

 @param items       轮播view的数据源
 @param delegate    代理
 @return 返回当前loopImageView
 */
- (instancetype)initWithImageItems:(NSArray *)items delegate:(id<BKLoopImageViewDelegate>)delegate;

@end


#pragma mark - BKLoopImageViewDelegate

@protocol BKLoopImageViewDelegate <NSObject>

@optional
/**
 点击一个view触发事件
 
 @param imageView 当前BKLoopImageView
 @param item 点击的BKLoopImageItem
 */
- (void)mTouchLoopImageView:(BKLoopImageView *)imageView didSelectItem:(BKLoopViewModel *)item;

- (void)mFoucusImageView:(BKLoopImageView *)imageView currentItem:(NSInteger)index;

@end
