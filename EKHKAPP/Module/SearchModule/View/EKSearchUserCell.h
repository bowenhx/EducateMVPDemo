/**
 -  EKSearchUserCell.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/22.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"搜寻论坛"界面的用户cell
 -  也用作"我的好友"界面cell
 */

#import "EKSearchBaseCell.h"
#import "EKFriendModel.h"
#import "EKSearchUserAddFriendButton.h"

@protocol EKSearchUserCellDelegate;

@interface EKSearchUserCell : EKSearchBaseCell
@property (nonatomic, weak) id <EKSearchUserCellDelegate> delegate;

//当用作"我的好友"界面cell的时候,使用这个model来传递UI参数
@property (nonatomic, strong) EKFriendModel *vFriendModel;

@property (weak, nonatomic) IBOutlet EKSearchUserAddFriendButton *vAddFriendButton;


@end




@protocol EKSearchUserCellDelegate <NSObject>
/**
 "加为好友"/"解除好友"按钮点击的时候调用

 @param cell 回传当前按钮所在的cell
 */
- (void)mSearchUserCellAddFriendButtonDidClickWithCell:(EKSearchUserCell *)cell;
@end
