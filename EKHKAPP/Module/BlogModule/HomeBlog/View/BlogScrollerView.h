/**
 -  BlogScrollerView.h
 -  EKHKAPP
 -  Created by HY on 2017/11/1.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：日志页面滑动列表view
 */

#import <UIKit/UIKit.h>

@interface BlogScrollerView : UIView

//可以通过外面更改scrolview属性
@property (nonatomic , strong) UIScrollView *scrollView;

//记录当前选中的item
@property (nonatomic , assign) NSInteger itemIndex;

//滑动或者是点击事件block
@property (nonatomic , copy) void (^itemsTouchAction)(NSInteger index);

//views 对象及item 对应的名字，即可组装相应的滑动页面
- (void)addItemView:(NSArray *)views title:(NSArray *)titles;

@end
