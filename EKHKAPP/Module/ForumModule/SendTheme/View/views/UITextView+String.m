//
//  UITextView+String.m
//  BKMobile
//
//  Created by ligb on 16/6/21.
//  Copyright © 2016年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "UITextView+String.h"

@implementation UITextView (EX_TextView)
+ (NSString *)textMessage:(InvitationDataModel *)model{
    NSString *message = [NSString stringWithFormat:@"%@",model.message_tag];
   
    //判断是否有警告icon 单独去掉警告icon
    message = [message stringByReplacingOccurrencesOfString:@"[smiley]jinggaoicon[/smiley]" withString:@""];
    
    
    //去掉链接标签
    message = [message stringByReplacingOccurrencesOfString:@"[link]" withString:@""];
    message = [message stringByReplacingOccurrencesOfString:@"[/link]" withString:@""];

    
    //去掉图片标签
    message = [message stringByReplacingOccurrencesOfString:@"[img]" withString:@""];
    message = [message stringByReplacingOccurrencesOfString:@"[/img]" withString:@""];
    
   
   //去掉引用回复标签
    NSRange rangeQuo = [message rangeOfString:@"[quote]"];
    if ( rangeQuo.location != NSNotFound ) {
        message = [message substringToIndex:rangeQuo.location];
    }
    
    
    //去掉图片链接，并把图片显示到下面
    for (NSString *imageUrl in model.imgUrls) {
        message = [message stringByReplacingOccurrencesOfString:imageUrl withString:@""];
    }
   
   
    //去掉表情标签
    message = [message stringByReplacingOccurrencesOfString:@"[smiley]" withString:@""];
    message = [message stringByReplacingOccurrencesOfString:@"[/smiley]" withString:@""];
    
  
    //去掉表情链接，并把图片显示到下面
    for (NSDictionary *smileyItem in model.smileyInf) {
        message = [message stringByReplacingOccurrencesOfString:smileyItem[@"value"] withString:@""];
    }
    
    return message;
}
@end
