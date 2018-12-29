/**
 -  EKSchoolAreaCollectionHeaderView.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/12.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"学校"界面的collectionView的组头视图
 */

#import <UIKit/UIKit.h>
#import "EKSchoolBigAreaModel.h"

@protocol EKSchoolAreaCollectionHeaderViewDelegate;

@interface EKSchoolAreaCollectionHeaderView : UICollectionReusableView
@property (nonatomic, strong) EKSchoolBigAreaModel *vSchoolBigAreaModel;
@property (nonatomic, weak) id <EKSchoolAreaCollectionHeaderViewDelegate> delegate;
@end

@protocol EKSchoolAreaCollectionHeaderViewDelegate <NSObject>
//组头视图被触摸时调用
- (void)mSchoolAreaCollectionHeaderViewDidTouch;
@end
