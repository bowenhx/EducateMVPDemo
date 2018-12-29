/**
 -  EKHomeActivityEventModel.h
 -  EKHKAPP
 -  Created by ligb on 2017/9/20.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：
 */

#import <Foundation/Foundation.h>

@interface EKHomeActivityEventModel : NSObject

@property (nonatomic , copy) NSString *name;
@property (nonatomic , copy) NSString *aDescription;
@property (nonatomic , copy) NSString *detail;
@property (nonatomic , copy) NSString *start_date;
@property (nonatomic , copy) NSString *end_date;
@property (nonatomic , copy) NSString *img;
@property (nonatomic , copy) NSString *created;
@property (nonatomic , copy) NSString *modified;
@property (nonatomic , copy) NSString *index_id;
@property (nonatomic , copy) NSString *status;
@property (nonatomic, copy) NSString *weburl;

@end
