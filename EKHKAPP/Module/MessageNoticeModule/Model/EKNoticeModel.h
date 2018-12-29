/**
 -  EKNoticeModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/3.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"消息提醒"界面的"提醒"列表的后台数组model
 */

#import <Foundation/Foundation.h>
#import "EKNoticeListModel.h"

@interface EKNoticeModel : NSObject
@property (nonatomic, copy) NSString *newcount;
@property (nonatomic, strong) NSArray <EKNoticeListModel *> *lists;


/**
 请求"提醒"后台数据

 @param page page参数
 @param callBack 完成回调
 */
+ (void)mRequestNoticeModelDataSourceWithPage:(NSInteger)page
                                     callBack:(void(^)(NSString *netErr, EKNoticeModel *noticeModel))callBack;

@end
