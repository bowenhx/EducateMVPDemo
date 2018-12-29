//
//  Message.m
//  BKMobile
//
//  Created by ligb on 17/05/16.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
//

#import "Message.h"
#import "AppDelegate.h"
#import "NSAttributedString+BKEmoji.h"

 NSString * const linkDefault = @"http://www.edu-kingdom.com/static/image/smiley/default/";

@implementation Message

- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];

    if ([key isEqualToString:@"message"]) {
        NSString *content = value;
        content = [content stringByReplacingOccurrencesOfString:@"[img]" withString:@"[smiley]"];
        content = [content stringByReplacingOccurrencesOfString:@"[/img]" withString:@"[/smiley]"];
        content = [content stringByReplacingOccurrencesOfString:linkDefault withString:@""];
        self.message = content;
        
        [self calculateCellHeightWithMessage:content block:^(CGFloat height, NSAttributedString *attstirng) {
            self.cellHeight = height;
            self.attributeString = attstirng;
        }];
    }
    
}


/**
 计算cell高度

 @param message 消息对象
 @param block 时间是否显示
 */
- (void)calculateCellHeightWithMessage:(NSString *)message block:(void(^)(CGFloat height, NSAttributedString *attstirng))block{
    CGFloat cellHeight = 0.f;
    
    NSAttributedString *attrString = [NSAttributedString emojiAttributedString:message withFont:[UIFont systemFontOfSize:20.0]];
    
    CGFloat windowWidth = [[UIScreen mainScreen] bounds].size.width;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    CGRect rect = [attrString boundingRectWithSize:CGSizeMake(windowWidth-90, 2000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    cellHeight = rect.size.height + 60.0;
    
    block(cellHeight, attrString);
}






- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}



@end
