/**
 -  EKSchoolAreaCell.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/11.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"学校"界面的collectionView的cell
 */

#import "EKSchoolAreaCell.h"

@interface EKSchoolAreaCell ()
@property (weak, nonatomic) IBOutlet UILabel *vNameLabel;
@end

@implementation EKSchoolAreaCell
- (void)setVSchoolSmallAreaModel:(EKSchoolSmallAreaModel *)vSchoolSmallAreaModel {
    _vSchoolSmallAreaModel = vSchoolSmallAreaModel;
    if (vSchoolSmallAreaModel.name) {
        NSDictionary *attributes = @{NSKernAttributeName : @(3)};
        _vNameLabel.attributedText = [[NSAttributedString alloc] initWithString:vSchoolSmallAreaModel.name attributes:attributes];
    }
    self.userInteractionEnabled = vSchoolSmallAreaModel.vUserInteractEnable;
}

@end
