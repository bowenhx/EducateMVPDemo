/**
 -  EKHomeItemView.h
 -  EKHKAPP
 -  Created by ligb on 2017/9/13.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明："首页"顶部的横向标签栏
 */

#import <UIKit/UIKit.h>

@protocol EKHomeItemViewDelegate;

@interface EKHomeItemView : UIView
@property (nonatomic, strong) NSArray <NSString *> *vTitles;
@property (nonatomic, weak) id <EKHomeItemViewDelegate> delegate;
//设置当前选中的下标
@property (nonatomic, assign) NSInteger vIndex;
@end

@protocol EKHomeItemViewDelegate <NSObject>
/**
 标签点击时调用

 @param index 回传当前点击的按钮下标
 */
- (void)mHomeItemViewDidClickWithIndex:(NSInteger)index;
@end
