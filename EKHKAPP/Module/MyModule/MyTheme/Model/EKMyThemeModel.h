/**
 -  EKMyThemeModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/25.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"我的主题"&"我的回复"的后台字段model,这两个界面使用的URL不一样,但是后台返回的字段一样
 */

#import <Foundation/Foundation.h>

/**
 "我的主题"或"我的回复"

 - EKMyThemeModelTypeTheme: 我的主题
 - EKMyThemeModelTypeReply: 我的回复
 */
typedef NS_ENUM(NSInteger, EKMyThemeModelType) {
    EKMyThemeModelTypeTheme,
    EKMyThemeModelTypeReply
};

@interface EKMyThemeModel : NSObject
@property (nonatomic, assign) NSInteger tid;
@property (nonatomic, assign) NSInteger fid;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *fname;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *authorid;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *dateline;
@property (nonatomic, copy) NSString *lastpost;
@property (nonatomic, copy) NSString *lastposter;
@property (nonatomic, copy) NSString *views;
@property (nonatomic, copy) NSString *replies;
@property (nonatomic, copy) NSString *pages;
@property (nonatomic, copy) NSString *folder;
@property (nonatomic, copy) NSString *isnew;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *weeknew;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *favid;
@property (nonatomic, copy) NSString *isfavorite;
@property (nonatomic, copy) NSString *viewthread;

/**
 请求"我的主题"或者"我的回复"数据

 @param type 数据类型
 @param page 页码
 @param uid 用户id
 @param callBack 成功回调
 */
+ (void)mRequestMyThemeDataSourceWithType:(EKMyThemeModelType)type
                                     page:(NSInteger)page
                                      uid:(NSString *)uid
                                 callBack:(void(^)(NSString *netErr, NSArray <EKMyThemeModel *> *data))callBack;

@end
