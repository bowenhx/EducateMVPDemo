/**
 -  NSString+UIColor.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/8.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:拓展字符串转换颜色的方法
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 用于扩展NSString,转换UIColor
@interface NSString (UIColor)

// 获取由当前的NSString转换来的UIColor
- (UIColor*)color;

@end



@interface UIImage (ExImageColor)

@property (nonatomic, assign, readonly) CGFloat w;
@property (nonatomic, assign, readonly) CGFloat h;

+ (UIImage *)imageWithColor:(UIColor *)color;

@end



