/**
 -  EKFirstLaunchGradePickerLabel.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/13.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是选择年级界面的pickerView的自定义单个view视图
 */

#import "EKFirstLaunchGradePickerLabel.h"

@implementation EKFirstLaunchGradePickerLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont boldSystemFontOfSize:42];
    }
    return self;
}

@end
