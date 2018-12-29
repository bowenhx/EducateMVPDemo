/**
 -  EKHomePresenter.h
 -  EKHKAPP
 -  Created by ligb on 2017/9/19.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：
 */

#import <Foundation/Foundation.h>

@interface EKHomePresenter : NSObject

//表头高度
@property (nonatomic, strong) NSArray *vHeadHeight;

//表尾高度
@property (nonatomic, strong) NSArray *vFootHeight;


/**
 首页第一个cell的高度，放置：左边两个小正方形，右边是轮播滑动view

 @return 返回一个根据设计图适配要求，计算出的高度
 */
+ (CGFloat)mFirstCellHeight;

@end
