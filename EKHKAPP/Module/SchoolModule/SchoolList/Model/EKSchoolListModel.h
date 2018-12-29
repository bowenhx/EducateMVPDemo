/**
 -  EKSchoolListModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/12.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:后台返回的"学校列表"的model
 */

#import <Foundation/Foundation.h>

@interface EKSchoolListModel : NSObject
@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *fname;

/**
 请求后台返回的"学校列表"的model数组

 @param areaID 区域id
 @param callBack 请求回调
 */
+ (void)mRequestSchoolListModelDataWithAreaID:(NSString *)areaID
                                     CallBack:(void(^)(NSArray <EKSchoolListModel *> *data, NSString *netErr))callBack;


/**
 根据关键字从后台获取学校列表的model数组

 @param keyword 关键字
 @param callBack 请求回调
 */
+ (void)mRequestSchoolListModelDataWithKeyword:(NSString *)keyword
                                      callBack:(void(^)(NSArray <EKSchoolListModel *> *data, NSString *netErr))callBack;
@end
