/**
 -  EKPhotoAlbumModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/1.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是后台返回的"相册"数据
 */

#import <Foundation/Foundation.h>

@interface EKPhotoAlbumModel : NSObject
@property (nonatomic, copy) NSString *albumname;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *albumid;
/**
 请求指定用户的相册数据

 @param userID 指定用户的userID
 @param callBack 完成回调
 */
+ (void)mRequestPhotoAlbumDataWithUserID:(NSString *)userID
                                callBack:(void (^)(NSString *netErr, NSArray<EKPhotoAlbumModel *> *data))callBack;
@end
