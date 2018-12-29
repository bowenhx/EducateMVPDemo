/**
 -  EKSearchUserAlertController.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/25.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是搜索用户cell的"解除好友"按钮点击的时候的弹窗控制器
 */

#import <UIKit/UIKit.h>

@protocol EKSearchUserAlertControllerDelegate;

@interface EKSearchUserAlertController : UIAlertController
/**
 自定义构造方法

 @param delegate 代理对象
 @param row 点击的"解除好友"按钮所在的行
 @return 弹窗控制器
 */
- (instancetype)initWithDelegate:(id<EKSearchUserAlertControllerDelegate>)delegate
                         withRow:(NSInteger)row;

/**
 自定义构造方法
 
 @param delegate 代理对象
 @return 弹窗控制器
 */
- (instancetype)initWithDelegate:(id<EKSearchUserAlertControllerDelegate>)delegate;
@end


@protocol EKSearchUserAlertControllerDelegate <NSObject>
@optional
/**
 解除好友弹窗的"确定"按钮点击的时候调用

 @param row 回传索引
 */
- (void)mSearchUserAlertControllerConfirmButtonDidClickWithRow:(NSInteger)row;


/**
 解除好友弹窗的"确定"按钮点击的时候调用
 */
- (void)mSearchUserAlertControllerConfirmButtonDidClick;
@end
