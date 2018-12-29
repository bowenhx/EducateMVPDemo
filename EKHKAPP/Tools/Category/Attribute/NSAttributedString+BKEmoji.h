//
//  NSAttributedString+BKEmoji.h
//  BKMobile
//
//  Created by 薇 颜 on 15/7/13.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSAttributedString (BKEmoji)

+ (NSAttributedString *)emojiAttributedString:(NSString *)string withFont:(UIFont *)font;
@end
