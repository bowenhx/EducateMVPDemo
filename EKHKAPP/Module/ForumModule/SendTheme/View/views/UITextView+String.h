//
//  UITextView+String.h
//  BKMobile
//
//  Created by ligb on 16/6/21.
//  Copyright © 2016年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "InvitationDataModel.h"

@interface UITextView (EX_TextView)

+ (NSString *)textMessage:(InvitationDataModel *)model;

@end
