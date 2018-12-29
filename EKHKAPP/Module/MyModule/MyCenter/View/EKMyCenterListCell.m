/**
 -  EKMyCenterListCell.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/23.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"个人中心"界面的普通cell
 */

#import "EKMyCenterListCell.h"

@interface EKMyCenterListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *vImageView;
@property (weak, nonatomic) IBOutlet UILabel *vTitleLabel;
@end

@implementation EKMyCenterListCell
- (void)setVMyCenterListModel:(EKMyCenterListModel *)vMyCenterListModel {
    [super setVMyCenterListModel:vMyCenterListModel];
    _vImageView.image = [UIImage imageNamed:vMyCenterListModel.vImageName];
    _vTitleLabel.text = vMyCenterListModel.vTitle;
}

@end
