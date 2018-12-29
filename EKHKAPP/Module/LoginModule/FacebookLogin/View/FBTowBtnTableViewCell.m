//
//  FBTowBtnTableViewCell.m
//  BKMobile
//
//  Created by ligb on 2017/8/11.
//  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "FBTowBtnTableViewCell.h"


@implementation FBTowBtnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor EKColorBackground];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadTitleArray:(NSArray *)titles info:(NSDictionary *)dict row:(NSInteger)row{
    self.vTitleLabel.text = titles.firstObject;
    self.vTitleLabel2.text = titles.lastObject;
    
    if (row == 1) {
        self.selectBtn.text = @"gender";
        self.selectBtn2.text = @"age";
    } else if (row == 6){
        self.selectBtn.text = @"child_year_month1";
        self.selectBtn2.text = @"child_gender1";
    } else if (row == 8){
        self.selectBtn.text = @"child_year_month2";
        self.selectBtn2.text = @"child_gender2";
    } else if (row == 10){
        self.selectBtn.text = @"child_year_month3";
        self.selectBtn2.text = @"child_gender3";
    } else if (row == 12){
        self.selectBtn.text = @"child_year_month4";
        self.selectBtn2.text = @"child_gender4";
    }
    
    [self.selectBtn setTitle:dict[self.selectBtn.text] forState:UIControlStateNormal];
    [self.selectBtn2 setTitle:dict[self.selectBtn2.text] forState:UIControlStateNormal];
    
}


@end
