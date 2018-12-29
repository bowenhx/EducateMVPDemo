//
//  FBOneBtnTableViewCell.h
//  BKMobile
//
//  Created by ligb on 2017/8/11.
//  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXButton.h"
@interface FBOneBtnTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *vTitleLabel;

@property (weak, nonatomic) IBOutlet EXButton *selectBtn;

- (void)loadTitle:(NSString *)title
             info:(NSDictionary *)dict
              row:(NSInteger)row
         allCount:(NSInteger)count;

@end
