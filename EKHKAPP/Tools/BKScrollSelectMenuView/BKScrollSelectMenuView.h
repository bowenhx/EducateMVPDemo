/**
 -  BKScrollSelectMenuView.h
 -  BKHKAPP
 -  Created by calvin_tse on 2017/8/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:可以滑动的菜单视图
 */

#import <UIKit/UIKit.h>

@protocol BKScrollSelectMenuViewDelegate;


@interface BKScrollSelectMenuView : UIView

//文字数组
@property (nonatomic, strong) NSArray <NSString *> *titleArray;

//代理对象
@property (nonatomic, weak) id <BKScrollSelectMenuViewDelegate> delegate;

//当前选中的按钮的下标
@property (nonatomic, assign) NSInteger vSelectedIndex;

@end


@protocol BKScrollSelectMenuViewDelegate <NSObject>

/**
 回传当前点击的按钮的下标

 @param index 点击的按钮的下标
 */
- (void)mScrollSelectMenuViewDidSelectWithIndex:(NSInteger)index;
@end
