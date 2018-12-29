/**
 -  EKSchoolListCell.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/12.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:"学校列表"的cell
 */

#import <UIKit/UIKit.h>
#import "EKSchoolListModel.h"

@interface EKSchoolListCell : UITableViewCell
@property (nonatomic, strong) EKSchoolListModel *vSchoolListModel;
@property (nonatomic, strong) NSIndexPath *vIndexPath;
@end
