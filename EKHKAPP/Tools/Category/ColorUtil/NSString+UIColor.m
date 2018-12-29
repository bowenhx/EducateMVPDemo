/**
 -  NSString+UIColor.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/8.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:拓展字符串转换颜色的方法
 */

#import "NSString+UIColor.h"


#define DEFAULT_VOID_COLOR [UIColor blackColor]

@implementation NSString (UIColor)

/**
 根据NSString字符串获得UIColor
 
 @return 转化得到的UIColor对象
 */
- (UIColor *)color {
    //定义一个默认的颜色
    UIColor *defaultColor = [UIColor blackColor];
    //判断长度
    if (self.length < 6) {
        return defaultColor;
    }
    //去掉空格等其他字符
    NSString *cString = [[self stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] < 6 || [cString length] > 8) {
        return defaultColor;
    }

    
    static int COLOR_LENGTH = 4;
    // Alpha Red Green Blue
    unsigned int colorARGB[COLOR_LENGTH];
    for (int i = 0; i < 4; i++) {
        // 先初始化为所有都是255

        colorARGB[COLOR_LENGTH-i-1] = 255;
        

        colorARGB[COLOR_LENGTH - i - 1] = 255;

        // 根据子字符串进行数字转换
        NSString *subString = [cString substringFromIndex: cString.length < 2 ? 0 : cString.length - 2];
        cString = [cString substringToIndex:cString.length < 2 ? cString.length : cString.length - 2];
        if (subString.length) {

            [[NSScanner scannerWithString:subString] scanHexInt:&colorARGB[COLOR_LENGTH-i-1]];

            [[NSScanner scannerWithString:subString] scanHexInt:&colorARGB[COLOR_LENGTH - i - 1]];

        }
    }

    return [UIColor colorWithRed:((float) colorARGB[1] / 255.0f)
                           green:((float) colorARGB[2] / 255.0f)
                            blue:((float) colorARGB[3] / 255.0f)
                           alpha:((float) colorARGB[0] / 255.0f)];
}



@end




@implementation UIImage (ExImageColor)

- (CGFloat)w {
    return self.size.width;
}

- (CGFloat)h {
    return self.size.height;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end


