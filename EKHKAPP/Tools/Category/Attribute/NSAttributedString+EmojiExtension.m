//
// Created by zorro on 15/3/7.
// Copyright (c) 2015 tutuge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAttributedString+EmojiExtension.h"
#import "EmojiTextAttachment.h"

@implementation NSAttributedString (EmojiExtension)

- (NSString *)getPlainString:(NSArray *)items {
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    __block NSInteger  index = 0;
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      if (value && [value isKindOfClass:[EmojiTextAttachment class]]) {
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:((EmojiTextAttachment *) value).emojiTag];
                          base += ((EmojiTextAttachment *) value).emojiTag.length - 1;
                      }else if (items.count && [value isKindOfClass:[NSTextAttachment class]])
                      {
                          NSString *strItem = items[index][@"value"];
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:strItem];
                          base += strItem.length - 1;
                          index ++;

                      }
                      
                  }];
    
    return plainString;
}

@end