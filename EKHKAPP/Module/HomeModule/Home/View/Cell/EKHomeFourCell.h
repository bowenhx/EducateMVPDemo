//
//  EKHomeFourCell.h
//  EKHKAPP
//
//  Created by ligb on 2017/9/18.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKHomeTVModel.h"

@protocol EKHomeFourCellDelegate;


@interface EKHomeFourCell : UITableViewCell
//后台返回的UI信息
@property (nonatomic, strong) NSArray <EKHomeTVModel *> *vHomeTVModelDataSource;
//代理对象
@property (nonatomic, weak) id <EKHomeFourCellDelegate> delegate;
@end

@protocol EKHomeFourCellDelegate <NSObject>
/**
 点击"播放"按钮的时候调用

 @param index 回传"播放"按钮的下标
 */
- (void)mHomeFourCellButtonDidClickWithIndex:(NSInteger)index;
@end
