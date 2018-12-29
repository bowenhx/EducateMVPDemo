/**
 -  FBInfoDataModel.h
 -  BKMobile
 -  Created by ligb on 2017/8/10.
 -  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
 -  说明：
 */

#import <Foundation/Foundation.h>
@class FBItemModel;

@interface FBInfoDataModel : NSObject

@property (nonatomic, copy) NSArray<FBItemModel*> * gender;
@property (nonatomic, copy) NSArray<FBItemModel*> * age;
@property (nonatomic, copy) NSArray<FBItemModel*> * pregnancy;
@property (nonatomic, copy) NSArray<FBItemModel*> * family;
@property (nonatomic, copy) NSArray<FBItemModel*> * child;
@property (nonatomic, copy) NSArray<FBItemModel*> * income;
@property (nonatomic, copy) NSArray<FBItemModel*> * category;

@property (nonatomic, copy) NSArray<FBItemModel*> * birthday_year;
@property (nonatomic, copy) NSArray<FBItemModel*> * birthday_month;

@property (nonatomic, copy) NSArray<FBItemModel*> * childitem_year;
@property (nonatomic, copy) NSArray<FBItemModel*> * childitem_month;
@property (nonatomic, copy) NSArray<FBItemModel*> * childitem_gender;
@property (nonatomic, copy) NSArray<FBItemModel*> * childitem_school;
@end


@interface FBItemModel : NSObject

@property (nonatomic, copy) NSString * value;
@property (nonatomic, copy) NSString * text;

@end
