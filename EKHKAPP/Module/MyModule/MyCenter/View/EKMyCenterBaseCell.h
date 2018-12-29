/**
 -  EKMyCenterBaseCell.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:"个人中心"界面的两种cell的基类cell,用来提供协议与包含UI信息的model
 */

#import <UIKit/UIKit.h>
#import "EKMyCenterListModel.h"
//协议声明
@protocol EKMyCenterBaseCellDelegate;

@interface EKMyCenterBaseCell : UITableViewCell
//包含UI信息的model
@property (nonatomic, strong) EKMyCenterListModel *vMyCenterListModel;
//代理对象
@property (nonatomic, weak) id <EKMyCenterBaseCellDelegate> vDelegate;
//子类的属性,用来设置小红点是否需要隐藏
@property (nonatomic, assign) BOOL vIsHideRedBadge;
@end

@protocol EKMyCenterBaseCellDelegate <NSObject>
//用户头像点击时调用
- (void)mUploadUserAvatarButtonDidClick;

//"资料"按钮点击时候调用
- (void)mBasicInformationButtonDidClick;

//"帖子"按钮点击时候调用
- (void)mMyThemeButtonDidClick;

//"主题收藏"按钮点击时候调用
- (void)mThemeCollectButtonDidClick;

//"消息提醒"按钮点击时候调用
- (void)mMessageButtonDidClick;

//"日志"按钮点击时候调用
- (void)mMyBlogButtonDidClick;

//未登录时点击顶部cell跳转到登录界面
- (void)mPopToLoginViewController;

@end
