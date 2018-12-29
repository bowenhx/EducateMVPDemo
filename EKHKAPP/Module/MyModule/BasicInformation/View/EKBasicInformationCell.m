/**
 -  EKBasicInformationCell.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/30.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"用户基本资料"界面的cell
 */

#import "EKBasicInformationCell.h"

@implementation EKBasicInformationCell
//重写构造方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
    }
    return self;
}

@end
