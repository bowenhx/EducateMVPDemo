/**
 -  EKMyThemeCell.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/25.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"我的主题"界面的"主题"cell."主题收藏"界面也用到了
 */

#import <UIKit/UIKit.h>
#import "EKMyThemeModel.h"
#import "EKMyCollectModel.h"

//缓存标识符
static NSString *myThemeCellID = @"EKMyThemeCellID";

@interface EKMyThemeCell : UITableViewCell
//作为"我的主题"的cell时传递这个model
@property (nonatomic, strong) EKMyThemeModel *vMyThemeModel;
//作为"主题收藏"的cell时传递这个model
@property (nonatomic, strong) EKMyCollectModel *vMyCollectModel;
@end
