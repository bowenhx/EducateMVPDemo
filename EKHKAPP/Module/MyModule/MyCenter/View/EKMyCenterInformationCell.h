/**
 -  EKMyCenterInformationCell.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/23.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"个人中心"最上面的显示用户信息的cell
 */

#import <UIKit/UIKit.h>
#import "EKMyCenterBaseCell.h"
//缓存标识符
static NSString *myCenterInformationCellID = @"EKMyCenterInformationCellID";

@interface EKMyCenterInformationCell : EKMyCenterBaseCell
@property (weak, nonatomic) IBOutlet UIButton *vAvatarButton;
@end
