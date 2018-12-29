/**
 -  EKMyCenterListModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/23.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"个人中心"的tableView的cell对应的model(基本资料model不是本地数据,其余的是本地数据)
 */

#import <Foundation/Foundation.h>
#import "EKBasicInformationModel.h"

@interface EKMyCenterListModel : NSObject
//重用标识符
@property (nonatomic, copy) NSString *vReuseIdentifier;
//cell的高度
@property (nonatomic, assign) CGFloat vCellHeight;
//点击时要跳转到的控制器名称
@property (nonatomic, copy) NSString *vControllerName;
//图片名称
@property (nonatomic, copy) NSString *vImageName;
//标题信息
@property (nonatomic, copy) NSString *vTitle;
//用户model
@property (nonatomic, strong) BKUserModel *vUserModel;
//基本资料model
@property (nonatomic, strong) EKBasicInformationModel *vBasicInformationModel;

/**
 获取到本地的包含"个人中心"cell的UI信息的model数组

 @return 包含"个人中心"cell的UI信息的model数组
 */
+ (NSArray <NSArray <EKMyCenterListModel *> *> *)mGetMyCenterListModelArray;
@end
