/**
 -  EKPhotoAlbumCell.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/1.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"相册"界面使用的cell
 */

#import "EKPhotoAlbumCell.h"


@interface EKPhotoAlbumCell ()
@property (weak, nonatomic) IBOutlet UIImageView *vPicImageView;
@property (weak, nonatomic) IBOutlet UILabel *vAlbumNameLabel;
@end

@implementation EKPhotoAlbumCell
- (void)setVPhotoAlbumModel:(EKPhotoAlbumModel *)vPhotoAlbumModel {
    _vPhotoAlbumModel = vPhotoAlbumModel;
    
    NSURL *imageURL = [NSURL URLWithString:vPhotoAlbumModel.pic];
    [_vPicImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:kPlaceHolderWhite]];
    _vAlbumNameLabel.text = vPhotoAlbumModel.albumname;
}


@end
