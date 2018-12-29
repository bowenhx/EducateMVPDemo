/**
 -  EKMilkMoreCell.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/29.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"BKMilk更多"界面的列表cell
 */

#import "EKMilkMoreCell.h"

@interface EKMilkMoreCell ()
@property (weak, nonatomic) IBOutlet UILabel *vTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *vUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *vDatelineLabel;
@property (weak, nonatomic) IBOutlet UILabel *vViewLabel;
@end

@implementation EKMilkMoreCell

- (void)setVMilkMoreListModel:(EKMilkMoreListModel *)vMilkMoreListModel {
    _vMilkMoreListModel = vMilkMoreListModel;
    
    _vTitleLabel.text = vMilkMoreListModel.title;
    _vUsernameLabel.text = vMilkMoreListModel.username;
    _vDatelineLabel.text = vMilkMoreListModel.dateline;
    _vViewLabel.text = vMilkMoreListModel.view;
}

@end
