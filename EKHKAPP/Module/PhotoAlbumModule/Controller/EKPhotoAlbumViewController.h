/**
 -  EKPhotoAlbumViewController.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/1.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"相册"界面
 */

#import "EKBaseViewController.h"

@interface EKPhotoAlbumViewController : EKBaseViewController
//用户的uid
@property (nonatomic, copy) NSString *uid;
//用户的名称
@property (nonatomic, copy) NSString *username;
@end
