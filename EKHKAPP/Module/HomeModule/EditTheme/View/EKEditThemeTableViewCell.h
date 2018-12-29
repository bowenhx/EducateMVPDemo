//
//  EKEditThemeTableViewCell.h
//  EKHKAPP
//
//  Created by ligb on 2017/9/30.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKEditThemeModel.h"
@class EKEditThemeTableViewCell;

@protocol EKEditThemeTableViewCellDelegate <NSObject>
- (void)didSelectedItemCell:(EKEditThemeTableViewCell *)cell;
@end

@interface EKEditThemeTableViewCell : UITableViewCell

@property (nonatomic, weak) id <EKEditThemeTableViewCellDelegate> delegate;

- (void)showItemModel:(EKThemeSubforumsModel *)model indexPath:(NSIndexPath *)indexPath;

@end
