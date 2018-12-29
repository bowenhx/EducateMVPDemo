/**
 -  EKPhotoAlbumCell.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/1.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"相册"界面使用的cell
 */

#import <UIKit/UIKit.h>
#import "EKPhotoAlbumModel.h"
//缓存标识符
static NSString *photoAlbumCellID = @"EKPhotoAlbumCell";

@interface EKPhotoAlbumCell : UICollectionViewCell
@property (nonatomic, strong) EKPhotoAlbumModel *vPhotoAlbumModel;
@end
