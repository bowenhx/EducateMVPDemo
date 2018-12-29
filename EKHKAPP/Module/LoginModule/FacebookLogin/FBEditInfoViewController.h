/**
 -  FBEditInfoViewController.h
 -  BKMobile
 -  Created by ligb on 2017/8/4.
 -  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
 -  说明：该页面为faceboo 会员注册是编辑页面
 */

#import "EKBaseViewController.h"

//添加枚举，标示上个页面从注册进入，或从fb注册进入
typedef NS_ENUM (NSInteger, PageType)   {
    PageTypeWithRegister = 0,
    PageTypeWithFacebookRegister = 1,
};

@interface FBEditInfoViewController : EKBaseViewController

@property (nonatomic, assign) PageType pageType;
@property (nonatomic, strong) NSMutableDictionary *dictCommit;
@end
