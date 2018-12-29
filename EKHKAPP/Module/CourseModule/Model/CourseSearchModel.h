//
//  CourseSearchModel.h
//  EduKingdom
//
//  Created by HY on 16/7/8.
//  Copyright © 2016年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 该api用于获取课程搜索相关下拉列表选项值。
 其中
 category 对象为课程目录列表
 district 对象为看课程区域列表
 fee 对象为课程限额列表
 
 从2.2.0版本开始，新增下列
 
 business 对象为商业等级选项
 ages 对象为年龄选项列表
 */

@interface CourseSearchModel : BKNetworkModel

@property (nonatomic, copy) NSString *applyid;
@property (nonatomic, copy) NSString *courseid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *agegroup;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *fee;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *companyid;
@property (nonatomic, copy) NSString *lessons;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *joinmethod;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, copy) NSString *notes;
@property (nonatomic, copy) NSString *weburl;

//pageType=0或1  0代表课程搜索结果页面，1代表最新课程页面
+ (void)loadSearchResultData:(NSDictionary *)parameter pageType:(NSInteger)pageType block:(void(^)(NSArray *data,NSString *netErr))block;

@end


//课程搜索页面，三个选项卡数据
@interface CourseOptionModel : NSObject
@property (nonatomic, strong)NSArray *category;//课程目录列表
@property (nonatomic, strong)NSArray *district;//课程区域列表
@property (nonatomic, strong)NSArray *fee;//课程限额列表
@property (nonatomic, strong)NSArray *business;//商业等级列表
@property (nonatomic, strong)NSArray *ages;//年龄选项列表
+ (void)loadOptionResultData:(void(^)(CourseOptionModel *data,NSString *netErr))block;
@end


//课程搜索页面，三个选项卡中，课程目录和课程区域model
@interface CourseCategoryModel : BKNetworkModel
@property (nonatomic, assign)NSInteger  vId;
@property (nonatomic, assign)NSInteger  catid;
@property (nonatomic, copy)NSString     *name;
@property (nonatomic, strong)NSArray    *cs;
@property (nonatomic, copy)NSString     *value;
+ (void)loadDirectoryListResultData:(void(^)(NSArray *data,NSString *netErr))block;
@end


//课程搜索页面中，包括，fee课程限额列表，business商业等级选项，ages年龄选项列表
@interface CourseRestListModel : BKNetworkModel
@property (nonatomic, copy)NSString     *name;
@property (nonatomic, copy)NSString     *value;
@property (nonatomic, assign)NSInteger  vId;
@end



