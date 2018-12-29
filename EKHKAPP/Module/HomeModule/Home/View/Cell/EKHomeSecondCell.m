//
//  EKHomeSecondCell.m
//  EKHKAPP
//
//  Created by ligb on 2017/9/14.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import "EKHomeSecondCell.h"

@interface EKHomeSecondCell()
@property (weak, nonatomic) IBOutlet UIImageView *vImage;
@property (weak, nonatomic) IBOutlet UILabel *vTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *vDescribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *vTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *vReviewLabel;


@end

@implementation EKHomeSecondCell

- (void)setVHomeMilkModel:(EKHomeMilkModel *)vHomeMilkModel {
    _vHomeMilkModel = vHomeMilkModel;
    
    NSURL *imageURL = [NSURL URLWithString:vHomeMilkModel.thumb];
    [_vImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:kPlaceHolderBKMilk]];
    _vTitleLabel.text = vHomeMilkModel.class_name;
    _vDescribeLabel.text = vHomeMilkModel.title;
    _vTimeLabel.text = vHomeMilkModel.dateline;
    _vReviewLabel.text = vHomeMilkModel.view;
}

@end
