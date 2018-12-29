/**
 -  EKBasicInformationModel.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/30.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是后台返回的用户资本资料model
 */

#import "EKBasicInformationModel.h"

@implementation EKBasicInformationModel
/**
 请求当前登录用户的基本资料数组model
 
 @param callBack 完成回调
 */
+ (void)mRequestBasicInformationModelWithCallBack:(void(^)(NSString *netErr, EKBasicInformationModel *basicInformationModel))callBack {
    //uid为空时,默认请求的是当前登录用户的基本资料
    [self mRequestFriendBasicInformationModelWithUid:@"" callBack:callBack];
}


/**
 请求某个好友的基本资料
 
 @param uid 好友的id
 @param callBack 完成回调
 */
+ (void)mRequestFriendBasicInformationModelWithUid:(NSString *)uid
                                          callBack:(void(^)(NSString *netErr, EKBasicInformationModel *friendBasicInformationModel))callBack {
    NSDictionary *parameter = @{@"token" : TOKEN,
                                @"uid" : uid};
    [EKHttpUtil mHttpWithUrl:kUserInformationURL
                   parameter:parameter
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (netErr) {
                            callBack(netErr, nil);
                        } else {
                            if (model.data && [model.data isKindOfClass:[NSDictionary class]]) {
                                NSDictionary *dataDictionary = model.data;
                                EKBasicInformationModel *basicInformationModel = [EKBasicInformationModel yy_modelWithDictionary:dataDictionary];
                                callBack(nil, basicInformationModel);
                            } else {
                                callBack(model.message, nil);
                            }
                        }
                    }];
}


/**
 将基本资料model转换成文字数组,供"基本资料"界面使用
 
 @return 基本资料文字数组
 */
- (NSArray <NSString *> *)mChangeBasicInformationModelToArray {
    return @[USER.username,
             self.sex,
             self.pregnancy,
             self.prebabydata,
             self.livearea];
}


/**
 获取本地生成的用户的"基本资料"界面的表格数组
 
 @return 本地生成的用户的"基本资料"界面的表格数组
 */
+ (NSArray <NSString *> *)mGetInformationViewControllerTextArray {
    return @[@"用戶名",
             @"性別",
             @"懷孕狀況",
             @"預產期/已有最小寶寶出生日",
             @"居住地區"];
}
@end
