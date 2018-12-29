/**
 -  EKColumnView.h
 -  EKHKAPP
 -  Created by ligb on 2017/9/8.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明： 侧滑view
 */

#import <UIKit/UIKit.h>

@interface EKColumnView : UIView

/**
 展示侧滑view

 @param isAnimation 布尔类型，yes代表展开含动画，no代表不含动画
 */
+ (void)animateColumnViewAction:(BOOL)isAnimation;


/**
 隐藏view
 */
+ (void)hiddenColumnViewAction;


//更新数据
+ (void)mReloadData;

@end


