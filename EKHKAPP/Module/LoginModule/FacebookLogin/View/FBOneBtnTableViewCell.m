//
//  FBOneBtnTableViewCell.m
//  BKMobile
//
//  Created by ligb on 2017/8/11.
//  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "FBOneBtnTableViewCell.h"


@implementation FBOneBtnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor EKColorBackground];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadTitle:(NSString *)title info:(NSDictionary *)dict row:(NSInteger)row allCount:(NSInteger)count{
    self.vTitleLabel.text = title;
    
    if (row == 2) {
        self.selectBtn.text = @"family";
    } else if (row == 3){
        self.selectBtn.text = @"pregnancy";
    } else if (row == 4){
         self.selectBtn.text = @"birthday";
    } else if (row == 5){
         self.selectBtn.text = @"child";
    } else if (row == 7){
        self.selectBtn.text = @"school1";
    } else if (row == 9){
        self.selectBtn.text = @"school2";
    } else if (row == 11){
        self.selectBtn.text = @"school3";
    } else if (row == 13){
        self.selectBtn.text = @"school4";
    }
    
    if (row == count-1) {
        self.selectBtn.text = @"income";
    }
    
    [self.selectBtn setTitle:dict[self.selectBtn.text] forState:UIControlStateNormal];
    
}
@end
