/**
 -  EKCornerSelectMenuView.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/21.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:项目中通用的圆弧形菜单选择视图
 -  只能使用纯代码创建
 -  只能通过frame来设置布局,自动布局不可以
 */

#import "EKCornerSelectMenuView.h"
#import "EKCornerSelectMenuButton.h"

@interface EKCornerSelectMenuView ()
//记录外部传入的文字数组
@property (nonatomic, strong) NSArray <NSString *> *vTitleArray;
//记录外部传入的代理对象
@property (nonatomic, weak) id <EKCornerSelectMenuViewDelegate> vDelegate;
//记录外部传入的类型
@property (nonatomic, assign) EKCornerSelectMenuViewType vType;

//管理几个按钮的数组
@property (nonatomic, strong) NSMutableArray <EKCornerSelectMenuButton *> *vButtonArray;
//管理几个小红点label的数组
@property (nonatomic, strong) NSMutableArray <UILabel *> *vLabelArray;
//圆角背景视图
@property (nonatomic, strong) UIView *vBackgroundView;
//记录当前选中的按钮
@property (nonatomic, strong) UIButton *vCurrentButton;
//存放圆角背景视图&按钮的视图.之所以要这个视图,是因为不这么做的话,未读小红点会被border遮挡.border的设置放在这个视图里面进行
@property (nonatomic, strong) UIView *vContentView;


#pragma mark - 属性 - 颜色
//整个控件的底色
@property (nonatomic, strong) UIColor *vBackgroundColor;
//边框的颜色
@property (nonatomic, strong) UIColor *vBorderColor;
//选中的按钮的背景颜色,即圆角背景视图的颜色
@property (nonatomic, strong) UIColor *vSelectButtonBackgroundColor;
//选中的按钮的文字颜色
@property (nonatomic, strong) UIColor *vSelectedTitleColor;
//未选中的按钮的文字颜色
@property (nonatomic, strong) UIColor *vNormalTitleColor;
@end


@implementation EKCornerSelectMenuView

/**
 自定义构造方法
 
 @param frame 尺寸
 @param titleArray 文字数组
 @param delegate 代理对象
 @param type 类型
 @param selectedIndex 当前选中的下标
 @return 创建好的圆弧形菜单选择视图
 */
- (instancetype)initWithFrame:(CGRect)frame
                   titleArray:(NSArray <NSString *>*)titleArray
                     delegate:(id <EKCornerSelectMenuViewDelegate>)delegate
                         type:(EKCornerSelectMenuViewType)type
                selectedIndex:(NSInteger)selectedIndex {
    if (self = [super initWithFrame:frame]) {
        //实例化按钮数组
        _vButtonArray = [NSMutableArray array];
        //实例化label数组
        _vLabelArray = [NSMutableArray array];
        //私有属性记录外部传入的参数
        _vDelegate = delegate;
        _vTitleArray = titleArray;
        _vType = type;
        //根据type,准备一些颜色参数
        [self mInitColors];
        //实例化UI
        [self mInitButtonAndLabel];
        //这一行一定要在按钮生成完之后再执行
        self.vSelectedIndex = selectedIndex;
        
    }
    return self;
}


//根据type,准备一些颜色参数
- (void)mInitColors {
    //普通类型的颜色值
    if (_vType == EKCornerSelectMenuViewTypeNormal) {
        _vBackgroundColor = @"FFFFFF".color;
        _vBorderColor = @"109B8F".color;
        _vSelectButtonBackgroundColor = @"109B8F".color;
        _vSelectedTitleColor = @"FFFFFF".color;
        _vNormalTitleColor = @"336A68".color;
    } else {
        _vBackgroundColor = @"109A8E".color;
        _vBorderColor = @"FFFFFF".color;
        _vSelectButtonBackgroundColor = @"FFFFFF".color;
        _vSelectedTitleColor = @"109A8E".color;
        _vNormalTitleColor = @"FFFFFF".color;
    }
}



//创建按钮和小红点label
- (void)mInitButtonAndLabel {
    _vContentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_vContentView];
    _vContentView.backgroundColor = _vBackgroundColor;
    _vContentView.layer.cornerRadius = self.h / 2;
    _vContentView.layer.masksToBounds = YES;
    _vContentView.layer.borderColor = _vBorderColor.CGColor;
    _vContentView.layer.borderWidth = 1;
    
    //1.创建按钮和小红点按钮
    for (NSInteger i = 0; i < _vTitleArray.count; i++) {
        EKCornerSelectMenuButton *button = [[EKCornerSelectMenuButton alloc] init];
        [_vButtonArray addObject:button];
        [_vContentView addSubview:button];
        [button addTarget:self action:@selector(mClickButton:) forControlEvents:UIControlEventTouchUpInside];
        if (_vTitleArray[i]) {
            //设置普通状态的效果
            NSDictionary *normalAttributes = @{NSKernAttributeName : @(1.5) ,
                                               NSForegroundColorAttributeName : _vNormalTitleColor};
            NSAttributedString *normalString = [[NSAttributedString alloc] initWithString:_vTitleArray[i]
                                                                               attributes:normalAttributes];
            [button setAttributedTitle:normalString forState:UIControlStateNormal];
            
            //设置选中时的效果
            NSDictionary *selectedAttributes = @{NSKernAttributeName : @(1.5) ,
                                                 NSForegroundColorAttributeName : _vSelectedTitleColor};
            NSAttributedString *selectedString = [[NSAttributedString alloc] initWithString:_vTitleArray[i]
                                                                                 attributes:selectedAttributes];
            [button setAttributedTitle:selectedString forState:UIControlStateSelected];
        }
        CGFloat buttoWidth = self.w / _vTitleArray.count;
        button.frame = CGRectMake(i * buttoWidth, 0, buttoWidth, self.h);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(button.maxX - 15, -10, 20, 20)];
        label.layer.cornerRadius = label.h / 2;
        label.layer.masksToBounds = YES;
        [self addSubview:label];
        [_vLabelArray addObject:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor EKColorTitleWhite];
        label.backgroundColor = [UIColor redColor];
        label.hidden = YES;
    }
    
    //2.实例化圆角背景视图
    _vBackgroundView = [[UIView alloc] init];
    [_vContentView insertSubview:_vBackgroundView atIndex:0];
    _vBackgroundView.backgroundColor = _vSelectButtonBackgroundColor;
    _vBackgroundView.frame = _vButtonArray.firstObject.frame;
    _vBackgroundView.layer.cornerRadius = _vBackgroundView.h / 2;
    _vBackgroundView.layer.masksToBounds = YES;
}


//按钮监听事件
- (void)mClickButton:(EKCornerSelectMenuButton *)button {
    if ([button isEqual:_vCurrentButton]) {
        return;
    }
    //更改按钮UI
    _vCurrentButton.selected = NO;
    button.selected = YES;
    _vCurrentButton = button;
    
    NSInteger currentIndex = [_vButtonArray indexOfObject:button];
    _vSelectedIndex = currentIndex;
    
    [UIView animateWithDuration:0.3f animations:^{
        [_vBackgroundView setMj_x:_vButtonArray.firstObject.w * currentIndex];
    }];
    
    //代理回传索引
    if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(mEKCornerSelectMenuView:didClickWithIndex:)]) {
        [self.vDelegate mEKCornerSelectMenuView:self didClickWithIndex:currentIndex];
    }
}


//重写索引的setter方法,更新按钮UI&按钮背景UI
- (void)setVSelectedIndex:(NSInteger)vSelectedIndex {
    UIButton *button = _vButtonArray[vSelectedIndex];
    if ([button isEqual:_vCurrentButton]) {
        return;
    }
    _vCurrentButton.selected = NO;
    _vSelectedIndex = vSelectedIndex;
    _vCurrentButton = _vButtonArray[vSelectedIndex];
    _vCurrentButton.selected = YES;
    
    [_vBackgroundView setMj_x:(_vButtonArray.firstObject.w * vSelectedIndex)];
}


- (void)setVNewCountArray:(NSMutableArray<NSNumber *> *)vNewCountArray {
    _vNewCountArray = vNewCountArray;
    for (NSInteger i = 0; i < vNewCountArray.count; i++) {
        _vLabelArray[i].text = vNewCountArray[i].description ? vNewCountArray[i].description : @"";
        _vLabelArray[i].hidden = (vNewCountArray[i].integerValue <= 0);
    }
}


@end
