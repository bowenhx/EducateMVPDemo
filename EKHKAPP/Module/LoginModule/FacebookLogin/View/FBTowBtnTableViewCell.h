//
//  FBTowBtnTableViewCell.h
//  BKMobile
//
//  Created by ligb on 2017/8/11.
//  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXButton.h"

@interface FBTowBtnTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *vTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *vTitleLabel2;

@property (weak, nonatomic) IBOutlet EXButton *selectBtn;
@property (weak, nonatomic) IBOutlet EXButton *selectBtn2;

- (void)loadTitleArray:(NSArray *)titles info:(NSDictionary *)dict row:(NSInteger)row;

@end
