//
//  MessageBubbleFactory.m
//  BKMobile
//
//  Created by 薇 颜 on 15/7/1.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
//

#import "MessageBubbleFactory.h"

@implementation MessageBubbleFactory

+ (UIImage *)bubbleImageViewForType:(BubbleMessageType)type{
    NSString *messageTypeString = @"Chat_iv";
    UIEdgeInsets bubbleImageEdgeInsets;
    switch (type) {
        case BubbleMessageTypeSending:{
            // 发送
            messageTypeString = [messageTypeString stringByAppendingString:@"_right"];
            bubbleImageEdgeInsets = UIEdgeInsetsMake(25, 10, 10, 20);
            break;
        }
        case BubbleMessageTypeReceiving:{
            // 接收
            messageTypeString = [messageTypeString stringByAppendingString:@"_left"];
            bubbleImageEdgeInsets = UIEdgeInsetsMake(25, 20, 10, 10);
            break;
        }
        default:
            break;
    }
    UIImage *bublleImage = [UIImage imageNamed:messageTypeString];
    
    return [bublleImage resizableImageWithCapInsets:bubbleImageEdgeInsets resizingMode:UIImageResizingModeStretch];
}
@end
