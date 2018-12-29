//
//  EKColumnViewCell.m
//  EKHKAPP
//
//  Created by ligb on 2017/9/12.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import "EKColumnViewCell.h"

@interface EKColumnViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *textLab;


@end


@implementation EKColumnViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _textLab.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, self.h-0.5, self.w, 0.5);
    layer.backgroundColor = [UIColor EKColorSeperateCyan].CGColor;
    [self.layer addSublayer:layer];
}

- (void)setText:(NSString *)text {
    self.textLab.text = text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
