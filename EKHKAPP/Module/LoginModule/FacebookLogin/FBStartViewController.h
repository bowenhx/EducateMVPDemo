/**
 -  FBStartViewController.h
 -  BKMobile
 -  Created by ligb on 2017/8/8.
 -  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
 -  说明：
 */

#import "BaseTableViewController.h"

@interface FBStartViewController : BaseTableViewController

/*当用户点击facebook 登录完成后跳转到启动账户页面*/
@property (nonatomic, copy) NSDictionary *infoData;

@property (nonatomic , copy) void (^ pushHomePageVC )(NSString *userName);
@end
