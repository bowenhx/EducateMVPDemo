/**
 -  BlogListModel.h
 -  EKHKAPP
 -  Created by HY on 2017/9/7.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：某一个分类下的，日志列表模型
 */

#import <Foundation/Foundation.h>

static NSString *NOT_DATA_MESSAGE = @"沒有更多數據";

@interface BlogListModel : NSObject

@property (nonatomic , copy) NSString *username;
@property (nonatomic , copy) NSString *avatar;
@property (nonatomic , copy) NSString *subject;
@property (nonatomic , copy) NSString *dateline;
@property (nonatomic , copy) NSString *message;

@property (nonatomic , assign) NSInteger catid;
@property (nonatomic , assign) NSInteger blogid;
@property (nonatomic , assign) NSInteger uid;
@property (nonatomic , assign) NSInteger viewnum;
@property (nonatomic , assign) NSInteger replynum;
@property (nonatomic , assign) NSInteger ispassword;
@property (nonatomic , assign) float vHeight;

/**
 请求“最新日志/推荐日志”列表

 @param catid 上方滑动view中，选中的item的catid
 @param order 当order = dateline 时，获取的是最新发布日志列表 当order = hot 时，获取的是推荐阅读日志列表
 @param page  页码
 @param block data为请求成功返回列表数据，netErr为错误信息
 */
+ (void)mRequestBlogListWithId:(NSString *)catid order:(NSString *)order page:(NSInteger)page block:(void(^) (NSArray *data , NSString *netErr))block;



+ (void)mRequestMyBlogListWithPage:(NSInteger)page block:(void(^) (NSArray *data , NSString *netErr))block;


@end
