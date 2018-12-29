/**
 -  EKNoticeListModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/3.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"提醒"列表的后台model的lists数组字段model
 */

#import <Foundation/Foundation.h>

/**
 用户相关通知类型

 - EKNoticeListModelTypePost: 跟帖被回复提醒
 - EKNoticeListModelTypeFriendRequest: 好友请求提醒
 - EKNoticeListModelTypePoke: 招呼提醒
 - EKNoticeListModelTypeGroup: 群组相关提醒（加入、邀请、通过、未通过等）
 - EKNoticeListModelTypeOther: 其他
 */
typedef NS_ENUM(NSInteger, EKNoticeListModelType) {
    EKNoticeListModelTypePost,
    EKNoticeListModelTypeFriendRequest,
    EKNoticeListModelTypePoke,
    EKNoticeListModelTypeGroup,
    EKNoticeListModelTypeOther
};

@interface EKNoticeListModel : NSObject
@property (nonatomic, copy) NSString *isnew;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *authorid;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *dateline;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *tid;
//本地生成的枚举值,根据后台返回的type生成,方便外界做判断
@property (nonatomic, assign) EKNoticeListModelType vType;


/**
 将当前对象的type字符串属性转换成vType枚举值属性
 */
- (void)mTypeChange;

@end
