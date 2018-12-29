//
//  ManageReportTableViewCell.h
//  BKMobile
//
//  Created by bowen on 15/12/18.
//  Copyright © 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+EXCell.h"
#import "ReportModel.h"

@interface ManageReportTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton_EXCell *btnDelete;

@property (weak, nonatomic) IBOutlet UIButton_EXCell *btnDispose;

@property (weak, nonatomic) IBOutlet UILabel *labFruit;

@property (weak, nonatomic) IBOutlet UILabel *labFruitStatus;

-(void)refreshView:(ReportModel *)model;


@end
