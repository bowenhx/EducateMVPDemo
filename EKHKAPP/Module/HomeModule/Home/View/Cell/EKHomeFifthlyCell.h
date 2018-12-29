//
//  EKHomeFifthlyCell.h
//  EKHKAPP
//
//  Created by ligb on 2017/9/15.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKHomeKMallModel.h"


@protocol EKHomeFifthlyCellDelegate;

@interface EKHomeFifthlyCell : UITableViewCell
@property (nonatomic, strong) NSArray <EKHomeKMallModel *> *vHomeKMallModelDataSource;
@property (nonatomic, weak) id <EKHomeFifthlyCellDelegate> delegate;
@end


@protocol EKHomeFifthlyCellDelegate <NSObject>
/**
 点击cell时候调用

 @param index 回传当前点击的cell的索引
 */
- (void)mCollectionViewDidClickItemWithIndex:(NSInteger)index;
@end
