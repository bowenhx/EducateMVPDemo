/**
 -  EKFirstLaunchFailView.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/16.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"首次启动"界面加载后台数据失败时显示的界面.只会在"选择年级"的界面出现,因为网络请求是这个界面发起的
 */

#import <UIKit/UIKit.h>

/**
 "首次启动"loading失败界面的两种形态

 - EKFirstLaunchFailViewTypeNotice: 显示"当前没有网路服务 请重试"
 - EKFirstLaunchFailViewTypeLoading: 显示loading菊花动画
 */
typedef NS_ENUM(NSInteger, EKFirstLaunchFailViewType) {
    EKFirstLaunchFailViewTypeNotice,
    EKFirstLaunchFailViewTypeLoading
};

@interface EKFirstLaunchFailView : UIView
/**
 自定义构造方法

 @param frame 位置尺寸
 @param retryDidClickCallBack 点击"重试"时候执行的回调
 @return "首次启动"loading失败界面
 */
- (instancetype)initWithFrame:(CGRect)frame retryDidClickCallBack:(void(^)(void))retryDidClickCallBack;
//"首次启动"loading失败界面的形态
@property (nonatomic, assign) EKFirstLaunchFailViewType vType;
@end

