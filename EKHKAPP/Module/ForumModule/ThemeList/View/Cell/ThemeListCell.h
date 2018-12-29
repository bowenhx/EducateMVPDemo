/**
 -  ThemeListCell.h
 -  BKHKAPP
 -  Created by HY on 2017/8/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：主题列表的cell
 */

#import <UIKit/UIKit.h>
#import "BKThemeListModel.h"
#import "BKThemeListForumModel.h"

//cell 固定高度
static CGFloat THEMELISTCELLHEIGHT = 70;

@protocol ThemeListCellDelegate;

@interface ThemeListCell : UITableViewCell

@property (nonatomic, assign) id <ThemeListCellDelegate> delegate;

//标题label
@property (weak, nonatomic) IBOutlet UILabel *vSubjectLabel;

//作者
@property (weak, nonatomic) IBOutlet UILabel *vAuthorLabel;

//时间
@property (weak, nonatomic) IBOutlet UILabel *vTimeLabel;

//最后评论的人名
@property (weak, nonatomic) IBOutlet UILabel *vLastPostNameLabel;

//回复总数
@property (weak, nonatomic) IBOutlet UILabel *vRepliesLabel;

//区分置顶帖和普通帖的中间线
@property (weak, nonatomic) IBOutlet UIView *vLineView;

/**
 刷新主题列表的cell
 
 @param model 当前cell需要的数据源
 @param nextListModel 下一个cell的数据源，使用他来对比数据，显示置顶帖和普通帖的分割线
 @param isAllType 布尔值，yes时候，代表全部板块，判断要不要添加置顶帖子分割线的显示逻辑，no不做判断
 @param forumModel 头部板块的数据，使用model中数据来判断用户的管理权限
 @param indexPath 当前cell的indexPath
 */
- (void)mRefreshThemeListCell:(BKThemeListModel *)model isAllType:(BOOL)isAllType nextListModel:(BKThemeListModel *)nextListModel forumModel:(BKThemeListForumModel *)forumModel indexPath:(NSIndexPath *)indexPath;

@end



#pragma mark - ThemeListCellDelegate

@protocol ThemeListCellDelegate <NSObject>

- (void)mLongPressThemeListCell:(BKThemeListModel *)model;

@end

