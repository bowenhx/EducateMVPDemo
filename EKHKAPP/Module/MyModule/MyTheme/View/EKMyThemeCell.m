/**
 -  EKMyThemeCell.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/25.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"我的主题"界面的"主题"cell."主题收藏"界面也用到了
 */

#import "EKMyThemeCell.h"

@interface EKMyThemeCell ()
@property (weak, nonatomic) IBOutlet UILabel *vSubjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *vLastPostLabel;
@property (weak, nonatomic) IBOutlet UILabel *vFNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *vRepliesLabel;
@property (weak, nonatomic) IBOutlet UILabel *vViewsLabel;
@end

@implementation EKMyThemeCell
- (void)setVMyThemeModel:(EKMyThemeModel *)vMyThemeModel {
    _vMyThemeModel = vMyThemeModel;
    
    _vSubjectLabel.text = vMyThemeModel.subject;
    _vLastPostLabel.text = vMyThemeModel.lastpost;
    _vFNameLabel.text = vMyThemeModel.fname;
    _vRepliesLabel.text = vMyThemeModel.replies;
    _vViewsLabel.text = vMyThemeModel.views;
}


- (void)setVMyCollectModel:(EKMyCollectModel *)vMyCollectModel {
    _vMyCollectModel = vMyCollectModel;
    
    _vSubjectLabel.text = vMyCollectModel.title;
    _vLastPostLabel.text = vMyCollectModel.dateline;
    _vFNameLabel.text = vMyCollectModel.fname;
    _vRepliesLabel.text = vMyCollectModel.replies;
    _vViewsLabel.text = vMyCollectModel.views;
}

@end
