/**
 -  EKNoticeCell.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/3.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"消息提醒"界面的"提醒"cell
 */

#import <UIKit/UIKit.h>
#import "EKNoticeListModel.h"
//缓存标识符
static NSString *noticeCellID = @"EKNoticeCellID";
@interface EKNoticeCell : UITableViewCell
@property (nonatomic, strong) EKNoticeListModel *vNoticeListModel;
@end
