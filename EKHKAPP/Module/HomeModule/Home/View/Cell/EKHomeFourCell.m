//
//  EKHomeFourCell.m
//  EKHKAPP
//
//  Created by ligb on 2017/9/18.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import "EKHomeFourCell.h"

@interface EKHomeFourCell()
//imageView数组
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray <UIImageView *> *vImageViewArray;
//button数组
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *vButtonArray;
@end


@implementation EKHomeFourCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}
//button监听事件
- (IBAction)mClickButton:(UIButton *)sender {
    //回传点击的按钮的下标
    if (self.delegate && [self.delegate respondsToSelector:@selector(mHomeFourCellButtonDidClickWithIndex:)]) {
        //获取按钮的下标
        NSInteger index = [_vButtonArray indexOfObject:sender];
        [self.delegate mHomeFourCellButtonDidClickWithIndex:index];
    }
}


- (void)setVHomeTVModelDataSource:(NSArray<EKHomeTVModel *> *)vHomeTVModelDataSource {
    _vHomeTVModelDataSource = vHomeTVModelDataSource;
    if (vHomeTVModelDataSource.count >= _vImageViewArray.count) {
        //防止后台返回的数据超过2个
        for (NSInteger i = 0; i < _vImageViewArray.count; i++) {
            EKHomeTVModel *homeTVModel = _vHomeTVModelDataSource[i];
            NSURL *imageURL = [NSURL URLWithString:homeTVModel.thumb];
            [_vImageViewArray[i] sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:kPlaceHolderWhite]];
        }
    }
}


@end
