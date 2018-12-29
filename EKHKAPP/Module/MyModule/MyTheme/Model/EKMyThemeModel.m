/**
 -  EKMyThemeModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/25.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
-  说明:这是"我的主题"&"我的回复"的后台字段model,这两个界面使用的URL不一样,但是后台返回的字段一样
 */

#import "EKMyThemeModel.h"

@implementation EKMyThemeModel

+ (void)mRequestMyThemeDataSourceWithType:(EKMyThemeModelType)type
                                     page:(NSInteger)page
                                      uid:(NSString *)uid
                                 callBack:(void(^)(NSString *netErr, NSArray <EKMyThemeModel *> *data))callBack {
    NSDictionary *parameter = @{@"token" : TOKEN,
                                @"uid" : (uid ? uid : @""),
                                @"page" : @(page)};
    NSArray *URLArray = @[kUserMyTopicURL, kUserMyReplyURL];
    [EKHttpUtil mHttpWithUrl:URLArray[type]
                   parameter:parameter
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (netErr) {
                            callBack(netErr, nil);
                        } else {
                            if (1 == model.status) {
                                if (model.data && [model.data isKindOfClass:[NSArray class]]) {
                                    NSMutableArray <EKMyThemeModel *> *tempArray = [NSMutableArray array];
                                    for (NSDictionary *dictionary in model.data) {
                                        [tempArray addObject:[EKMyThemeModel yy_modelWithDictionary:dictionary]];
                                    }
                                    callBack(nil, tempArray.copy);
                                }
                            } else {
                                callBack(model.message, nil);
                            }
                        }
                    }];
}


- (NSString *)description {
    return [self yy_modelDescription];
}
@end
