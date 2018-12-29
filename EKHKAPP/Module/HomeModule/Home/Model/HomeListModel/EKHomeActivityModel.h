/**
 -  EKHomeActivityModel.h
 -  EKHKAPP
 -  Created by ligb on 2017/9/20.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：活动数据列表
 */

#import <Foundation/Foundation.h>
#import "EKHomeActivityEventModel.h"

@interface EKHomeActivityModel : NSObject

@property (nonatomic , copy) NSString *group;
@property (nonatomic , copy) NSString *week;
@property (nonatomic , copy) NSString *date;
@property (nonatomic , copy) NSArray<EKHomeActivityEventModel *> *events;


+ (void)mLoadActivityDate:(NSString *)date block:(void(^)(NSArray <EKHomeActivityModel *> *data, NSString *error))block;

/**
 把对应的月份转化为引文简写
 
 @param month 传入月份
 @return 月份简拼
 */
+ (NSString *)monthChangeAction:(NSString *)month;



/**
 传入对应的年份和月份，来计算月份多少天
 
 @param year 年
 @param month 月
 @return 天数
 */
+ (NSInteger)mGetManyDaysInThisYear:(NSInteger)year withMonth:(NSInteger)month;

@end
