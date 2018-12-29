/**
 -  EKMessageListModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/3.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:EKMessageModel的list数组字段的model
 */

#import <Foundation/Foundation.h>

@interface EKMessageListModel : NSObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *dateline;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *pmname;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *isnew;
@property (nonatomic, copy) NSString *newcount;
@property (nonatomic, copy) NSString *pmuid;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *weburl;
@end
