/**
 -  EKSettingLogoutFooterView.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/8.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"设置"界面的底部"退出当前登录账号"视图
 */

#import <UIKit/UIKit.h>

@protocol EKSettingLogoutFooterViewDelegate;
@interface EKSettingLogoutFooterView : UIView
//代理对象
@property (nonatomic, weak) id <EKSettingLogoutFooterViewDelegate> vDelegate;
@end

@protocol EKSettingLogoutFooterViewDelegate <NSObject>
//"登出"按钮点击的时候调用
- (void)mLogoutButtonDidClick;
@end
