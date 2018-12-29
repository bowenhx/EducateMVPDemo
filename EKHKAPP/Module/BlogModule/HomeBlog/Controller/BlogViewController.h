/**
 -  BlogViewController.h
 -  EKHKAPP
 -  Created by HY on 2017/9/7.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：日志列表
 */

#import "EKBaseViewController.h"
#import "EKCornerSelectMenuView.h"
#import "EKADViewController.h"

@interface BlogViewController : EKADViewController

//navBar中间的选择控件
@property (nonatomic, strong) EKCornerSelectMenuView *vSelectMenuView;

@end
