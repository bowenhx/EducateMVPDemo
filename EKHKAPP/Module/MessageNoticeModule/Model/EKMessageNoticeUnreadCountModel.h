//
//  EKMessageNoticeUnreadCountModel.h
//  EKHKAPP
//
//  Created by calvin_Tse on 2017/11/8.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EKMessageNoticeUnreadCountModel : NSObject
@property (nonatomic, copy) NSString *messageCount;
@property (nonatomic, copy) NSString *noticeCount;
/**
 请求未读消息数和未读提醒数

 @param callBack 完成回调
 */
+ (void)mRequestMessageNoticeUnreadCountModelWithCallBack:(void(^)(NSString *messageCount, NSString *noticeCount))callBack;
@end
