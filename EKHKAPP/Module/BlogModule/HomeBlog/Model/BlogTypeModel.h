/**
 -  BlogTypeModel.h
 -  EKHKAPP
 -  Created by HY on 2017/11/1.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：日志的所有小分类
 */

#import <Foundation/Foundation.h>

//存储日志类型小分类数组的key
static NSString *SAVE_BLOG_TYPE = @"saveBlogType";

@interface BlogTypeModel : NSObject <NSCoding>

@property (nonatomic , assign) NSInteger catid;
@property (nonatomic , copy) NSString *catname;


/**
 请求日志页面，所有的日志分类

 @param block 请求返回的数据，或错误信息
 */
+ (void)mRequestBlogTypeListBlock:(void(^) (NSArray *data , NSString *netErr))block;

@end
