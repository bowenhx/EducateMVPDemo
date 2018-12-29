/**
 -  EKMyThemeViewController.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/25.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"个人中心"进入的"我的主题"界面
 -  也可从"用户个人资料"界面的"话题"按钮进入用于查看别人的话题和回复
 */

#import "EKBaseViewController.h"

@interface EKMyThemeViewController : EKBaseViewController
//这两个属性传入时表明是查看别人的话题和回复,不传的话表明是从"个人中心"进入查看当前用户的话题和回复
@property (nonatomic, copy) NSString *vUid;
@property (nonatomic, copy) NSString *vUserName;
@end
