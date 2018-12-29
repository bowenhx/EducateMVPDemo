/**
 -  EKMessageCell.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/3.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"消息提醒"界面的"消息"cell
 */

#import <UIKit/UIKit.h>
#import "EKMessageListModel.h"
//缓存标识符
static NSString *messageCellID = @"EKMessageCellID";
@interface EKMessageCell : UITableViewCell
@property (nonatomic, strong) EKMessageListModel *vMessageListModel;
@end
