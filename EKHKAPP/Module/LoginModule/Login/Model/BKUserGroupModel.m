/**
 -  BKUserGroupModel.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:user对象的groups字段
 */

#import "BKUserGroupModel.h"

@implementation BKUserGroupModel
- (NSString *)description {
    return [self yy_modelDescription];
}

#pragma mark - 编码 对user属性进行编码处理
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

#pragma mark - 解码 解码归档数据来初始化对象
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}


@end
