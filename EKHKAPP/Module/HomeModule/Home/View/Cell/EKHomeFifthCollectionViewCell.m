/**
 -  EKHomeFifthCollectionViewCell.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/20.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"首页"的KMALL cell内部的collectionView的cell
 */

#import "EKHomeFifthCollectionViewCell.h"

@interface EKHomeFifthCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *vThumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *vPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *vTitleLabel;

@end

@implementation EKHomeFifthCollectionViewCell

- (void)setVHomeKMallModel:(EKHomeKMallModel *)vHomeKMallModel {
    _vHomeKMallModel = vHomeKMallModel;
    
    NSURL *imageURL = [NSURL URLWithString:vHomeKMallModel.thumb];
    [_vThumbImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:kPlaceHolderGray]];
    NSString *priceString = nil;
    if ([BKTool isStringBlank:vHomeKMallModel.price] || [vHomeKMallModel.price isEqualToString:@"0"]) {
        priceString = vHomeKMallModel.costprice;
    } else {
        priceString = vHomeKMallModel.price;
    }
    _vPriceLabel.text = [@"HK$" stringByAppendingString:priceString];
    _vTitleLabel.text = vHomeKMallModel.title;
}

@end
