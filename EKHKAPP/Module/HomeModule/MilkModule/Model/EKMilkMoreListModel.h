/**
 -  EKMilkMoreListModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/29.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是BKMilk界面,后台返回的列表数据
 */

#import <Foundation/Foundation.h>

@interface EKMilkMoreListModel : NSObject
@property (nonatomic, copy) NSString *class_name;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, copy) NSString *view;
@property (nonatomic, copy) NSString *dateline;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *username;

//扩展参数，标示广告数据和普通数据 @"ad"代表广告   @"normal"普通的单元格
@property (nonatomic, copy) NSString    *type;
@property (nonatomic, strong) id        data;  //存储广告数据


/**
 请求

 @param tabid 顶部横向标签的id
 @param callBack 网络请求回调
 */
+ (void)mRequestMilkMoreListDataWithTabid:(NSString *)tabid
                                     page:(NSInteger)page
                                 callBack:(void(^)(NSString *netErr, NSArray <EKMilkMoreListModel *> *data))callBack;

@end
