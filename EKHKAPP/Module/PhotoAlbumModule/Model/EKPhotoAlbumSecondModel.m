/**
 -  EKPhotoAlbumSecondModel.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/1.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是相册的次级界面的对应的后台model
 */

#import "EKPhotoAlbumSecondModel.h"

@implementation EKPhotoAlbumSecondModel
+ (void)mRequestPhotoAlbumSecondDataSourceWithAlbumID:(NSString *)albumID
                                                  uid:(NSString *)uid
                                             password:(NSString *)password
                                             callBack:(void(^)(NSString *netErr, NSArray <EKPhotoAlbumSecondModel *> *data))callBack {
    NSDictionary *parameter = nil;
    if (uid) {
        parameter = @{@"token" : TOKEN,
                      @"view" : @"me",
                      @"uid" : uid,
                      @"id" : albumID,
                      @"password" : password};
    } else {
        parameter = @{@"token" : TOKEN,
                      @"view" : @"me",
                      @"id" : albumID,
                      @"password" : password};
    }
    
    [EKHttpUtil mHttpWithUrl:kPhotoAlbumURL
                   parameter:parameter
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (netErr) {
                            callBack(netErr, nil);
                        }else{
                            if (1 == model.status) {
                                if (model.data && [model.data isKindOfClass:[NSArray class]]) {
                                    NSMutableArray <EKPhotoAlbumSecondModel *> *tempArray = [NSMutableArray array];
                                    for (NSDictionary *dictionary in model.data) {
                                        EKPhotoAlbumSecondModel *photoAlbumSecondModel = [EKPhotoAlbumSecondModel yy_modelWithDictionary:dictionary];
                                        [tempArray addObject:photoAlbumSecondModel];
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
