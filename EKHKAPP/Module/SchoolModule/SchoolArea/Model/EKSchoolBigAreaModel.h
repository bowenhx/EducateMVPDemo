/**
 -  EKSchoolBigAreaModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/12.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:后台返回的学校区域字段
 */

#import <Foundation/Foundation.h>
#import "EKSchoolSmallAreaModel.h"

@interface EKSchoolBigAreaModel : NSObject
@property (nonatomic, copy) NSString *group;
@property (nonatomic, strong) NSMutableArray <EKSchoolSmallAreaModel *> *areas;

/**
 请求学校区域后台数据

 @param callBack 网络请求回调
 */
+ (void)mRequestSchoolAreaDataWithCallBack:(void(^)(NSArray <EKSchoolBigAreaModel *> *data , NSString *netErr))callBack;
@end
