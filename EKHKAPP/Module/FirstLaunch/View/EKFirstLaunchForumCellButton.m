/**
 -  EKFirstLaunchForumCellButton.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/14.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:"首次启动"界面的选择板块界面的cell里面的自定义button
 */

#import "EKFirstLaunchForumCellButton.h"

@implementation EKFirstLaunchForumCellButton
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundImage:[UIImage imageNamed:@"firsh_box_pressed"] forState:UIControlStateSelected];
    [self setBackgroundImage:[UIImage imageNamed:@"firsh_box_unpressed"] forState:UIControlStateNormal];
}

@end
