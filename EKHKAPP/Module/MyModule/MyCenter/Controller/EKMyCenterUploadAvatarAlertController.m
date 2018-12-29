/**
 -  EKMyCenterUploadAvatarAlertController.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"个人中心"界面点击头像是弹出的上传头像的弹窗控制器
 */

#import "EKMyCenterUploadAvatarAlertController.h"
@implementation EKMyCenterUploadAvatarAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    //"手機相冊"按鈕
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"手機相冊"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            if (self.vDelegate &&
                                                                [self.vDelegate respondsToSelector:@selector(mMyCenterUploadAvatarAlertControllerDidSelectWithType:)]) {
                                                                [self.vDelegate mMyCenterUploadAvatarAlertControllerDidSelectWithType:EKMyCenterUploadAvatarMethodTypeAlbum];
                                                            }
                                                        }];
    [self addAction:albumAction];
    
    //"系統拍照"按鈕
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"系統拍照"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                if (self.vDelegate &&
                                                                    [self.vDelegate respondsToSelector:@selector(mMyCenterUploadAvatarAlertControllerDidSelectWithType:)]) {
                                                                    [self.vDelegate mMyCenterUploadAvatarAlertControllerDidSelectWithType:EKMyCenterUploadAvatarMethodTypeTakePhoto];
                                                                }
                                                            }];
    [self addAction:takePhotoAction];
    
    //"取消"按鈕
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [self addAction:cancelAction];
}
@end
