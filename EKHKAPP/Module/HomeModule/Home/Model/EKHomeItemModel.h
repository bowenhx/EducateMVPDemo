/**
 -  EKHomeItemModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/19.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:"首页"顶部横向标签栏对应的后台model数据
 */

#import <Foundation/Foundation.h>

@interface EKHomeItemModel : NSObject
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *label;

/**
 请求后台横向标签数据

 @param callBack 网络请求回调
 */
+ (void)mRequestHomeItemDataWithCallBack:(void(^)(NSString *netErr, NSArray<EKHomeItemModel *>*homeItemDataSource))callBack;


@end
