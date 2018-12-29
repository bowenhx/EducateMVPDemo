/**
 -  EKPhotoAlbumSecondCell.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/1.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是相册界面的次级界面
 */

#import <UIKit/UIKit.h>
#import "EKPhotoAlbumSecondModel.h"
//缓存标识符
static NSString *photoAlbumSecondCellID = @"EKPhotoAlbumSecondCellID";
@interface EKPhotoAlbumSecondCell : UICollectionViewCell
@property (nonatomic, strong) EKPhotoAlbumSecondModel *vPhotoAlbumSecondModel;
@end
