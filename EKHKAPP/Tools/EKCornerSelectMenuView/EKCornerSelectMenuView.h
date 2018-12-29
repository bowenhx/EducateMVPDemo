/**
 -  EKCornerSelectMenuView.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/21.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:项目中通用的圆弧形菜单选择视图
 -  只能使用纯代码创建
 -  只能通过frame来设置布局,自动布局不可以
 */

#import <UIKit/UIKit.h>

//定义导航栏中间分段控件的高度
static CGFloat NAV_MENU_HEIGHT = 30;

/**
 圆弧形菜单选择视图的两种类型

 - EKCornerSelectMenuViewTypeNormal: 普通类型
 - EKCornerSelectMenuViewTypeNavigation: 导航条类型
 */
typedef NS_ENUM(NSInteger, EKCornerSelectMenuViewType) {
    EKCornerSelectMenuViewTypeNormal = 0,
    EKCornerSelectMenuViewTypeNavigation
};

@protocol EKCornerSelectMenuViewDelegate;

@interface EKCornerSelectMenuView : UIView
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
                selectedIndex:(NSInteger)selectedIndex;

//当前选中下标
@property (nonatomic, assign) NSInteger vSelectedIndex;
//当用于"消息提醒"界面的时候,可传入未读消息数数组来更新小红点UI(数组只能有两个元素)
@property (nonatomic, strong) NSMutableArray <NSNumber *> *vNewCountArray;
@end


@protocol EKCornerSelectMenuViewDelegate <NSObject>
/**
 按钮点击时候调用

 @param selectMenuView 回传视图本身
 @param index 回传按钮索引
 */
- (void)mEKCornerSelectMenuView:(EKCornerSelectMenuView *)selectMenuView didClickWithIndex:(NSInteger)index;
@end
