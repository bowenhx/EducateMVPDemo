//
//  CustomScrollerHeadView.h
//  EKHKAPP
//
//  Created by ligb on 2017/9/27.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomScrollerHeadView;

@protocol CustomScrollerHeadViewDelegate <NSObject>
- (void)didSelectedItemActionView:(CustomScrollerHeadView *)iView itemButton:(UIButton *)btn;
@end

@interface CustomScrollerHeadView : UIView <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, weak) id <CustomScrollerHeadViewDelegate> delegate;


/**
 设置item view 文字

 @param titles 显示title文字
 @param selectBgColor 选中背景
 @param normalTextColor text normal color
 @param selectTextColor text elect color
 @param bottomLineColor 底部线条色，给nil 就不显示
 */
- (void)setItemTitles:(NSArray<NSString *> *)titles selectedBgColor:(UIColor *)selectBgColor normalTextColor:(UIColor *)normalTextColor selectedTextColor:(UIColor *)selectTextColor bottomLineColor:(UIColor *)bottomLineColor;
@end
