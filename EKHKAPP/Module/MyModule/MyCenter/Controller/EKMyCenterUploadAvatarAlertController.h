/**
 -  EKMyCenterUploadAvatarAlertController.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"个人中心"界面点击头像是弹出的上传头像的弹窗控制器
 */

#import <UIKit/UIKit.h>

/**
 上传头像的方式

 - EKMyCenterUploadAvatarMethodTypeAlbum: 从系统相册选择
 - EKMyCenterUploadAvatarMethodTypeTakePhoto: 拍照
 */
typedef NS_ENUM(NSInteger, EKMyCenterUploadAvatarMethodType) {
    EKMyCenterUploadAvatarMethodTypeAlbum,
    EKMyCenterUploadAvatarMethodTypeTakePhoto
};

@protocol EKMyCenterUploadAvatarAlertControllerDelegate;

@interface EKMyCenterUploadAvatarAlertController : UIAlertController
@property (nonatomic, weak) id <EKMyCenterUploadAvatarAlertControllerDelegate> vDelegate;
@end

@protocol EKMyCenterUploadAvatarAlertControllerDelegate <NSObject>
/**
 回传选择的上传头像的方式

 @param methodType 上传头像的方式
 */
- (void)mMyCenterUploadAvatarAlertControllerDidSelectWithType:(EKMyCenterUploadAvatarMethodType)methodType;
@end
