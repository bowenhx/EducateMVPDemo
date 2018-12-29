/**
 -  UIView+Inspectable.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/10.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:该UIView的分类,用于在xib中的侧边栏快速设置圆角/边框颜色/边框粗度等之前无法直接在侧边栏设置的属性,可提高开发效率
 */

#import <UIKit/UIKit.h>

@interface UIView (Inspectable)
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable BOOL maskToBounds;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@end
