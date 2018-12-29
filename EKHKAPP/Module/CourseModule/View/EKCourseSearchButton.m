/**
 -  EKCourseSearchButton.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/19.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是自定义的"课程搜索"的"搜索"按钮
 */

#import "EKCourseSearchButton.h"

@implementation EKCourseSearchButton
- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = [UIColor EKColorButtonDarkBrown];
    } else {
        self.backgroundColor = [UIColor EKColorButtonLightBrown];
    }
}

@end
