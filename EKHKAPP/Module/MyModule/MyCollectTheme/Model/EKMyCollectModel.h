/**
 -  EKMyCollectModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/27.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是后台返回的"我的收藏"的model
 */

#import <Foundation/Foundation.h>

/**
 "我的收藏"的4种类型数据

 - EKMyCollectModelThread: 帖子
 - EKMyCollectModelForum: 板块
 - EKMyCollectModelGroup: 群组
 - EKMyCollectModelTypeAll: 所有
 */
typedef NS_ENUM(NSInteger, EKMyCollectModelType) {
    EKMyCollectModelTypeThread,
    EKMyCollectModelTypeForum,
    EKMyCollectModelTypeGroup,
    EKMyCollectModelTypeAll
};

@interface EKMyCollectModel : NSObject
@property (nonatomic, assign) NSInteger favid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *dateline;
@property (nonatomic, copy) NSString *fname;
@property (nonatomic, copy) NSString *replies;
@property (nonatomic, copy) NSString *views;
@property (nonatomic, copy) NSString *id;

/**
 请求"我的收藏"后台数据

 @param type "我的收藏"的4种类型数据
 @param page 页码参数
 @param callBack 完成回调
 */
+ (void)mRequestMyCollectModelDataSourceWithType:(EKMyCollectModelType)type
                                            page:(NSInteger)page
                                        callBack:(void(^)(NSString *netErr, NSArray <EKMyCollectModel *> *data))callBack;
@end
