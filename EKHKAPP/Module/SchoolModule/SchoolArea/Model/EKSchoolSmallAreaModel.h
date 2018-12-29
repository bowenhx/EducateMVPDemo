/**
 -  EKSchoolSmallAreaModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/12.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:后台返回的学校区域字段中的areas字段数组元素对应的model
 */

#import <Foundation/Foundation.h>

@interface EKSchoolSmallAreaModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *kinder_id;
@property (nonatomic, copy) NSString *primary_id;
@property (nonatomic, copy) NSString *intl_id;
//本地使用的字段,用来控制cell能否被点击
@property (nonatomic, assign) BOOL vUserInteractEnable;
@end
