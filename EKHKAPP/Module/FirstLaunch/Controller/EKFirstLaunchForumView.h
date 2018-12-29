/**
 -  EKFirstLaunchForumViewController.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/13.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:"首次启动"界面的第二层界面,选择感兴趣的板块
 */

#import "EKBaseViewController.h"
#import "EKFirstLaunchListModel.h"

@protocol EKFirstLaunchForumViewDelegate;

@interface EKFirstLaunchForumView : UIView
@property (nonatomic, strong) EKFirstLaunchListModel *vListModel;
@property (nonatomic, weak) id <EKFirstLaunchForumViewDelegate> delegate;
@end

@protocol EKFirstLaunchForumViewDelegate <NSObject>
//点击"选择版块"视图的"下一步"按钮的时候调用
- (void)mClickForumViewNextStepButton;
@end
