/**
 -  EKNoticeListModel.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/3.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"提醒"列表的后台model的lists数组字段model
 */

#import "EKNoticeListModel.h"

@implementation EKNoticeListModel
/**
 将当前对象的type字符串属性转换成vType枚举值属性
 */
- (void)mTypeChange {
    if ([self.type isEqualToString:@"post"] || [self.type isEqualToString:@"pcomment"]) {
        self.vType = EKNoticeListModelTypePost;
    } else if ([self.type isEqualToString:@"friendrequest"]) {
        self.vType = EKNoticeListModelTypeFriendRequest;
    } else if ([self.type isEqualToString:@"poke"]) {
        self.vType = EKNoticeListModelTypePoke;
    } else if ([self.type isEqualToString:@"group"]) {
        self.vType = EKNoticeListModelTypeGroup;
    } else {
        self.vType = EKNoticeListModelTypeOther;
    }
}


- (NSString *)description {
    return [self yy_modelDescription];
}
@end
