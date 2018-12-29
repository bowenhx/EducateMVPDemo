//
//  EKMessageNoticeUnreadCountModel.m
//  EKHKAPP
//
//  Created by calvin_Tse on 2017/11/8.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import "EKMessageNoticeUnreadCountModel.h"

@implementation EKMessageNoticeUnreadCountModel
/**
 请求未读消息数和未读提醒数
 
 @param callBack 完成回调
 */
+ (void)mRequestMessageNoticeUnreadCountModelWithCallBack:(void(^)(NSString *messageCount, NSString *noticeCount))callBack {
    [EKHttpUtil mHttpWithUrl:kUnreadMessageCountURL parameter:@{@"token" : TOKEN} response:^(BKNetworkModel *model, NSString *netErr) {
        if (1 == model.status) {
            if (model.data && [model.data isKindOfClass:[NSDictionary class]]) {
                EKMessageNoticeUnreadCountModel *messageNoticeUnreadCountModel = [EKMessageNoticeUnreadCountModel yy_modelWithDictionary:model.data];
                callBack(messageNoticeUnreadCountModel.messageCount, messageNoticeUnreadCountModel.noticeCount);
            }
        }
    }];
    if (!LOGINSTATUS) {
        callBack(@"0",@"0");
    }
}
@end
