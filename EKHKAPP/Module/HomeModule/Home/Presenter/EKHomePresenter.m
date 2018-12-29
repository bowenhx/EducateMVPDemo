/**
 -  EKHomePresenter.m
 -  EKHKAPP
 -  Created by ligb on 2017/9/18.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "EKHomePresenter.h"

//广告的临时高度，具体高度由外层动态控制
static CGFloat tempHeight = 1;

@interface EKHomePresenter ()

@end

@implementation EKHomePresenter

- (NSArray *)vHeadHeight {
   
    //第一个cell，放置轮播滑动图的cell高度
    CGFloat cellHeight = [self.class mFirstCellHeight];

    //注释：第一个区的表尾，插入的是广告，第五区的表头插入的是广告
    
    if (!_vHeadHeight) {
        //定义5个区中 [表头的高度，cell高度]
        _vHeadHeight = @[
                         @[@(cellHeight), @65],
                         @[@44,  @100],
                         @[@100, @50],
                         @[@100, @44],
                         @[@(tempHeight), @159, @220]];
    }
    return _vHeadHeight;
}

- (NSArray *)vFootHeight {
    if (!_vFootHeight) {
        //定义5个区中,表尾的高度
        _vFootHeight = @[@(tempHeight), @1, @50, @50, @1];
    }
    return _vFootHeight;
}


#pragma mark - 首页第一个cell，放置：左边两个正方形view，右边是轮播滑动view

+ (CGFloat)mFirstCellHeight {
    
    /** 注：首页最上方左侧两个正方形，右侧轮播banner，轮播图片宽高比是1.375，下面是适配逻辑
     设计给的适配方案：
     @1X（320*480）             左 85 * 85            右 235 * 170
     @2X（750*1334）            左 200 * 200          右 550 * 400
     @3X（1242*2208）           左 332 * 332          右 910 * 664
     */
    
    //注意，这里的高度要和轮播图的高度保持一致

    CGFloat cellHeight;
    
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        //4,5,5s,5c,SE
        cellHeight = 170;
        
    } else if ([UIScreen mainScreen].bounds.size.width == 375) {
        //6,6s,7,8,x
        cellHeight = 200;
        
    } else if ([UIScreen mainScreen].bounds.size.width == 414) {
        //6p,6sp,7p,8p
        cellHeight = 221;
        
    } else  if (IS_IPAD) {
        //ipad，:由于EK，ipad不要求做详细适配，给出一个中间值
        cellHeight = 400;
        
    } else {
        //默认值，给出一个iphone的中间值 200
        cellHeight = 200;
    }
    
    return cellHeight;
}


@end
