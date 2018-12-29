//
//  FBItemCollectionViewCell.m
//  BKMobile
//
//  Created by ligb on 2017/8/11.
//  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "FBItemCollectionViewCell.h"

@implementation FBItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.vSelectBtn setTitleColor:[UIColor EKColorYellow] forState:UIControlStateSelected];
    [self.vSelectBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
}

@end
