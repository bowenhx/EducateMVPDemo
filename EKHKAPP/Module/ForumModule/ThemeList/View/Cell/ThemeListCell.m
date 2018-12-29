/**
 -  ThemeListCell.m
 -  BKHKAPP
 -  Created by HY on 2017/8/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "ThemeListCell.h"
#import "BKUserModel.h"
#import "EKADViewController.h"

@interface ThemeListCell () {
    BKThemeListModel *_mListModel;
}
@end

@implementation ThemeListCell


#pragma mark - 刷新cell操作
- (void)mRefreshThemeListCell:(BKThemeListModel *)model isAllType:(BOOL)isAllType nextListModel:(BKThemeListModel *)nextListModel forumModel:(BKThemeListForumModel *)forumModel indexPath:(NSIndexPath *)indexPath {
    
    _mListModel = model;
    
    //设置单元格背景色
    self.backgroundColor = [UIColor cellSpace:indexPath.row % 2];
    
    //赋值操作
    _vAuthorLabel.text = model.author;
    _vTimeLabel.text = model.lastpost;
    _vLastPostNameLabel.text = model.lastposter;
    _vRepliesLabel.text =[NSString stringWithFormat:@"%ld",(long)model.replies];
    _vSubjectLabel.attributedText = model.attributeString; //富文本

    //只有当前是“全部”板块的时候isAllType = YES，才会显示置顶帖的分割线
    //区分置顶帖和普通帖的中间线 displayorder = 0 是置顶帖子，非0是普通帖子，比较上一个数据和下一个数据的displayorder来判断
    if (isAllType == YES && model.displayorder != 0 && nextListModel.displayorder == 0 && nextListModel.type != kAD) {
        _vLineView.backgroundColor = [UIColor EKColorYellow];
        _vLineView.hidden = NO;
    } else {
        _vLineView.hidden = YES;
    }

    //管理权限判断
    if ([self mManagerLimits:forumModel] && _vAuthorLabel.text.length > 0) {
        //添加长按手势动作,显示管理权限
        UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mHandleLongPress:)];
        longPressReger.minimumPressDuration = 1.0;
        [self addGestureRecognizer:longPressReger];
    }
}


#pragma mark - 长按手势动作，弹出管理权限
- (void)mHandleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(mLongPressThemeListCell:)]) {
            [self.delegate mLongPressThemeListCell:_mListModel];
        }
    }
}


#pragma mark - 判断当前用户是否具有管理权限
- (BOOL)mManagerLimits:(BKThemeListForumModel *)forumModel {
     BKUserModel *model = [BKSaveUser mGetUser];
    //1.判断当前用户是否具有管理权限 2.移动主题权限判断 3.关闭或开启主题权限判断
    if (forumModel.ismoderator == model.groups.ismovethread.integerValue ==
        model.groups.isclosethread.integerValue == 1) {
        return YES;
    }
    return NO;
}

@end


