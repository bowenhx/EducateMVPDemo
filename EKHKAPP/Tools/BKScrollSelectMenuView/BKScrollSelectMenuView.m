/**
 -  BKScrollSelectMenuView.h
 -  BKHKAPP
 -  Created by calvin_tse on 2017/8/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:可以滑动的菜单视图
 */

#import "BKScrollSelectMenuView.h"

#pragma mark - 属性
@interface BKScrollSelectMenuView ()
#pragma mark - UI视图属性
/**
 主体的scrollView
 */
@property (nonatomic, weak) UIScrollView *scrollView;
/**
 管理按钮的数组
 */
@property (nonatomic, strong) NSMutableArray <UIButton *> *buttonArray;
/**
 管理按钮底部线条的数组
 */
@property (nonatomic, strong) NSMutableArray <UIView *> *bottomLineViewArray;
@end

#pragma mark - 方法
@implementation BKScrollSelectMenuView
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}


/**
 设置UI
 */
- (void)setupUI {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
}


/**
 重写文字数组的setter方法,更新UI

 @param titleArray 文字数组
 */
- (void)setTitleArray:(NSArray<NSString *> *)titleArray {
    _titleArray = titleArray;
    if (!titleArray.count) {
        return;
    }
    //清空数组和UI
    for (UIButton *button in self.buttonArray) {
        [button removeFromSuperview];
    }
    for (UIView *bottomLineView in self.bottomLineViewArray) {
        [bottomLineView removeFromSuperview];
    }
    [self.bottomLineViewArray removeAllObjects];
    [self.buttonArray removeAllObjects];
    
    // 用来记录上一个创建出来的按钮
    UIButton *previousButton = nil;
    // 根据数组的个数,创建对应数量的按钮&按钮之间的分隔线&按钮底部的线条
    for (NSInteger i = 0; i < titleArray.count; i++) {
        // 1.按钮
        UIButton *button = [self setupButtonWithTitle:titleArray[i]
                                             fontSize:14
                                          normalColor:[UIColor EKColorTitleBlack]
                                        selectedColor:[UIColor EKColorNavigation]
                                      backgroundColor:nil];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArray addObject:button];
        [self.scrollView addSubview:button];
        //默认每个按钮都为不选中状态
        button.selected = NO;
        // 设置按钮的约束
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(self.scrollView);
            make.width.equalTo(button.titleLabel);
            if (previousButton) {
                // 如果是在创建第1个按钮以及之后的按钮,则必有上一个按钮,所以左边约束参照上一个按钮
                make.left.equalTo(previousButton.mas_right).offset(30);
            } else {
                // 如果是在创建第0个按钮,则无上一个按钮,所以左边约束参照scrollView
                make.left.equalTo(self.scrollView).offset(20);
            }
        }];
        // 将当前按钮记录为上一个按钮
        previousButton = button;
        
        [self layoutIfNeeded];
        CGFloat lineWidth = button.frame.size.width + 20;
        
        // 2.创建按钮底部的线条
        UIView *bottomLineView = [UIView new];
        [self.bottomLineViewArray addObject:bottomLineView];
        [self.scrollView addSubview:bottomLineView];
        bottomLineView.backgroundColor = [UIColor EKColorNavigation];
        // 设置底部线条的约束
        [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button);
            make.top.equalTo(button.titleLabel.mas_bottom).offset(6);
            make.height.mas_equalTo(1.5);
            make.width.mas_equalTo(lineWidth);
        }];
        //默认每个下划线都隐藏
        bottomLineView.hidden = YES;
    }
    // 在这里布局scrollView,因为scrollView的布局依赖于按钮的布局
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.right.equalTo(previousButton).offset(12);
    }];
}


/**
 按钮监听事件

 @param sender 当前点击的按钮
 */
- (void)buttonClick:(UIButton *)sender {
    //取消全部按钮的选中状态&隐藏全部底部线条
    for (UIButton *button in self.buttonArray) {
        button.selected = NO;
    }
    for (UIView *bottomLineView in self.bottomLineViewArray) {
        bottomLineView.hidden = YES;
    }
    
    //打开当前选中的按钮的选中状态&显示底部线条
    sender.selected = YES;
    NSInteger currentIndex = [self.buttonArray indexOfObject:sender];
    self.bottomLineViewArray[currentIndex].hidden = NO;
    // 执行代理方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(mScrollSelectMenuViewDidSelectWithIndex:)]) {
        [self.delegate mScrollSelectMenuViewDidSelectWithIndex:currentIndex];
    }
}


- (void)setVSelectedIndex:(NSInteger)vSelectedIndex {
    _vSelectedIndex = vSelectedIndex;
    
    //取消全部按钮的选中状态&隐藏全部底部线条
    for (UIButton *button in self.buttonArray) {
        button.selected = NO;
    }
    for (UIView *bottomLineView in self.bottomLineViewArray) {
        bottomLineView.hidden = YES;
    }
    
    //打开当前选中的按钮的选中状态&显示底部线条
    self.buttonArray[vSelectedIndex].selected = YES;
    self.bottomLineViewArray[vSelectedIndex].hidden = NO;
}


#pragma mark - 私有的便利方法
/**
 根据参数,快速创建按钮
 
 @param title 按钮文字内容
 @param fontSize 按钮文字大小
 @param normalColor 普通状态下的文字颜色
 @param selectedColor 选中状态下的文字颜色
 @param backgroundColor 背景颜色
 @return 指定按钮
 */
- (UIButton *)setupButtonWithTitle:(NSString *)title
                          fontSize:(CGFloat)fontSize
                       normalColor:(UIColor *)normalColor
                     selectedColor:(UIColor *)selectedColor
                   backgroundColor:(UIColor *)backgroundColor {
    UIButton *button = [UIButton new];
    [button setTitle:title forState:UIControlStateNormal];// 设置文字内容
    [button.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];// 设置字体大小
    [button setTitleColor:normalColor forState:UIControlStateNormal];// 设置普通状态下的文字颜色
    [button setTitleColor:selectedColor forState:UIControlStateSelected];// 设置选中状态下的文字颜色
    [button setBackgroundColor:backgroundColor];// 设置背景颜色
    
    return button;
}


#pragma mark - 懒加载
// 懒加载 管理按钮的数组
- (NSMutableArray<UIButton *> *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}


// 懒加载 管理按钮底部线条的数组
- (NSMutableArray<UIView *> *)bottomLineViewArray {
    if (!_bottomLineViewArray) {
        _bottomLineViewArray = [NSMutableArray array];
    }
    return _bottomLineViewArray;
}


@end
