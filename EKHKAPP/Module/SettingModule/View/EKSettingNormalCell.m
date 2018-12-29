/**
 -  EKSettingNormalCell.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/7.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"设置"界面的普通的带有箭头的cell
 */

#import "EKSettingNormalCell.h"

@implementation EKSettingNormalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

@end
