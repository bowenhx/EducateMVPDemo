//
//  EKEditThemeTableViewCell.m
//  EKHKAPP
//
//  Created by ligb on 2017/9/30.
//  Copyright © 2017年 BaByKingdom. All
//

#import "EKEditThemeTableViewCell.h"
@interface EKEditThemeTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *itemBtn;

@end

@implementation EKEditThemeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _icon.layer.masksToBounds = true;
    _icon.layer.cornerRadius = 25;
    _itemBtn.layer.masksToBounds = true;
    _itemBtn.layer.cornerRadius = 13;
    self.separatorInset = UIEdgeInsetsMake(0, _name.x, 0, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showItemModel:(EKThemeSubforumsModel *)model indexPath:(NSIndexPath *)indexPath {

    [_icon sd_setImageWithURL:[NSURL URLWithString:model.icon]
             placeholderImage:[UIImage imageNamed:kPlaceHolderForumAvatar]];
    
    _name.text = model.name;

    if (model.favid) {
        [_itemBtn setTitle:@"退出" forState:UIControlStateNormal];
        _itemBtn.layer.borderColor = [UIColor EKColorYellow].CGColor;
        [_itemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_itemBtn setBackgroundImage:[UIImage imageWithColor:[UIColor EKColorYellow]] forState:UIControlStateNormal];
    } else {
        _itemBtn.layer.borderWidth = 1;
        _itemBtn.layer.borderColor = [UIColor EKColorNavigation].CGColor;
        [_itemBtn setTitleColor:[UIColor EKColorNavigation] forState:UIControlStateNormal];
        [_itemBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [_itemBtn setTitle:@"加入" forState:UIControlStateNormal];
    }
}

- (IBAction)didSelectItemAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedItemCell:)]) {
        [_delegate didSelectedItemCell:self];
    }
}

@end
