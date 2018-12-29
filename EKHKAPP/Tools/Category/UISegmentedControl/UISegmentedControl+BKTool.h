/**
 -  UISegmentedControl.h
 -  BKHKAPP
 -  Created by HY on 2017/8/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：快捷创建导航栏上面的UISegmentedControl
 */

#import <UIKit/UIKit.h>

@interface UISegmentedControl (BKTool)

/**
 快捷创建一个UISegmentedControl

 @param size   SegmentedControl的大小
 @param items  SegmentedControl上面的items的title名字
 @param target 指定目标，执行action
 @param action 点击Segmented上面的item所触发的事件
 @return 返回一个UISegmentedControl
 */
- (UISegmentedControl *)initWithSize:(CGSize)size items:(NSArray *)items addTarget:(id)target action:(SEL)action;

@end
