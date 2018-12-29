/**
 -  EKSearchUserCell.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/22.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"搜寻论坛"界面的用户cell
 -  也用作"我的好友"界面cell
 */

#import "EKSearchUserCell.h"
#import "EKSearchUserModel.h"

@interface EKSearchUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *vAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *vUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *vGrouptitleLabel;

@end

@implementation EKSearchUserCell
- (void)setVModel:(id)vModel {
    [super setVModel:vModel];
    
    EKSearchUserModel *searchUserModel = vModel;
    NSURL *imageURL = [NSURL URLWithString:searchUserModel.avatar];
    [_vAvatarImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:kPlaceHolderAvatar]];
    _vUsernameLabel.text = searchUserModel.username;
    _vGrouptitleLabel.text = searchUserModel.grouptitle;
    _vAddFriendButton.selected = ![searchUserModel.isfriend boolValue];
}


//当用作"我的好友"界面cell的时候,使用这个model来传递UI参数
- (void)setVFriendModel:(EKFriendModel *)vFriendModel {
    _vFriendModel = vFriendModel;
    
    NSURL *imageURL = [NSURL URLWithString:vFriendModel.avatar];
    [_vAvatarImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:kPlaceHolderAvatar]];
    _vUsernameLabel.text = vFriendModel.username;
    _vGrouptitleLabel.text = vFriendModel.grouptitle;
    _vAddFriendButton.selected = NO;
}


//"加为好友"/"解除好友"按钮监听事件
- (IBAction)mClickAddFriendButton:(UIButton *)sender {
    //回传当前cell本身
    if (self.delegate && [self.delegate respondsToSelector:@selector(mSearchUserCellAddFriendButtonDidClickWithCell:)]) {
        [self.delegate mSearchUserCellAddFriendButtonDidClickWithCell:self];
    }
}


@end
