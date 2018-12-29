/**
 -  EKFirstLaunchListModel.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/13.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:"首次启动"界面后台返回的数据的list字段数组对应的model
 */

#import "EKFirstLaunchListModel.h"
#import <AdSupport/AdSupport.h>

@implementation EKFirstLaunchListModel

#pragma mark - 网络请求部分
/**
 请求"首次启动"后台数据
 
 @param callBack 网络请求回调
 */
+ (void)mRequestFirstLaunchDataWithCallBack:(void(^)(NSArray <EKFirstLaunchListModel *> *data, NSString *netErr))callBack {
    //后台约定传个空值
    NSDictionary *parameter = @{@"token" : TOKEN};
    [EKHttpUtil mHttpWithUrl:kFirstLaunchURL
                   parameter:parameter
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (netErr) {
                            callBack(nil, netErr);
                        } else {
                            if (model.status) {
                                if (model.data && [model.data isKindOfClass:[NSDictionary class]]) {
                                    NSDictionary *firstLaucnhDict = model.data;
                                    id lists = firstLaucnhDict[@"lists"];
                                    if (lists && [lists isKindOfClass:[NSArray class]]) {
                                        NSMutableArray *tempArray = [NSMutableArray array];
                                        for (NSDictionary *dictionary in lists) {
                                            [tempArray addObject:[EKFirstLaunchListModel yy_modelWithDictionary:dictionary]];
                                        }
                                        callBack(tempArray.copy, nil);
                                    }
                                }
                            } else {
                                callBack(nil, model.message);
                            }
                        }
                    }];
}


#pragma mark - 本地数据处理部分
/**
 由于collectionView特殊的布局原因(1行2个,1行3个),所以需要对listModel的subforum数组进行处理,插入空的subforumModel来补齐最后一行的个数
 
 @return 设置好subforum字段个数的model
 */
- (instancetype)mAddEmptySubforumModelAndSetHidden {
    NSInteger count = self.subforums.count;
    NSInteger restCount = count % 5;
    NSInteger addCount = 0;
    if (restCount < 3) {
        addCount = 3 - restCount;
    } else {
        addCount = 5 - restCount;
    }
    
    //根据addCount,创建相等数量的subforumModel加入的当前模型的subforum数组中,且新生成的subforumModel的属性hidden得设置成NO,好让button隐藏
    for (NSInteger i = 0; i < addCount; i++) {
        EKFirstLaunchSubforumModel *subforumModel = [[EKFirstLaunchSubforumModel alloc] init];
        subforumModel.isHidden = YES;
        [self.subforums addObject:subforumModel];
    }
    return self;
}


/**
 将listModel转换为字典,并包装到数组里面,且过滤掉它的subforums数组中selected状态为NO的subforumModel,(如果用户没有选择任何的板块的话,还需要默认选中"使用意见")最后将数组保存到本地,以传递给侧滑视图
 
 @return 去除掉没有selected状态的subforumModel的listModel
 */
- (NSArray *)mChangeToArrayAndRemoveUnselectedForumModel {
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:@{@"name" : self.name,
                                                                                 @"fid" : self.fid,
                                                                                 @"key" : self.key,
                                                                                 @"display" : self.display}];
    
    NSMutableArray <NSDictionary *> *subforumArray = [NSMutableArray array];
    //该BOOL变量用来记录,用户是否没有选中任何喜爱板块. YES的话表示用户什么都没选,反之相反
    BOOL noSelectedSubforum = YES;
    
    //将用户选中的板块所对应的model转换为字典,并加入到数组中
    for (EKFirstLaunchSubforumModel *subforumModel in self.subforums) {
        if (subforumModel.isSelected) {
            NSDictionary *subforumDict = @{@"fid" : subforumModel.fid,
                                           @"type" : subforumModel.type,
                                           @"addCollect" : @YES,
                                           @"name" : subforumModel.name};
            [subforumArray addObject:subforumDict];
            //修改BOOL变量,记录用户有选择到喜爱的板块
            noSelectedSubforum = NO;
        }
    }
    //让后台统计用户的选择等信息
    [self mRecordWithSubforums:subforumArray];

    //如果用户没有选择任何板块的话,则默认存储"使用意见"板块作为默认板块
    if (noSelectedSubforum) {
        //遍历数组,将"使用意见"转换成字典并加入到数组中
        for (EKFirstLaunchSubforumModel *subforumModel in self.subforums) {
            if ([subforumModel.name isEqualToString:@"使用意見"]) {
                NSDictionary *subforumDict = @{@"fid" : subforumModel.fid,
                                               @"type" : subforumModel.type,
                                               @"addCollect" : @YES,
                                               @"name" : subforumModel.name};
                [subforumArray addObject:subforumDict];
            }
        }
    }
    
    [mDict setValue:subforumArray forKey:@"subforums"];
    
    //由于侧滑栏需要的是数组,所以这里把字典放入到数组中再传出去
    NSArray *mDictArray = @[mDict];
    
    return mDictArray;
}


/**
 内部使用的方法,让后台统计用户的选择等信息

 @param subforumArray 用户选择的板块字典数组
 */
- (void)mRecordWithSubforums:(NSMutableArray <NSDictionary *>*)subforumArray {
    //准备参数
    //1.年级名称
    NSString *levelname = self.name;
    
    //2.获取版块名称
    //拼接版块名称字符串
    NSMutableString *fnames = [NSMutableString stringWithFormat:@""];
    for (NSInteger i = 0; i < subforumArray.count; i++) {
        [fnames appendString:[NSString stringWithFormat:@"%@,", subforumArray[i][@"name"]]];
    }
    //去掉最后的逗号
    if ([fnames hasSuffix:@","]) {
        NSRange deleteRange = {[fnames length] - 1, 1};
        [fnames deleteCharactersInRange:deleteRange];
    }
    
    //3.获取手机型号
    NSString *mobile = [BKTool getDeviceName];
    
    //4.获取系统版本
    NSString *sys_ver = [[UIDevice currentDevice] systemVersion];
    
    //5.获取deviceID
    NSString *device_id = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    //6.获取 是否是iPad
    BOOL ispad = IS_IPAD;
    
    NSDictionary *parameter = @{@"levelname" : levelname,
                                @"fnames" : fnames,
                                @"mobile" : mobile,
                                @"sys_ver" : sys_ver,
                                @"device_id" : device_id,
                                @"ispad" : @(ispad)};
    //发送给后台.成功/失败,不处理
    [EKHttpUtil mHttpWithUrl:kFirstLaunchRecordURL
                   parameter:parameter
                    response:nil];
}


#pragma mark - 其他
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"subforums" : [EKFirstLaunchSubforumModel class]};
}


- (NSString *)description {
    return [self yy_modelDescription];
}
@end
