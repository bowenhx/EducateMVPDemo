/**
 -  BKUserGroupModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:user对象的groups字段
 */

#import <Foundation/Foundation.h>

@interface BKUserGroupModel : NSObject

@property (copy, nonatomic) NSString *isbanpost;
@property (copy, nonatomic) NSString *isbanuser;
@property (copy, nonatomic) NSString *isclosethread;
@property (copy, nonatomic) NSString *iseditpost;
@property (copy, nonatomic) NSString *ismanagereport;
@property (copy, nonatomic) NSString *ismovethread;
@property (copy, nonatomic) NSString *isviewip;
@property (copy, nonatomic) NSString *iswarnpost;

@end
