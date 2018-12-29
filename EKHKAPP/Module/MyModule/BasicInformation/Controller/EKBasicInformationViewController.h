/**
 -  EKBasicInformationViewController.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/30.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:从"个人中心"界面的第0个cell的"资料"按钮进入的"基本资料"界面
 */

#import "EKBaseViewController.h"
#import "EKBasicInformationModel.h"

@interface EKBasicInformationViewController : EKBaseViewController
//后台返回的用户基本资料信息数组
@property (strong, nonatomic) NSArray <NSString *> *vBasicInformationArray;
@end
