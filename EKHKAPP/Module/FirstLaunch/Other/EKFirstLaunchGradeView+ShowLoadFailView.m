/**
 -  EKFirstLaunchGradeView+ShowLoadFailView.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/16.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:"首次启动"加载网络时,调用的显示/移除加载失败视图的方法
 */

#import "EKFirstLaunchGradeView+ShowLoadFailView.h"
#import "EKFirstLaunchFailView.h"

@implementation EKFirstLaunchGradeView (ShowLoadFailView)
/**
 显示"首次启动"加载失败视图
 
 @param retryDidClickCallBack 点击"重试"按钮时执行的回调
 */
- (void)mShowLoadFailViewWithRetryDidClickCallBack:(void(^)(void))retryDidClickCallBack {
    EKFirstLaunchFailView *failView = [[EKFirstLaunchFailView alloc] initWithFrame:self.bounds retryDidClickCallBack:retryDidClickCallBack];
    failView.vType = EKFirstLaunchFailViewTypeNotice;
    [self addSubview:failView];
}


/**
 移除"首次启动"加载失败视图
 */
- (void)mRemoveLoadFailView {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[EKFirstLaunchFailView class]]) {
            [obj removeFromSuperview];
        }
    }];
}

@end
