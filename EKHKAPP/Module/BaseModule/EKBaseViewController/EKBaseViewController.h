/**
 -  EKBaseViewController.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/8.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:EK项目的基类viewController文件
 */

#import <UIKit/UIKit.h>

@interface EKBaseViewController : UIViewController

//导航栏右侧按钮，对应touch方法“mTouchRightBarButton”
@property (nonatomic , strong) UIButton *vRightBarButton;
@property (nonatomic , strong) UIButton *vBackBarButton;
@property (nonatomic, strong) UIView *navLeftView;


/**
 初始化UI
 */
- (void)mInitUI;


/**
 初始化数据
 */
- (void)mInitData;


/**
 导航栏左侧返回按钮的点击方法
 */
- (void)mTouchBackBarButton;


/**
 导航栏右侧按钮的点击方法
 */
- (void)mTouchRightBarButton;


/**
 进入下一级页面（控制器）

 @param name 类名(传入类名字符串)
 @param params 需要传入的参数，没有传nil，在对应的页面实现- (void)setParames:(NSDictionary *)parames 方法即可
 @param isPush 是否是push （可以是push 或者present）
 */
- (void)showNextViewControllerName:(NSString *)name params:(NSDictionary *)params isPush:(BOOL)isPush;



#pragma mark - 统计
/**
 将统计需要的关键词和参数字典,发送给后台
 
 @param pageIndex     统计对应的页面索引
 @param googleString  google统计需要的字符串
 @param parameter     umeng统计&用户追踪需要的参数字典
 */
- (void)mAddAnalyticsWithPageIndex:(NSString *)pageIndex googleString:(NSString *)googleString parameter:(NSDictionary *)parameter;
@end
