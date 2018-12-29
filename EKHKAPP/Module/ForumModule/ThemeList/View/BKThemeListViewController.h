/**
 -  BKThemeListViewController.h
 -  BKHKAPP
 -  Created by HY on 2017/8/4.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：主题列表页面，从讨论区进入该页面和从群组进入该页面，头部ui有一点不同
 */

#import "EKBaseViewController.h"
#import "BKThemeListHeaderCell.h"
#import "EKADViewController.h"

@interface BKThemeListViewController : EKADViewController

//板块id
@property (nonatomic, copy) NSString *vFid;

//板块密码，可为空
@property (nonatomic, copy) NSString *vPassword;

//页面类型,1：从板块进入该页面  2：从群组进入该页面
@property (nonatomic, assign) BKThemeListViewControllerType vType;




@end
