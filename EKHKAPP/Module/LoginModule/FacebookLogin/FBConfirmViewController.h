//
//  FBConfirmViewController.h
//  BKMobile
//
//  Created by ligb on 2017/7/24.
//  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "EKBaseViewController.h"
typedef enum{
    FB_Link_Account = 0,   //链接账户
    FB_UserInfo = 1        //用户资料
}FBPageView;

@interface FBConfirmViewController : EKBaseViewController

@property (nonatomic, copy) NSDictionary *info;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) FBPageView pageType;

@property (nonatomic , copy) void (^ pushHomePageVC )(NSInteger index);

@end
