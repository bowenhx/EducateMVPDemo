/**
 -  EKHomeVoteOptionsModel.h
 -  EKHKAPP
 -  Created by ligb on 2017/9/20.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：
 */

#import <Foundation/Foundation.h>

@interface EKHomeVoteOptionsModel : NSObject
@property (nonatomic, copy) NSString * polloption;
@property (nonatomic, copy) NSString * color;
@property (nonatomic, assign) NSInteger polloptionid;
@property (nonatomic, assign) NSInteger  votes;
@property (nonatomic, copy) NSString * width;
@property (nonatomic, copy) NSString * percent;
@property (nonatomic, copy) NSString * displayorder;
@property (nonatomic, assign) BOOL myselect;


+ (BOOL)mIsSelectedValue:(NSNumber *)value withForInSet:(NSArray *)array;
@end
