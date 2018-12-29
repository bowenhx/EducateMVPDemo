/**
 - BADModel.m
 - BADSdk
 - Created by HY on 2017/12/15.
 - Copyright © 2017年 BaByKingdom. All rights reserved.
 - 广告请求返回的model，广告的外层信息
 */

#import "BADModel.h"
#import "BADRequest.h"
#import "YYModel.h"
#import "BADConfig.h"

@implementation BADModel

+ (void)mRequestAdWithDic:(NSDictionary *)dicParameter
                    block:(void(^) (BADModel *adModel, NSString *netErr))block {
    //请求广告数据
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:const_BAD_REQUEST_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    if (dicParameter) {
        [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:dicParameter options:0 error:NULL]];
    }

    //发送请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil && data != nil) {
                NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                NSError *error = nil;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
                
                if ([json isKindOfClass:[NSDictionary class]]) {
                    NSInteger code = [json[@"statecode"] integerValue];
                    //解析数据
                    if (code == 200) {
                        
                        NSLog(@"打印后台返回的广告详细数据json = %@",json[@"result"]);
                        
                        BADModel *dataModel = [BADModel yy_modelWithDictionary:json[@"result"]];
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            block(dataModel,@"");
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            block(nil,@"error");
                        });
                        NSLog(@"后台返回一个错误 %@",json);
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

- (NSString *)description {
    return [self yy_modelDescription];
}
@end

