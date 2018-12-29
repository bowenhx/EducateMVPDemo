/**
 -  BKThemeListHeaderCell.h
 -  BKHKAPP
 -  Created by HY on 2017/8/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：主题列表页面，头部的板块信息view
 */

#import <UIKit/UIKit.h>
#import "BKThemeListForumModel.h"
#import "BKThemeMenuModel.h"

//不含有滑动menuView的cell高度
#define kThemeListForumHeight 80;

//该板块下有很多主题时候，要显示滑动分类menu，cell总高度
#define kThemeListForumHeight_ShowMenu  115;

/**
 主题列表页面类型,决定着这个view的UI显示，一种是从板块进入，一种特殊的是从群组进入该页面
 */
typedef NS_ENUM(NSInteger, BKThemeListViewControllerType){
    BKThemeListViewController_Forum,  //从讨论区板块，进入主题列表
    BKThemeListViewController_Group,  //从群组进入主题列表
};

@protocol BKThemeListHeaderCellDelegate;

@interface BKThemeListHeaderCell : UITableViewCell

@property (nonatomic, weak) id <BKThemeListHeaderCellDelegate> delegate;

//当前表的索引值，因为主题列表页面有三个表
@property (nonatomic, assign) NSInteger vCurrentTableIndex;

@property (nonatomic, strong) BKThemeListForumModel *vForumModel;

//版主按钮
@property (weak, nonatomic) IBOutlet UIButton *vMemberButton;

/**
 刷新主题列表页面，头部的板块信息view

 @param model 板块信息模型
 @param viewType 两种类型，代表从板块进入的该页面还是从群组进入的该页面
 */
- (void)mRefreshForumHeadCell:(BKThemeListForumModel *)model viewType:(BKThemeListViewControllerType)viewType selectClassIndex:(NSInteger)selectClassIndex;

@end



#pragma mark - 头部view代理
@protocol BKThemeListHeaderCellDelegate <NSObject>

/**
 点击滑动主题分类中的一个按钮
 
 @param model 当前点击的按钮的model
 @param tableIndex 当前表的索引值，由于有三个表，要分别记录分别刷新
 @param selectClassIndex 当前选中的小分类的索引值
 */
- (void)mTouchSlideThemeMenuWithModel:(BKThemeMenuModel *)model tableIndex:(NSInteger)tableIndex selectClassIndex:(NSInteger)selectClassIndex;


/**
 点击版主，进入个人资料页面

 @param model 数据源
 */
- (void)mTouchForumModeratorClick:(BKThemeListForumModel *)model;


/**
 如果没有登录，点击收藏，则跳转到登录页面
 */
- (void)mTouchCollectBtnWithNotLogin;


@end


