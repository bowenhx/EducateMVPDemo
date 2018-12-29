//
//  MessageBubbleFactory.h
//  BKMobile
//
//  Created by 薇 颜 on 15/7/1.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, BubbleMessageType) {
    BubbleMessageTypeSending = 0,
    BubbleMessageTypeReceiving
};

@interface MessageBubbleFactory : NSObject

+ (UIImage *)bubbleImageViewForType:(BubbleMessageType)type;
@end
