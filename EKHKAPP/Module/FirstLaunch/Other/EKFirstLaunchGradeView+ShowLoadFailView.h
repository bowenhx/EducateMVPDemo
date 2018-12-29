/**
 -  EKFirstLaunchGradeView+ShowLoadFailView.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/16.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:"首次启动"加载网络时,调用的显示/移除加载失败视图的方法
 */

#import "EKFirstLaunchGradeView.h"

@interface EKFirstLaunchGradeView (ShowLoadFailView)

/**
 显示"首次启动"加载失败视图

 @param retryDidClickCallBack 点击"重试"按钮时执行的回调
 */
- (void)mShowLoadFailViewWithRetryDidClickCallBack:(void(^)(void))retryDidClickCallBack;


/**
 移除"首次启动"加载失败视图
 */
- (void)mRemoveLoadFailView;
@end
