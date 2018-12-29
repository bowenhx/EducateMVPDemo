/**
 -  EKHomeListModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/19.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:"首页"四个列表的后台数据(论坛话题列表/bk milk文章列表/tv数据列表/kmall产品列表)
 */

#import <Foundation/Foundation.h>
#import "EKHomeThreadModel.h"
#import "EKHomeMilkModel.h"
#import "EKHomeTVModel.h"
#import "EKHomeKMallModel.h"

@interface EKHomeListModel : NSObject
@property (nonatomic, strong) NSArray <EKHomeThreadModel *> *thread;
@property (nonatomic, strong) NSArray <EKHomeMilkModel *> *milk;
@property (nonatomic, strong) NSArray <EKHomeTVModel *> *tv;
@property (nonatomic, strong) NSArray <EKHomeKMallModel *> *kmall;


/**
 请求"首页"四个列表的数据(论坛话题列表/bk milk文章列表/tv数据列表/kmall产品列表)

 @param tabID 横向标签栏按钮的id
 @param callBack 网络请求回调
 */
+ (void)mRequestHomeListDataWithTabID:(NSString *)tabID
                             callBack:(void(^)(NSString *netErr, EKHomeListModel *homeListModel))callBack;

@end
