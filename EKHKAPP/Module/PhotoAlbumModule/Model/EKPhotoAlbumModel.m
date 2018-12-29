/**
 -  EKPhotoAlbumModel.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/1.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是后台返回的"相册"数据
 */

#import "EKPhotoAlbumModel.h"

@implementation EKPhotoAlbumModel
+ (void)mRequestPhotoAlbumDataWithUserID:(NSString *)userID
                                callBack:(void (^)(NSString *netErr, NSArray<EKPhotoAlbumModel *> *data))callBack {
    NSDictionary *parameter = nil;
    //如果有传入userID,表明请求的不是目前登录用户自己的用户相册.是自己的相册的话,不用给后台传uid
    if (userID) {
        parameter = @{@"token" : TOKEN,
                      @"view" : @"me",
                      @"uid" : userID};
    } else {
        parameter = @{@"token" : TOKEN,
                      @"view" : @"me"};
    }
    [EKHttpUtil mHttpWithUrl:kPhotoAlbumURL
                   parameter:parameter
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (netErr) {
                            callBack(netErr, nil);
                        } else {
                            if (1 == model.status) {
                                if (model.data && [model.data isKindOfClass:[NSArray class]]) {
                                    NSMutableArray <EKPhotoAlbumModel *> *tempArray = [NSMutableArray array];
                                    for (NSDictionary *dictionary in model.data) {
                                        EKPhotoAlbumModel *photoAlbumModel = [EKPhotoAlbumModel yy_modelWithDictionary:dictionary];
                                        [tempArray addObject:photoAlbumModel];
                                    }
                                    callBack(nil, tempArray.copy);
                                }
                            } else {
                                callBack(model.message, nil);
                            }
                        }
                    }];
}

@end
