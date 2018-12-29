/**
 -  BKSelectPageView.h
 -  BKHKAPP
 -  Created by HY on 2017/8/30.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：主题列表页面和主题详情页面，使用到的选择页数弹出view
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol BKSelectPageViewDelegate;

@interface BKSelectPageView : UIView

@property (nonatomic, weak) id <BKSelectPageViewDelegate> delegate;

/**
 实例化该自定义view

 @return 返回改BKSelectPageView
 */
+(BKSelectPageView *)mGetInstance;


/**
 弹出选择页数view

 @param currentPage 当前加载的是第几页
 @param totalPage 总页数
 */
- (void)mShowViewWithCurrentPage:(NSInteger)currentPage totalPage:(NSInteger)totalPage;

@end




#pragma mark - 代理方法

@protocol BKSelectPageViewDelegate <NSObject>

/**
 点击滑动主题分类中的一个按钮
 
 @param error 判断填写的页码是否正确，如果error不为空，外部弹出error信息，如果为空代表页码正确，外部刷新页面
 @param page  当前用户填写的页码
 */
- (void)mTouchFinishBtnOfSelectPageViewWithError:(NSString *)error  page:(NSInteger)page;
@end
