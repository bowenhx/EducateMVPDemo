/**
 -  BKLoopViewModel.h
 -  BKHKAPP
 -  Created by HY on 2017/8/16.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：首页头部滚动view的模型类
 */

#import <Foundation/Foundation.h>

@interface BKLoopViewModel : NSObject

@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *fid;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger residencetime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imgurl;
@property (nonatomic, copy) NSString *skipurl;


/**
 请求首页头部滑动视图数据
 
 @param callBack 回调滑动视图数据
 */
+ (void)mRequestLoopViewDataWithCallBack:(void (^)(NSArray <BKLoopViewModel *>*data))callBack;


@end
