/**
 -  EKSchoolAreaCollectionHeaderView.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/12.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"学校"界面的collectionView的组头视图
 */

#import "EKSchoolAreaCollectionHeaderView.h"

@interface EKSchoolAreaCollectionHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *vGroupLabel;
@end

@implementation EKSchoolAreaCollectionHeaderView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mSchoolAreaCollectionHeaderViewDidTouch)]) {
        [self.delegate mSchoolAreaCollectionHeaderViewDidTouch];
    }
}

- (void)setVSchoolBigAreaModel:(EKSchoolBigAreaModel *)vSchoolBigAreaModel {
    _vSchoolBigAreaModel = vSchoolBigAreaModel;
    
    if (vSchoolBigAreaModel.group) {
        NSDictionary *attributes = @{NSKernAttributeName : @(3),
                                     NSFontAttributeName : [UIFont systemFontOfSize:13]};
        _vGroupLabel.attributedText = [[NSAttributedString alloc] initWithString:vSchoolBigAreaModel.group attributes:attributes];
    }
}

@end
