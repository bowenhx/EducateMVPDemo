/**
 -  EKMilkMoreViewController.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/29.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是首页点击进入的"BKMilk更多"界面
 */

#import "EKBaseViewController.h"
#import "EKADViewController.h"

@interface EKMilkMoreViewController : EKADViewController
/**
 "BKMilk更多"界面需要根据这个字段来发起网络请求
 */
@property (nonatomic, copy) NSString *vTabid;
@end
