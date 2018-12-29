/**
 -  EKFriendModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/31.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"我的好友"界面的后台返回的数据
 */

#import <Foundation/Foundation.h>

@interface EKFriendModel : NSObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *grouptitle;
@property (nonatomic, copy) NSString *uid;

/**
 请求"我的好友"列表参数

 @param callBack 完成回调
 */
+ (void)mRequestFriendModelDataSourceWithCallBack:(void(^)(NSString *netErr, NSArray <EKFriendModel *> *data))callBack;

@end
