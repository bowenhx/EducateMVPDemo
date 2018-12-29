/**
 - BADSaveAdModel.h
 - EKHKAPP
 - Created by HY on 2018/1/23.
 - Copyright © 2017年 BaByKingdom. All rights reserved.
 - 存储请求成功的广告数据，用于下次请求广告时候对比时间间隔，未超出时间间隔的广告id要发送给后台
 */

#import <Foundation/Foundation.h>
#import "BADDetailModel.h"

@interface BADSaveAdModel : NSObject


/**
 *  @brief  ##使用NSKeyedArchiver的归档，保存广告信息
 *
 *  @param  adModel  需要存储的用户对象
 */
+ (void)mSaveAdModel:(BADDetailModel *)adModel;


/**
 *  @brief  ##获取本地存储的广告对象数组
 *
 *  @return 返回广告对象数组
 */
+ (NSMutableArray *)mGetAdModel;


/**
 更新本地保存的未超出时间间隔广告

 @param array 删除超出时间间隔的广告数据后，新的需要保存的广告数组
 */
+ (void)mUpdataAdModel:(NSMutableArray *)array;


@end
