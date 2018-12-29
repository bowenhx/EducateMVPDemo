//
//  NSString+MessageInputView.m
//  KiddieApp
//
//  Created by 颜 薇 on 14-10-14.
//  Copyright (c) 2014年 Mobile-kingdom.com. All rights reserved.
//

#import "NSString+MessageInputView.h"

@implementation NSString (MessageInputView)

- (NSString *)stringByTrimingWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSUInteger)numberOfLines {
    return [[self componentsSeparatedByString:@"\n"] count] + 1;
}

@end
