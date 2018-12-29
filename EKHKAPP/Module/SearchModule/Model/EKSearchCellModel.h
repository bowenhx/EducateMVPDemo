/**
 -  EKSearchCellModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/22.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"搜索"模块的用来管理cell信息的自定义本地model
 */

#import <Foundation/Foundation.h>
//论坛cell的缓存标识符
static NSString * searchForumCellID = @"EKSearchForumCellID";
//用户cell的缓存标识符
static NSString * searchUserCellID = @"EKSearchUserCellID";
/**
 搜索的类型
 
 - EKSearchTypeForum: 论坛类型
 - EKSearchTypeUser: 用户类型
 */
typedef NS_ENUM(NSInteger, EKSearchType) {
    EKSearchTypeForum = 0,
    EKSearchTypeUser
};

@interface EKSearchCellModel : NSObject
//重用标识符
@property (nonatomic, copy) NSString *vReuseIdentifier;
//行高
@property (nonatomic, assign) CGFloat vRowHeight;
//点击时调用的方法名
@property (nonatomic, copy) NSString *vSelectorName;
//后台返回的UI信息model
@property (nonatomic, strong) id vModel;

/**
 请求cell的model
 
 @param type 搜索类型
 @param text 搜索框文字内容
 @param page page参数
 @param callBack 网络请求回调
 */
+ (void)mRequestSearchCellModelArrayWithType:(EKSearchType)type
                              withSearchText:(NSString *)text
                                    withPage:(NSInteger)page
                                withCallBack:(void(^)(NSString *netErr, NSArray <EKSearchCellModel *>*searchCellModelArray, NSString *message))callBack;

@end
