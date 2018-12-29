/**
 -  EKCornerSelectMenuButton.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/21.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是菜单选择视图的自定义button
 */

#import "EKCornerSelectMenuButton.h"

@implementation EKCornerSelectMenuButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


@end
