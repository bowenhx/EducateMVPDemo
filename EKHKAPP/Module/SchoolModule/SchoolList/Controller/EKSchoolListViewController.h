/**
 -  EKSchoolListViewController.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/12.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:从"学校"界面跳入的"学校列表"界面,可从点击单元格或者点击搜索按钮进入
 */

#import "EKBaseViewController.h"

@interface EKSchoolListViewController : EKBaseViewController
//点击"学校"的cell进入"学校列表"界面的话,需要areaID参数来发起网络请求
@property (nonatomic, copy) NSString *areaID;
//通过"学校"的搜索功能进入"学校列表"界面的话,需要keyword参数来发起网络请求
@property (nonatomic, copy) NSString *keyword;
@end
