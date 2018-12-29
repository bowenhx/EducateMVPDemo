/**
 -  EKMyCenterInformationCell.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/23.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"个人中心"最上面的显示用户信息的cell
 */

#import "EKMyCenterInformationCell.h"

@interface EKMyCenterInformationCell ()
@property (weak, nonatomic) IBOutlet UILabel *vUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *vGroupTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *vCreditLabel;
//表示有未读消息提醒的小红点(xib中设置的默认是隐藏的)
@property (weak, nonatomic) IBOutlet UIView *vRedBadge;
@end

@implementation EKMyCenterInformationCell
#pragma mark - 更新UI
- (void)setVMyCenterListModel:(EKMyCenterListModel *)vMyCenterListModel {
    [super setVMyCenterListModel:vMyCenterListModel];
    BKUserModel *userModel = vMyCenterListModel.vUserModel;
    
    _vUserNameLabel.text = userModel.username;
    _vGroupTitleLabel.text = userModel.grouptitle;
    
    _vCreditLabel.text = vMyCenterListModel.vBasicInformationModel.credits;
    
    _vAvatarButton.imageView.contentMode = UIViewContentModeScaleAspectFit;    
    //避免由于版本升级而可能导致的个人中心头像空白问题
    NSString *iconURLString = [BKSaveData getString:kUserAvatarURLStringKey];
    if ([BKTool isStringBlank:iconURLString]) {
        //生成1个新的用户头像URL地址保存起来
        int randomNumber = arc4random() % 100;
        NSString *avatarUrlString = [NSString stringWithFormat:@"%@&random=%d",USER.avatar,randomNumber];
        [BKSaveData setString:avatarUrlString key:kUserAvatarURLStringKey];
        iconURLString = avatarUrlString;
    }
    [_vAvatarButton sd_setImageWithURL:[NSURL URLWithString:iconURLString]
                              forState:UIControlStateNormal];
}


- (void)setVIsHideRedBadge:(BOOL)vIsHideRedBadge {
    [super setVIsHideRedBadge:vIsHideRedBadge];
    _vRedBadge.hidden = vIsHideRedBadge;
}


#pragma mark - 上半部分的按钮的监听事件
//上传用户头像
- (IBAction)mUploadUserAvatar:(id)sender {
    if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(mUploadUserAvatarButtonDidClick)]) {
        [self.vDelegate mUploadUserAvatarButtonDidClick];
    }
}


//跳转到"基本资料"界面
- (IBAction)mPushToBasicInformationViewController:(id)sender {
    if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(mBasicInformationButtonDidClick)]) {
        [self.vDelegate mBasicInformationButtonDidClick];
    }
}


#pragma mark - 下半部分8个按钮的监听事件
//跳转到"帖子"(我的主题)界面
- (IBAction)mPushToMyThemeViewController:(id)sender {
    if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(mMyThemeButtonDidClick)]) {
        [self.vDelegate mMyThemeButtonDidClick];
    }
}


//跳转到"主题收藏"界面
- (IBAction)mPushToThemeCollectViewController:(id)sender {
    if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(mThemeCollectButtonDidClick)]) {
        [self.vDelegate mThemeCollectButtonDidClick];
    }
}


//跳转到"消息提醒"界面
- (IBAction)mPushToMessageViewController:(id)sender {
    if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(mMessageButtonDidClick)]) {
        [self.vDelegate mMessageButtonDidClick];
    }
}


//跳转到"我的日志"界面
- (IBAction)mPushToMyBlogViewController:(id)sender {
    if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(mMyBlogButtonDidClick)]) {
        [self.vDelegate mMyBlogButtonDidClick];
    }
}


@end
