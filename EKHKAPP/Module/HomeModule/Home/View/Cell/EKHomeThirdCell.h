//
//  EKHomeThirdCell.h
//  EKHKAPP
//
//  Created by stray s on 2017/9/18.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKHomeVoteOptionsModel.h"

@protocol EKHomeVoteDelegate <NSObject>

- (void)mVoteSelectIndex:(NSInteger)index isSelected:(BOOL)selected;

@end

@interface EKHomeThirdCell : UITableViewCell

@property (nonatomic, weak) id <EKHomeVoteDelegate> delegate;
- (void)mUpdata:(EKHomeVoteOptionsModel *)model selectSet:(NSArray *)array duration:(BOOL)duration;

@end
