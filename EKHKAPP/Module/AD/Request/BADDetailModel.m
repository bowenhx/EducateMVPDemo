/**
 - BADDetailModel.m
 - BADSdk
 - Created by HY on 2017/12/15.
 - Copyright © 2017年 BaByKingdom. All rights reserved.
 - 广告请求返回的model，一条广告的详细数据
 */

#import "BADDetailModel.h"

@implementation BADDetailModel

#pragma mark - 编码 对广告属性进行编码处理
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

#pragma mark - 解码 解码归档数据来初始化对象
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}


@end
