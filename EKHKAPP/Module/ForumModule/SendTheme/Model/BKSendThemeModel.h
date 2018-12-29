/**
 -  BKSendThemeModel.h
 -  BKHKAPP
 -  Created by ligb on 2017/8/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：
 */

#import <UIKit/UIKit.h>
#import "BKReportModel.h"


@interface BKSendThemeModel : NSObject

/**
 获取举报理由数据
 
 @param block 返回举报理由模型数据
 */
- (void)getReportMessage:(void(^)(NSArray <BKReportModel *>*array))block;


/**
 举报帖子

 @param url url
 @param params 参数
 @param handler 回调
 */
- (void)mSendReportURL:(NSString *)url
                params:(NSDictionary *)params
               handler:(void(^)(NSString *message, BOOL status))handler;


/**
 发布主题

 @param params 参数
 @param files 图片文件
 @param precentblock 发送进度
 @param block 回调
 */
- (void)mSendThemeURL:(NSString *)url
                param:(NSDictionary *)params
                files:(NSArray *)files
              precent:(void(^)(float precent))precentblock
                block:(void(^)(BKNetworkModel *model, NSString *netErr))block;

@end
