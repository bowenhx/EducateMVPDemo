/**
 -  EKFirstLaunchGradeViewController.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/13.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:"首次启动"界面的第一层界面,"选择年级"
 */

#import "EKBaseViewController.h"
#import "EKFirstLaunchListModel.h"

@protocol EKFirstLaunchGradeViewDelegate;

@interface EKFirstLaunchGradeView : UIView
@property (nonatomic, weak) id <EKFirstLaunchGradeViewDelegate> delegate;
@end

@protocol EKFirstLaunchGradeViewDelegate <NSObject>

/**
 点击选择年级界面的"下一步"按钮的时候调用

 @param listModel 回传pickerView当前选中的model
 */
- (void)mClickGradeNextStepButtonWithFirstLaunchListModel:(EKFirstLaunchListModel *)listModel;
@end
