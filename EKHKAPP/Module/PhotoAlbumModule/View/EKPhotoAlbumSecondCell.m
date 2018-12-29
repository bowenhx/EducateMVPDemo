/**
 -  EKPhotoAlbumSecondCell.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/1.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是相册界面的次级界面
 */

#import "EKPhotoAlbumSecondCell.h"

@interface EKPhotoAlbumSecondCell ()
@property (weak, nonatomic) IBOutlet UIImageView *vPicImageView;

@end

@implementation EKPhotoAlbumSecondCell

- (void)setVPhotoAlbumSecondModel:(EKPhotoAlbumSecondModel *)vPhotoAlbumSecondModel {
    _vPhotoAlbumSecondModel = vPhotoAlbumSecondModel;
    
    NSURL *picURL = [NSURL URLWithString:vPhotoAlbumSecondModel.pic];
    [_vPicImageView sd_setImageWithURL:picURL placeholderImage:[UIImage imageNamed:kPlaceHolderWhite]];
}
@end
