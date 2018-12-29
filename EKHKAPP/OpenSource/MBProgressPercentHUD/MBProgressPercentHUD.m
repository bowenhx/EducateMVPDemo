/**
 -  MBProgressPercentHUD.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/25.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:继承自第三方MBProgressHUD的自定义视图,用来显示百分比进度提示框
 */

#import "MBProgressPercentHUD.h"

@implementation MBProgressPercentHUD

/**
 自定义快速构造方法
 
 @param view 显示到哪个view上
 @param message 要显示的文字信息
 @return 百分比进度提示框
 */
+ (instancetype)showHUDAddedTo:(UIView *)view
                       message:(NSString *)message {
    MBProgressPercentHUD *hud = [super showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.alpha = 0.6f;
    //隐藏时候从父视图中移除
    hud.removeFromSuperViewOnHide = YES;
    //打开蒙层效果
    hud.dimBackground = YES;
    return hud;
}

@end
