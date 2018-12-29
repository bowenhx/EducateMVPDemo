/**
 -  EKPhotoAlbumSecondModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/1.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是相册的次级界面的对应的后台model
 */

#import <Foundation/Foundation.h>

@interface EKPhotoAlbumSecondModel : NSObject
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *filepath;
+ (void)mRequestPhotoAlbumSecondDataSourceWithAlbumID:(NSString *)albumID
                                                  uid:(NSString *)uid
                                             password:(NSString *)password
                                             callBack:(void(^)(NSString *netErr, NSArray <EKPhotoAlbumSecondModel *> *data))callBack;
@end
