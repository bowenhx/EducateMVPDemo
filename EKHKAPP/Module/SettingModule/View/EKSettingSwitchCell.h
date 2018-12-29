/**
 -  EKSettingSwitchCell.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/7.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"设置"界面的第0个具有开关的cell
 */

#import <UIKit/UIKit.h>

@protocol EKSettingSwitchCellDelegate;

//缓存标识符
static NSString *settingSwitchCellID = @"EKSettingSwitchCellID";
@interface EKSettingSwitchCell : UITableViewCell
//设置switch控件的状态
@property (nonatomic, assign) BOOL vIsSwitchOn;
//代理对象
@property (nonatomic, weak) id <EKSettingSwitchCellDelegate> vDelegate;
@end


@protocol EKSettingSwitchCellDelegate <NSObject>
//回传开关的开关值
- (void)mSettingSwitchCellSwitchIsOn:(BOOL)isOn;
@end
