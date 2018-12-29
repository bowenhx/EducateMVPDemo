/**
 -  EKNoticeCell.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/3.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"消息提醒"界面的"提醒"cell
 */

#import "EKNoticeCell.h"

@interface EKNoticeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *vIconImageView;
@property (weak, nonatomic) IBOutlet UIView *vIsNewView;
@property (weak, nonatomic) IBOutlet UILabel *vAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *vDatelineLabel;
@property (weak, nonatomic) IBOutlet UILabel *vNoteLabel;
@end

@implementation EKNoticeCell

- (void)setVNoticeListModel:(EKNoticeListModel *)vNoticeListModel {
    _vNoticeListModel = vNoticeListModel;
    
    NSURL *iconURL = [NSURL URLWithString:vNoticeListModel.icon];
    [_vIconImageView sd_setImageWithURL:iconURL placeholderImage:[UIImage imageNamed:kPlaceHolderAvatar]];
    _vIsNewView.hidden = !vNoticeListModel.isnew.integerValue;
    _vAuthorLabel.text = vNoticeListModel.author;
    _vDatelineLabel.text = vNoticeListModel.dateline;
    _vNoteLabel.text = vNoticeListModel.note;
}

@end
