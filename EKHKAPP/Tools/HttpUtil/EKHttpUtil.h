/**
 -  EKHttpUtil.h
 -  EKHKAPP
 -  Created by HY on 2017/9/7.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：EK使用的网络工具类中间层
 */

#import <Foundation/Foundation.h>

@interface EKHttpUtil : NSObject

/**
 BK所使用的网络请求入口
 
 @param url       请求地址，非空
 @param parameter 请求参数，如果为空
 @param block model，error，model代表数据
 */
+ (void)mHttpWithUrl:(NSString *)url
           parameter:(NSDictionary *)parameter
            response:(CompletionBlock)block;


/**
 上传图片

 @param URLString 地址
 @param parameter 参数
 @param image 图片
 @param percentBlock 进度回调
 @param completionBlock 完成回调
 */
+ (void)mUploadWithURLString:(NSString *)URLString
                   parameter:(NSDictionary *)parameter
                       image:(UIImage *)image
                percentBlock:(PrecentBlock)percentBlock
             completionBlock:(CompletionBlock)completionBlock;

@end
