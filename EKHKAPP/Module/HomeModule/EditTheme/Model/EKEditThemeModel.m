//
//  EKEditThemeModel.m
//  EKHKAPP
//
//  Created by ligb on 2017/9/30.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import "EKEditThemeModel.h"

static int themeFid = 322;

@implementation EKEditThemeModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"subforums" : [EKThemeSubforumsModel class]};
}

+ (void)mLoadThemeList:(void (^)(NSArray<EKEditThemeModel *> *data , NSString *netErr))block {
    [EKHttpUtil mHttpWithUrl:kForumListURL
                   parameter:@{@"token": TOKEN}
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (netErr) {
                            block(nil, netErr);
                        } else {
                            if (1 == model.status) {
                                id array = model.data[@"lists"];
                                if (array && [array isKindOfClass:[NSArray class]]) {
                                    NSMutableArray <EKEditThemeModel *> *tempArray = [NSMutableArray array];
                                    for (NSDictionary *dictionary in array) {
                                        [tempArray addObject:[EKEditThemeModel yy_modelWithDictionary:dictionary]];
                                    }
                                    
                                    if (!LOGINSTATUS) {
                                        //如果本地有缓存收藏数据处理
                                        NSArray *array = [BKSaveData getArray:kPreferForumInfoKey];
                                        [array enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
                                            [tempArray enumerateObjectsUsingBlock:^(EKEditThemeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                //查看是否有默认选项
                                                NSArray *subforums = dict[@"subforums"];
                                                [subforums enumerateObjectsUsingBlock:^(NSDictionary *subforumDic, NSUInteger idx, BOOL * _Nonnull stop) {
                                                    if ([subforumDic[@"addCollect"] boolValue]) {
                                                        [obj.subforums enumerateObjectsUsingBlock:^(EKThemeSubforumsModel * _Nonnull objModel, NSUInteger idx, BOOL * _Nonnull stop) {
                                                            if ([subforumDic[@"fid"] integerValue] == objModel.fid) {
                                                                objModel.favid = 1;
                                                            }
                                                        }];
                                                    }
                                                }];
                                            }];
                                        }];
                                    }
                                     block(tempArray, nil);
                                }
                            } else {
                                block( nil, model.message);
                            }
                        }
                    }];
}

+ (void)collectItemModel:(EKThemeSubforumsModel *)themeModel updata:(void(^)(void))bolck  {
    if (themeModel.favid) {
        //取消收藏
        NSDictionary *para = @{@"token": TOKEN,
                               @"favid": @(themeModel.favid)};
        [EKHttpUtil mHttpWithUrl:kUserCancelCollectURL parameter:para response:^(BKNetworkModel *model, NSString *netErr) {
            if (1 == model.status) {
                themeModel.favid = 0;
                bolck();
            }
        }];
    } else {
        //加入收藏
        NSDictionary *para = @{@"token": TOKEN,
                               @"type": @"forum",
                               @"id": @(themeModel.fid)};

        [EKHttpUtil mHttpWithUrl:kUserAddCollectURL parameter:para response:^(BKNetworkModel *model, NSString *netErr) {
            if (1 == model.status) {
                //"favid"在取消收藏的时候会用到
                themeModel.favid = [model.data[@"favid"] integerValue];
                bolck();

            } else {
                
            }
        }];
    }
}


+ (void)cacheCollectItemModel:(EKThemeSubforumsModel *)model themeModel:(EKEditThemeModel *)themeModel {
    NSMutableArray *array = [NSMutableArray arrayWithArray:[BKSaveData getArray:kPreferForumInfoKey]];
    BOOL isAdd = YES;//添加收藏
    if (model.favid) {
        //取消收藏
        isAdd = NO;
        model.favid = 0;
    } else {
        model.favid = 1;
    }
    
    if (array.count) {
        //本地有缓存需要修改本地缓存
        __block BOOL isReplace = NO;
        NSMutableArray *tempItem = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *favDic = [NSMutableDictionary dictionaryWithDictionary:obj];
            if (isAdd) {
                //添加收藏
                if ([favDic[@"fid"] integerValue] == themeModel.fid) {
                    [tempItem setArray:favDic[@"subforums"]];
                    for (int i = 0; i< tempItem.count; i++) {
                        NSDictionary *dict = tempItem[i];
                        if ([dict[@"fid"] integerValue] == model.fid) {
                            [tempItem removeObject:dict];
                            break;
                        }
                    }
                    [tempItem addObject:[self addCollectSubData:model isAdd:isAdd]];
                    favDic[@"subforums"] = tempItem;
                    [array replaceObjectAtIndex:idx withObject:favDic];
                    isReplace = YES;
                }
            } else {//取消收藏： 这里区分首次进入默认选择感兴趣的分类，默认分类不必判断一级fid，但是需要判断二级fid
                if (idx == 0 || (!isReplace && [favDic[@"fid"] integerValue] == themeModel.fid)) {
                    [tempItem setArray:favDic[@"subforums"]];
                    for (int i = 0; i< tempItem.count; i++) {
                        NSDictionary *dict = tempItem[i];
                        //判断二级分类fid
                        if ([dict[@"fid"] integerValue] == model.fid) {
                            [tempItem removeObject:dict];
                            isReplace = YES;
                            break;
                        }
                    }
                    if (isReplace) {
                        if (tempItem.count) {
                            favDic[@"subforums"] = tempItem;
                            [array replaceObjectAtIndex:idx withObject:favDic];
                        } else {
                            [array removeObjectAtIndex:idx];
                        }
                    }
                }
            }
        }];
        
        if (!isReplace) {
            [array addObject:[self addCollectData:themeModel subModel:model isAdd:isAdd]];
        }
    } else {
        //直接添加
        [array addObject:[self addCollectData:themeModel subModel:model isAdd:isAdd]];
    }
    [BKSaveData setArray:array key:kPreferForumInfoKey];
}


+ (NSDictionary *)addCollectData:(EKEditThemeModel *)themeModel subModel:(EKThemeSubforumsModel *)model isAdd:(BOOL)isAdd{
    return @{@"fid": @(themeModel.fid),
             @"name": themeModel.name,
             @"subforums": @[[self addCollectSubData:model isAdd:isAdd]]
             };
}

+ (NSDictionary *)addCollectSubData:(EKThemeSubforumsModel *)model isAdd:(BOOL)isAdd {
    return @{ @"name": model.name,
              @"icon": model.icon,
              @"fid": @(model.fid),
              @"favid": @(model.favid),
              @"addCollect":@(isAdd)
              };
}

+ (void)synchronizationCollectData {
    NSArray *array = [BKSaveData getArray:kPreferForumInfoKey];
    for (int i = 0; i< array.count; i++) {
        NSArray *subData = array[i][@"subforums"];
        for (int j =0; j< subData.count; j++) {
            NSDictionary *dict = subData[j];
            [self stratSynchronication:dict];
        }
    }
}

+ (void)stratSynchronication:(NSDictionary *)dict {
    //加入收藏
    NSDictionary *para = @{@"token": TOKEN,
                           @"type": @"forum",
                           @"id": dict[@"fid"]};
    
    [EKHttpUtil mHttpWithUrl:kUserAddCollectURL parameter:para response:^(BKNetworkModel *model, NSString *netErr) {
        if (1 == model.status) {
            
        } else {
            NSLog(@"同步收藏出错了");
        }
    }];
}


- (NSString *)description {
    return [self yy_modelDescription];
}

@end
