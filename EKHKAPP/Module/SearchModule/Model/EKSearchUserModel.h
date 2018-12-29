/**
 -  EKSearchUserModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/22.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是后台返回的"搜索用户"数据model
 */

#import <Foundation/Foundation.h>

@interface EKSearchUserModel : NSObject
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *adminid;
@property (nonatomic, copy) NSString *groupid;
@property (nonatomic, copy) NSString *grouptitle;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *isfriend;


/**
 请求添加指定好友

 @param uid 要添加的好友的ID
 @param note 附言
 @param gid 分组id
 @param callBack 网络请求回调
 */
+ (void)mRequestAddFriendWithUid:(NSString *)uid
                            note:(NSString *)note
                             gid:(NSInteger)gid
                        callBack:(void(^)(NSString *netErr, NSString *message))callBack;


/**
 请求删除指定好友

 @param uid 要删除的好友的ID
 @param callBack 网络请求回调
 */
+ (void)mRequestDeleteFriendWithUid:(NSString *)uid
                           callBack:(void(^)(BOOL isSuccess ,NSString *message))callBack;

@end
