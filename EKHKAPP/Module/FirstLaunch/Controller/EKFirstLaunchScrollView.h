/**
 -  EKFirstLaunchScrollView.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/14.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是程序首次启动时显示的给用户选择喜欢的版块的scrollView
 -  由于"首次启动"界面的跳转效果用UIViewController不好实现,所以使用了UIScrollView.
 -  本scrollView其实可以当做成控制器来看待,"选择年级"和"选择板块"的view也可以当做控制器来看待
 */

#import <UIKit/UIKit.h>

@interface EKFirstLaunchScrollView : UIScrollView
/**
 显示"首次启动"界面,内部做好了显示时机的判断
 */
+ (void)mShowFirstLaunchScrollView;
@end
