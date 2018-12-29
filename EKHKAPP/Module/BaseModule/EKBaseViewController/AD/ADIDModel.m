//
//  ADIDModel.m
//  EKHKAPP
//
//  Created by HY on 2018/3/15.
//  Copyright © 2018年 BaByKingdom. All rights reserved.
//

#import "ADIDModel.h"

@implementation ADIDModel

#pragma mark - 编码 对user属性进行编码处理
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

#pragma mark - 解码 解码归档数据来初始化对象
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}


#pragma mark - 请求广告id和页面索引值
- (void)mRequestAdID:(void(^)(NSArray <ADIDModel *> *adArray))block {
    
    //如果本地已经存储有请求到的id数据，不再重新请求
    NSString *cachePath = [BKTool getDocumentsPath:const_SAVE_ADID];
    NSArray *idArray = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
    
    if (idArray.count > 0) {
        block (idArray);
        return;
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:const_ADID_REQUEST_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    
    //发送请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil && data != nil) {
                NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                NSError *error = nil;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
                NSLog(@"后台返回广告id数据 = %@",json[@"result"]);
                
                if ([json isKindOfClass:[NSDictionary class]]) {
                    NSInteger code = [json[@"statecode"] integerValue];
                    //解析数据
                    if (code == 200) {
                        NSArray *result = json[@"result"];
                        NSMutableArray <ADIDModel *> *tempArray = [NSMutableArray array];
                        if (result && [result isKindOfClass:[NSArray class]]) {
                            for (NSDictionary *dictionary in result) {
                                ADIDModel *idModel = [ADIDModel yy_modelWithDictionary:dictionary];
                                [tempArray addObject:idModel];
                            }
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                block(tempArray);
                            });
                            
                            //本地存储广告id数组，不再重新请求
                            [NSKeyedArchiver archiveRootObject:tempArray toFile:cachePath]; //归档
                        
                        }
                        
                    } else {
                        NSLog(@"后台返回一个错误 %s",__func__);
                    }
                } else {
                    NSLog(@"打印非正常约定格式的返回数据 = %@",result);
                }
            } else {
                NSLog(@"打印error: %@",error.localizedDescription);
            }
        }] resume];
    });
}

@end
