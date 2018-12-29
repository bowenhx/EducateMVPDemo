/**
 -  EKSchoolSelectMenuView.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/10.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"学校"界面的三个按钮所在的自定义视图
 */

#import "EKSchoolSelectMenuView.h"
#import "UIColor+app.h"

@interface EKSchoolSelectMenuView ()
//对应的xib中的容器视图
@property (nonatomic, weak) IBOutlet UIView *vContentView;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *vSchoolTypeButtonArray;
//记录当前处于选中状态的按钮
@property (nonatomic, strong) UIButton *vCurrentButton;
@end


@implementation EKSchoolSelectMenuView
//从xib中创建时调用
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self mInitUI];
    }
    return self;
}


#pragma mark - 初始化UI
- (void)mInitUI {
    [[NSBundle mainBundle] loadNibNamed:@"EKSchoolSelectMenuView" owner:self options:nil];
    [self addSubview:self.vContentView];
    self.vContentView.frame = self.bounds;
}


#pragma mark - 按钮监听事件
//"学校类型"按钮监听事件
- (IBAction)mClickSchoolTypeButton:(UIButton *)sender {
    //过滤掉重复点击同一个按钮的情况
    if ([sender isEqual:_vCurrentButton]) {
        return;
    }
    //关闭之前处于选中状态的按钮的选中状态
    _vCurrentButton.selected = NO;
    [_vCurrentButton setBackgroundColor:[UIColor whiteColor]];
    
    //记录当前将要处于选中状态的按钮
    _vCurrentButton = sender;
    
    //打开将要选中的按钮的选中状态
    sender.selected = YES;
    [sender setBackgroundColor:[UIColor EKColorNavigation]];
    
    //记录当前处于选中状态的按钮的下标
    _vCurrentIndex = [_vSchoolTypeButtonArray indexOfObject:sender];
    
    //回传当前处于选中状态的按钮的下标
    if (self.delegate && [self.delegate respondsToSelector:@selector(schoolTypeButtonDidClickWithIndex:)]) {
        [self.delegate schoolTypeButtonDidClickWithIndex:_vCurrentIndex];
    }
}


#pragma mark - 重写属性setter方法
- (void)setVCurrentIndex:(NSInteger)vCurrentIndex {
    //关闭之前处于选中状态的按钮的选中状态
    UIButton *previousButton = _vSchoolTypeButtonArray[vCurrentIndex];
    previousButton.selected = NO;
    [previousButton setBackgroundColor:[UIColor whiteColor]];
    
    //记录当前传入的索引
    _vCurrentIndex = vCurrentIndex;
    
    //打开将要选中的按钮的选中状态
    _vCurrentButton = _vSchoolTypeButtonArray[vCurrentIndex];
    _vCurrentButton.selected = YES;
    [_vCurrentButton setBackgroundColor:[UIColor EKColorNavigation]];
}


@end
