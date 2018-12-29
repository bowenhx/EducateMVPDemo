/**
 -  EKUserInformationViewController.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/31.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是查看别的用户的基本资料的界面
 */

#import "EKBaseViewController.h"

@protocol EKUserInformationViewControllerDelegate;

@interface EKUserInformationViewController : EKBaseViewController
//用户头像URL地址字符串
@property (nonatomic, copy) NSString *userImageURLString;
//用户id
@property (nonatomic, copy) NSString *uid;
//用户名称
@property (nonatomic, copy) NSString *name;
//代理对象
@property (nonatomic, weak) id <EKUserInformationViewControllerDelegate> delegate;
@end


@protocol EKUserInformationViewControllerDelegate <NSObject>
/**
 删除好友成功后调用

 @param UID 删除的好友的uid
 */
- (void)mDeleteFriendWithUID:(NSString *)UID;
@end
