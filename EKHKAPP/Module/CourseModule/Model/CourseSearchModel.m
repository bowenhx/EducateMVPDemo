//
//  CourseSearchModel.m
//  EduKingdom
//
//  Created by HY on 16/7/8.
//  Copyright © 2016年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import "CourseSearchModel.h"

@implementation CourseSearchModel


+ (void)loadSearchResultData:(NSDictionary *)parameter pageType:(NSInteger)pageType block:(void(^)(NSArray *data,NSString *netErr))block{
    
    //pageType=0或1  0代表课程搜索结果页面，1代表最新课程页面
    NSString *url = @"";
    if (pageType == 0) {
        url = kCourseSearchResultURL;
    } else {
        url = kCourseSearchNewestURL;
    }
    [EKHttpUtil mHttpWithUrl:url parameter:parameter response:^(BKNetworkModel *model, NSString *netErr) {
        if ( netErr ) {
            block ( nil , netErr );
        }else{
            if ( model.status == 1) {
                NSArray *arr = model.data;
                if ([arr isKindOfClass:[NSArray class]] && arr.count > 0){
                    block ([CourseSearchModel addObjData:model.data], nil);
                }else{
                    block (@[], nil); //请求成功，但是已经没有更多数据返回
                }
            }else{
                block ( nil , model.message);
            }
        }
    }];
}

+ (NSArray *)addObjData:(NSArray *)arr{
    NSMutableArray *arrData = [NSMutableArray arrayWithCapacity:arr.count];
    //便利数据生成model
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CourseSearchModel *model = [[CourseSearchModel alloc] init];
        [model setValuesForKeysWithDictionary:obj];
        [arrData addObject:model];
    }];
    return arrData;
}

@end


//////////////////////////三個選項列表數據///////////////////////////////////////
@implementation CourseOptionModel
- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];

    //课程目录列表
    if ([key isEqualToString:@"category"]) {
        NSArray *aArray = value;
        NSMutableArray *amArray = [NSMutableArray array];
        for (NSDictionary *dic in aArray)
        {
            CourseCategoryModel *m = [[CourseCategoryModel alloc] init];
            [m setValuesForKeysWithDictionary:dic];
            [amArray addObject:m];
        }
        self.category = amArray;
    }
    
    //课程区域列表
    if ([key isEqualToString:@"district"]) {
        NSArray *aArray = value;
        NSMutableArray *amArray = [NSMutableArray array];
        for (NSDictionary *dic in aArray)
        {
            CourseCategoryModel *m = [[CourseCategoryModel alloc] init];
            [m setValuesForKeysWithDictionary:dic];
            [amArray addObject:m];

        }
        self.district = amArray;
    }
    
    //课程限额列表
    if ([key isEqualToString:@"fee"]) {
        NSArray *aArray = value;
        NSMutableArray *amArray = [NSMutableArray array];
        for (NSDictionary *dic in aArray)
        {
            CourseRestListModel *restList = [[CourseRestListModel alloc] init];
            [restList setValuesForKeysWithDictionary:dic];
            [amArray addObject:restList];
            
        }
        self.fee = amArray;
    }
    
    //商业等级选项
    if ([key isEqualToString:@"business"]) {
        NSArray *aArray = value;
        NSMutableArray *amArray = [NSMutableArray array];
        for (NSDictionary *dic in aArray)
        {
            CourseRestListModel *restList = [[CourseRestListModel alloc] init];
            [restList setValuesForKeysWithDictionary:dic];
            [amArray addObject:restList];
            
        }
        self.business = amArray;
    }
    
    //年龄选项列表
    if ([key isEqualToString:@"ages"]) {
        NSArray *aArray = value;
        NSMutableArray *amArray = [NSMutableArray array];
        for (NSDictionary *dic in aArray)
        {
            CourseRestListModel *restList = [[CourseRestListModel alloc] init];
            [restList setValuesForKeysWithDictionary:dic];
            [amArray addObject:restList];
            
        }
        self.ages = amArray;
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%s",__func__);
}

+ (void)loadOptionResultData:(void(^)(CourseOptionModel *data,NSString *netErr))block{
    [EKHttpUtil mHttpWithUrl:kCourseSearchCourseURL parameter:nil response:^(BKNetworkModel *model, NSString *netErr) {
        if ( netErr ) {
            block ( nil , netErr );
        }else{
            if ( model.status == 1) {
                if ([model.data isKindOfClass:[NSDictionary class]]){
                    CourseOptionModel *option = [[CourseOptionModel alloc] init];
                    [option setValuesForKeysWithDictionary:model.data];
                    block (option, nil);
                   
                }
            }else{
                    block ( nil , model.message);
                }
        }
    }];
}


@end


//////////////////////////选项中小分类的模型、课程目录model///////////////////////////
@implementation CourseCategoryModel

- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    
    //课程目录列表
    if ([key isEqualToString:@"id"]) {
        self.vId = [value integerValue];
    }
}

//课程目录数据
+ (void)loadDirectoryListResultData:(void(^)(NSArray *data,NSString *netErr))block{
    [EKHttpUtil mHttpWithUrl:kCourseSearchCatalogURL parameter:nil response:^(BKNetworkModel *model, NSString *netErr) {
        if ( netErr ) {
            block ( nil , netErr );
        }else{
            if ( model.status == 1) {
                if ([model.data isKindOfClass:[NSArray class]]) {
                    block ([CourseCategoryModel addObjData:model.data], nil);
                }
            }else{
                block ( nil , model.message);
            }
        }
    }];
}

+ (NSArray *)addObjData:(NSArray *)arr{
    NSMutableArray *arrData = [NSMutableArray arrayWithCapacity:arr.count];
    //便利数据生成model
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CourseCategoryModel *model = [[CourseCategoryModel alloc] init];
        [model setValuesForKeysWithDictionary:obj];
        [arrData addObject:model];
    }];
    return arrData;
}

@end

@implementation CourseRestListModel

- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];

    if ([key isEqualToString:@"id"]) {
        self.vId = [value integerValue];
    }
}



@end

















