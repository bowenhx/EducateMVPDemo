/**
 -  EKSchoolBigAreaModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/12.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:后台返回的学校区域字段
 */

#import "EKSchoolBigAreaModel.h"

@implementation EKSchoolBigAreaModel

/**
 请求学校区域后台数据
 
 @param callBack 网络请求回调
 */
+ (void)mRequestSchoolAreaDataWithCallBack:(void(^)(NSArray <EKSchoolBigAreaModel *> *data , NSString *netErr))callBack {
    NSDictionary *parameter = @{@"token" : TOKEN};
    [EKHttpUtil mHttpWithUrl:kSchoolListURL
                   parameter:parameter
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (netErr) {
                            callBack(nil, netErr);
                        } else {
                            if (model.status) {
                                if (model.data && [model.data isKindOfClass:[NSArray class]]) {
                                    NSMutableArray *tempArray = [NSMutableArray array];
                                    for (NSDictionary *dictionary in model.data) {
                                        [tempArray addObject:[EKSchoolBigAreaModel yy_modelWithDictionary:dictionary]];
                                    }
                                    [self mFillDataSource:tempArray];
                                    callBack(tempArray.copy, nil);
                                }
                            } else {
                                callBack(nil, model.message);
                            }
                        }
                    }];
}


/**
 UI效果图呈现出来的时候,如果model个数不是偶数,需要在组里最后一个cell显示空白,所以该方法填充多了1model进数据源数组

 @param dataSource 数据源数组
 */
+ (void)mFillDataSource:(NSMutableArray *)dataSource {
    for (EKSchoolBigAreaModel *bigAreaModel in dataSource) {
        //默认将后台返回的model的控制cell交互的字段设置为YES
        for (EKSchoolSmallAreaModel *smallAreaModel in bigAreaModel.areas) {
            smallAreaModel.vUserInteractEnable = YES;
        }
        //如果后台返回的小区域model不是偶数,则需要补全一个空白的model进入,以达到空白cell的效果
        if (bigAreaModel.areas.count % 2) {
            EKSchoolSmallAreaModel *smallAreaModel = [[EKSchoolSmallAreaModel alloc] init];
            //让这个空白的cell不可交互
            smallAreaModel.vUserInteractEnable = NO;
            smallAreaModel.name = @"";
            [bigAreaModel.areas addObject:smallAreaModel];
        }
    }
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"areas" : [EKSchoolSmallAreaModel class]};
}


- (NSString *)description {
    return [self yy_modelDescription];
}
@end
