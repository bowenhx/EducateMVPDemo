//
//  NSAttributedString+BKEmoji.m
//  BKMobile
//
//  Created by 薇 颜 on 15/7/13.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "NSAttributedString+BKEmoji.h"
#import "BKFaceManage.h"

@implementation NSAttributedString (BKEmoji)


+ (NSAttributedString *)emojiAttributedString:(NSString *)string withFont:(UIFont *)font
{
    NSMutableAttributedString *parsedOutput = [[NSMutableAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName : font}];
    //表情格式  aaaaa[smilies]:xxx:[/smilies]
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[smiley\\](.*?)\\[\\/smiley\\]" options:0 error:nil];
    NSArray* matches = [regex matchesInString:[parsedOutput string]
                                      options:NSMatchingWithoutAnchoringBounds
                                        range:NSMakeRange(0, parsedOutput.length)];
    
    
    
    // Make emoji the same size as text
    CGSize emojiSize = CGSizeMake(font.lineHeight, font.lineHeight);
    
    for (NSTextCheckingResult* result in [matches reverseObjectEnumerator]) {
        NSRange matchRange = [result range];
        
        // Find emoji images by placeholder
        NSString *placeholder = [parsedOutput.string substringWithRange:matchRange];
        NSString *smileyCode  = [NSAttributedString getSmiliesKeyWithSmiliesCode:placeholder];
        UIImage *emojiImage = [[BKFaceManage sharedInstance] mCoreImageRuleMate:smileyCode];
        
        // Resize Emoji Image
        UIGraphicsBeginImageContextWithOptions(emojiSize, NO, 0.0);
        [emojiImage drawInRect:CGRectMake(0, 0, emojiSize.width, emojiSize.height)];
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSTextAttachment *textAttachment = [NSTextAttachment new];
        textAttachment.image = resizedImage;
        
        // Replace placeholder with image
        NSAttributedString *rep = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [parsedOutput replaceCharactersInRange:matchRange withAttributedString:rep];
    }
    return [[NSAttributedString alloc]initWithAttributedString:parsedOutput];
}

+ (NSString *)getSmiliesKeyWithSmiliesCode:(NSString *)code{
    NSString *smiliesKey = [code stringByReplacingOccurrencesOfString:@"[smiley]" withString:@""];
    smiliesKey = [smiliesKey stringByReplacingOccurrencesOfString:@"[/smiley]" withString:@""];
    
    return smiliesKey;
}
@end
