/**
 -  EKHomeTopUpDownAdvertiseModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/19.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:"首页"置顶左侧上下广告后台model
 */

#import <Foundation/Foundation.h>

@interface EKHomeTopUpDownAdvertiseModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *fid;

/**
 请求"首页"置顶左侧上下广告后台数据

 @param callBack 网络请求回调
 */
+ (void)mRequestHomeTopUpDownAdvertiseDataWithCallBack:(void(^)(NSString *netErr, NSArray <EKHomeTopUpDownAdvertiseModel *>*data))callBack;
@end
