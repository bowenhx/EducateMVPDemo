//
//  EKThemeDetailViewController+Network.h
//  BKMobile
//
//  Created by HY on 16/6/17.
//  Copyright © 2016年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "EKThemeDetailViewController.h"

@interface EKThemeDetailViewController (Network)
- (void)loadDataSource; //请求列表数据
- (void)uniteLoadData;
- (void)floorLocation:(NSInteger)pid; //楼层定位
- (void)cancelCollectClick:(UIButton *)btn; //取消收藏
- (void)addCollectClick:(UIButton *)btn; //添加收藏
@end
