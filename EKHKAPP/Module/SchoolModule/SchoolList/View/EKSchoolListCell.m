/**
 -  EKSchoolListCell.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/12.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:"学校列表"的cell
 */

#import "EKSchoolListCell.h"

@interface EKSchoolListCell ()
@property (nonatomic, weak) IBOutlet UILabel *vSchoolNameLabel;
@end

@implementation EKSchoolListCell
- (void)setVSchoolListModel:(EKSchoolListModel *)vSchoolListModel {
    _vSchoolListModel = vSchoolListModel;
    _vSchoolNameLabel.text = vSchoolListModel.fname;
}


- (void)setVIndexPath:(NSIndexPath *)vIndexPath {
    _vIndexPath = vIndexPath;
    //根据索引,设置背景颜色
    self.contentView.backgroundColor = [UIColor cellSpace:vIndexPath.row % 2];
}

@end

