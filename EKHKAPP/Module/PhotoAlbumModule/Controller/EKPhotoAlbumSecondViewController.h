/**
 -  EKPhotoAlbumSecondViewController.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/1.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是相册界面的次级界面
 */

#import "EKBaseViewController.h"

@interface EKPhotoAlbumSecondViewController : EKBaseViewController
//用户的uid
@property (nonatomic, copy) NSString *uid;
//相册名称
@property (nonatomic, copy) NSString *photoGalleryName;
//相册ID
@property (nonatomic, copy) NSString *albumid;
//相册密码
@property (nonatomic, copy) NSString *password;
@end
