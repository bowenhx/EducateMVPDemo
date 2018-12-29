/**
 -  UIButton+BackgroundImage.m
 -  EKHKAPP
 -  Created by ligb on 2017/9/12.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "UIButton+BackgroundImage.h"

@implementation UIButton (BackgroundImage)
- (void)updataBtnBackground {
    [self imageWithColor:[UIColor EKColorNavigation]];
}

- (void)imageWithColor:(UIColor *)color {
    [self setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateNormal];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4;
}
@end
