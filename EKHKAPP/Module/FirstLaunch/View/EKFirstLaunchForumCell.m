/**
 -  EKFirstLaunchForumCell.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/13.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"首次启动"界面选择讨论区板块的cell
 */

#import "EKFirstLaunchForumCell.h"
#import "EKFirstLaunchForumCellButton.h"

@interface EKFirstLaunchForumCell ()
@property (weak, nonatomic) IBOutlet EKFirstLaunchForumCellButton *vButton;

@end

@implementation EKFirstLaunchForumCell
- (void)setVSubforumModel:(EKFirstLaunchSubforumModel *)vSubforumModel {
    _vSubforumModel = vSubforumModel;
    
    [_vButton setTitle:vSubforumModel.name forState:UIControlStateNormal];
    _vButton.selected = vSubforumModel.isSelected;
    _vButton.hidden = vSubforumModel.isHidden;
}


#pragma mark - 按钮监听事件
- (IBAction)mClickForumButton:(EKFirstLaunchForumCellButton *)sender {
    //点击按钮之后修改subforumModel的isSelected属性,并更新按钮的UI
    _vSubforumModel.isSelected = !_vSubforumModel.isSelected;
    sender.selected = _vSubforumModel.isSelected;
}


@end
