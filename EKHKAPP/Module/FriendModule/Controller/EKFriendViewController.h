/**
 -  EKFriendViewController.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/31.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是从"个人中心"界面进入的"我的好友"界面
 -  该界面的几个类是直接用的"搜索好友"模块的,如解除好友关系的弹窗控制器/删除好友时使用的model/列表cell
 */

#import "EKBaseViewController.h"

/**
 从两个不同界面进入时的两种形态

 - FriendPageTypeMyCenter: 从"个人中心"进入
 - FriendPageTypeIsPublishBlog: 从"发布日志"进入
 */
typedef NS_ENUM(NSInteger, FriendPageType) {
    FriendPageTypeMyCenter,
    FriendPageTypeIsPublishBlog //从发布日志进入的，选择好友
};

typedef void (^SelectFriendsBlock)(NSArray *usernames);

@interface EKFriendViewController : EKBaseViewController

@property (nonatomic , copy) SelectFriendsBlock usernames;
@property (nonatomic , assign) FriendPageType friendPageType;

@end
