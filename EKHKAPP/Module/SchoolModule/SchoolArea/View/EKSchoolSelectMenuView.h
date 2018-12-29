/**
 -  EKSchoolSelectMenuView.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/10.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"学校"界面的三个按钮所在的自定义视图
 */

#import <UIKit/UIKit.h>

@protocol EKSchoolSelectMenuViewDelegate;

@interface EKSchoolSelectMenuView : UIView
//设置当前处于选中状态的按钮的下标(可在xib直接设置)
@property (nonatomic, assign) IBInspectable NSInteger vCurrentIndex;
@property (nonatomic, weak) id <EKSchoolSelectMenuViewDelegate> delegate;
@end

@protocol EKSchoolSelectMenuViewDelegate <NSObject>
//"学校类型"按钮点击的时候调用
- (void)schoolTypeButtonDidClickWithIndex:(NSInteger)index;
@end
