/**
 -  EKMessageModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/3.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"消息提醒"界面的后台返回的"消息"数据
 */

#import <Foundation/Foundation.h>
#import "EKMessageListModel.h"

@interface EKMessageModel : NSObject
@property (nonatomic, copy) NSString *newcount;
@property (nonatomic, strong) NSArray <EKMessageListModel *> *lists;
/**
 请求"消息"数据

 @param page page参数
 @param callBack 完成回调(注意,返回的数据源是model不是数组,数组得通过lists属性获得)
 */
+ (void)mRequestMessageModelWithPage:(NSInteger)page
                            callBack:(void(^)(NSString *netErr, EKMessageModel *messageModel))callBack;
@end
