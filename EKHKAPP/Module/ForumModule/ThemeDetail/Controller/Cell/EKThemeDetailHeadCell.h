//
//  EKThemeDetailHeadCell.h
//  EKHKAPP
//
//  Created by ligb on 2017/11/1.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThreadsDetailModel.h"

@protocol EKThemeDetailHeadCellDelegate <NSObject>
- (void)mThemeTypeHeadAction;
@end

@interface EKThemeDetailHeadCell : UITableViewCell

@property (nonatomic, weak) id <EKThemeDetailHeadCellDelegate> delegate;

- (void)uploadHeadListData:(ThreadsDetailModel *)data;

@end
