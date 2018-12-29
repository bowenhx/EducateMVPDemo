/**
 -  EKFirstLaunchListModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/13.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:"首次启动"界面后台返回的数据的list字段数组对应的model
 */

#import <Foundation/Foundation.h>
#import "EKFirstLaunchSubforumModel.h"

@interface EKFirstLaunchListModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *display;
@property (nonatomic, strong) NSMutableArray <EKFirstLaunchSubforumModel *> *subforums;
#pragma mark - 网络请求部分
/**
 请求"首次启动"后台数据

 @param callBack 网络请求回调
 */
+ (void)mRequestFirstLaunchDataWithCallBack:(void(^)(NSArray <EKFirstLaunchListModel *> *data, NSString *netErr))callBack;


#pragma mark - 本地数据处理部分
/**
 由于collectionView特殊的布局原因(1行2个,1行3个),所以需要对listModel的subforum数组进行处理,插入空的subforumModel来补齐最后一行的个数

 @return 设置好subforum字段个数的model
 */
- (instancetype)mAddEmptySubforumModelAndSetHidden;


/**
 将listModel转换为字典,并包装到数组里面,且过滤掉它的subforums数组中selected状态为NO的subforumModel,(如果用户没有选择任何的板块的话,还需要默认选中"使用意见")最后将数组保存到本地,以传递给侧滑视图
 
 @return 去除掉没有selected状态的subforumModel的listModel
 */
- (NSArray *)mChangeToArrayAndRemoveUnselectedForumModel;


@end
