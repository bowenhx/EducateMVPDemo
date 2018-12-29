/**
 -  EKMyReplyCell.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/25.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"我的主题"界面的"回复"cell
 */

#import <UIKit/UIKit.h>
#import "EKMyThemeModel.h"

//缓存标识符
static NSString *myReplyCellID = @"EKMyReplyCellID";

@interface EKMyReplyCell : UITableViewCell
@property (nonatomic, strong) EKMyThemeModel *vMyThemeModel;
@end
