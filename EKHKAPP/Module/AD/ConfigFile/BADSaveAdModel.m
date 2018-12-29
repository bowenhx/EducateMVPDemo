/**
 - BADSaveAdModel.m
 - EKHKAPP
 - Created by HY on 2018/1/23.
 - Copyright © 2017年 BaByKingdom. All rights reserved.
 - 存储请求成功的广告数据，用于下次请求广告时候对比时间间隔，未超出时间间隔的广告id要发送给后台
 */

#import "BADSaveAdModel.h"

static NSString *adDB = @"saveBADModel.db";

@implementation BADSaveAdModel

#pragma mark - 保存广告信息
+ (void)mSaveAdModel:(BADDetailModel *)adModel {
    NSString *cachePath = [BKTool getDocumentsPath:adDB];
    NSMutableArray *adArray = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    if (adArray.count > 0) {
        [tempArray addObjectsFromArray:adArray];
    }
    [tempArray addObject:adModel];
    [NSKeyedArchiver archiveRootObject:tempArray toFile:cachePath]; //归档
}

#pragma mark - 获取广告信息
+ (NSMutableArray *)mGetAdModel {
    NSString *cachePath = [BKTool getDocumentsPath:adDB];
    NSMutableArray *adArray = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
    return adArray;
}

#pragma mark - 删除已经到时间的广告后，重新保存广告信息
+ (void)mUpdataAdModel:(NSMutableArray *)array {
    NSString *cachePath = [BKTool getDocumentsPath:adDB];
    [NSKeyedArchiver archiveRootObject:array toFile:cachePath]; //归档
}
@end
