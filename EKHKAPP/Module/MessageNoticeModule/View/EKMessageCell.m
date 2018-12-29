/**
 -  EKMessageCell.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/3.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"消息提醒"界面的"消息"cell
 */

#import "EKMessageCell.h"

@interface EKMessageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *vAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *vNewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *vPmNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *vSubjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *vDatelineLabel;
@end

@implementation EKMessageCell
- (void)setVMessageListModel:(EKMessageListModel *)vMessageListModel {
    _vMessageListModel = vMessageListModel;
    
    NSURL *avatarURL = [NSURL URLWithString:vMessageListModel.avatar];
    [_vAvatarImageView sd_setImageWithURL:avatarURL placeholderImage:[UIImage imageNamed:kPlaceHolderAvatar]];
    //如果没有未读消息数.小红点隐藏,否则显示未读消息数
    _vNewCountLabel.hidden = !vMessageListModel.newcount.integerValue;
    _vNewCountLabel.text = vMessageListModel.newcount ? vMessageListModel.newcount : @"";
    
    _vPmNameLabel.text = vMessageListModel.pmname;
    _vSubjectLabel.text = vMessageListModel.subject;
    _vDatelineLabel.text = vMessageListModel.dateline;
}
@end
