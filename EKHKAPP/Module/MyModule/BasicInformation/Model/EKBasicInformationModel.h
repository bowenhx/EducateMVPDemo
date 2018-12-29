/**
 -  EKBasicInformationModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/30.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是后台返回的用户资本资料model
 */

#import <Foundation/Foundation.h>

@interface EKBasicInformationModel : NSObject
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *pregnancy;
@property (nonatomic, copy) NSString *prebabydata;
@property (nonatomic, copy) NSString *livearea;
@property (nonatomic, copy) NSString *credits;
@property (nonatomic, copy) NSString *group;
@property (nonatomic, copy) NSString *recentnote;
@property (nonatomic, copy) NSString *threads;
@property (nonatomic, copy) NSString *weburl;
@property (nonatomic, copy) NSString *isfriend;
/**
 请求当前登录用户的基本资料数组model

 @param callBack 完成回调
 */
+ (void)mRequestBasicInformationModelWithCallBack:(void(^)(NSString *netErr, EKBasicInformationModel *basicInformationModel))callBack;


/**
 请求某个好友的基本资料

 @param uid 好友的id
 @param callBack 完成回调
 */
+ (void)mRequestFriendBasicInformationModelWithUid:(NSString *)uid
                                          callBack:(void(^)(NSString *netErr, EKBasicInformationModel *friendBasicInformationModel))callBack;


/**
 将基本资料model转换成文字数组,供"基本资料"界面使用
 
 @return 基本资料文字数组
 */
- (NSArray <NSString *> *)mChangeBasicInformationModelToArray;


/**
 获取本地生成的用户的"基本资料"界面的表格数组

 @return 本地生成的用户的"基本资料"界面的表格数组
 */
+ (NSArray <NSString *> *)mGetInformationViewControllerTextArray;
@end
