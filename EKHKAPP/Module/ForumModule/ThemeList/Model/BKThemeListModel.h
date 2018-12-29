/**
 -  BKThemeListModel.h
 -  BKHKAPP
 -  Created by HY on 2017/8/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：
 */

#import <Foundation/Foundation.h>
#import "BKThemeListDataModel.h"

static NSString *NOTDATA = @"沒有更多數據";

@interface BKThemeListModel : NSObject

@property (nonatomic , assign) NSInteger tid;
@property (nonatomic , assign) NSInteger fid;
@property (nonatomic , assign) NSInteger authorid;
@property (nonatomic , assign) NSInteger views;
@property (nonatomic , assign) NSInteger heats;
@property (nonatomic , assign) NSInteger displayorder;
@property (nonatomic , assign) NSInteger replies;
@property (nonatomic , assign) NSInteger attachment;
@property (nonatomic , assign) NSInteger closed;
@property (nonatomic , assign) NSInteger digest;
@property (nonatomic , assign) NSInteger favid;
@property (nonatomic , assign) NSInteger isfavorite;
@property (nonatomic , assign) NSInteger isnew;
@property (nonatomic , assign) NSInteger weeknew;
@property (nonatomic , copy) NSString *author;
@property (nonatomic , copy) NSString *subject;
@property (nonatomic , copy) NSString *dateline;
@property (nonatomic , copy) NSString *lastpost;
@property (nonatomic , copy) NSString *lastposter;
@property (nonatomic , copy) NSString *folder;
@property (nonatomic , copy) NSString *icon;
@property (nonatomic , copy) NSString *color;
@property (nonatomic , copy) NSString *stamp;
@property (nonatomic , copy) NSDictionary *style;

//扩展参数，存储广告数据
@property (nonatomic, copy) NSString    *type; //@"ad"代表广告   @"normal"普通的单元格
@property (nonatomic, strong) id        data;  //存储广告数据

//扩展参数，处理主题列表中，图文显示的富文本
@property (nonatomic, strong) NSMutableAttributedString *attributeString;


/**
 请求主题列表页面数据
 
 @param page     分页请求使用的页码值，page从1开始
 @param fid      板块id
 @param order    order为排序过滤参数，默认为空获取全部，当order=dateline最新，当order=digest精华。
 @param typeId   板块下面有一横列可滑动的分类选项，分类id
 @param password 板块密码，加密板块需要该参数
 @param callBack 网络请求回调
 */
- (void)mRequestThemeListWithPage:(NSInteger)page fid:(NSString *)fid order:(NSString *)order typeId:(NSInteger)typeId password:(NSString *)password callBack:(void (^)(NSInteger status, BKThemeListDataModel *dataModel, NSString *error))callBack;

@end


