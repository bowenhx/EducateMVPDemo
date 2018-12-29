/**
 -  UIView+Inspectable.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/10.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:该UIView的分类,用于在xib中的侧边栏快速设置圆角/边框颜色/边框粗度等之前无法直接在侧边栏设置的属性,可提高开发效率
 */

#import "UIView+Inspectable.h"

@implementation UIView (Inspectable)
- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}


- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}


- (void)setMaskToBounds:(BOOL)maskToBounds {
    self.layer.masksToBounds = maskToBounds;
}


- (BOOL)maskToBounds {
    return self.layer.masksToBounds;
}


- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}


- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}


- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}


- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}


@end
