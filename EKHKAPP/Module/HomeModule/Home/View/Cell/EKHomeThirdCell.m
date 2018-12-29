//
//  EKHomeThirdCell.m
//  EKHKAPP
//
//  Created by stray s on 2017/9/18.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import "EKHomeThirdCell.h"

@interface EKHomeThirdCell()

@property (weak, nonatomic) IBOutlet UIButton *vTouchBtn;
@property (weak, nonatomic) IBOutlet UIView *vContentBox;
@property (weak, nonatomic) IBOutlet UIView *vProgressView;
@property (weak, nonatomic) IBOutlet UILabel *vTextLabel;

@end


@implementation EKHomeThirdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor EKColorNavigation];
    self.vContentBox.backgroundColor = [UIColor EKColorNavigation];
    self.vContentBox.layer.borderWidth = 1;
    self.vContentBox.layer.borderColor = [UIColor whiteColor].CGColor;
    self.vTextLabel.textColor = [UIColor whiteColor];    
}

- (void)mUpdata:(EKHomeVoteOptionsModel *)model selectSet:(NSArray *)array duration:(BOOL)duration {
    self.vTouchBtn.tag = model.polloptionid;
    _vTextLabel.text = model.polloption;
    _vProgressView.backgroundColor = RGBCOLOR(242, 141, 27);
    self.vTouchBtn.selected = [EKHomeVoteOptionsModel mIsSelectedValue:@(model.polloptionid) withForInSet:array];
  
    if (duration) {
        _vTouchBtn.enabled = NO;
        [_vTouchBtn setImage:nil forState:UIControlStateNormal];
        [_vTouchBtn setTitle:model.width forState:UIControlStateNormal];
        CGFloat percent = [model.percent floatValue];//投票百分比ceilf(percent)
        CGFloat progressViewWidth = _vContentBox.w * (percent/100);
        [UIView animateWithDuration:0.7f animations:^{
            [self.vProgressView setW:progressViewWidth];
        }];
    } else {
        _vTouchBtn.enabled = YES;
        [_vTouchBtn setImage:[UIImage imageNamed:@"home_radiobut_unpressed"] forState:UIControlStateNormal];
        [_vTouchBtn setTitle:@"" forState:UIControlStateNormal];
         [self.vProgressView setW:0];
    }
   
}



- (IBAction)mVoteAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mVoteSelectIndex:isSelected:)]) {
        [_delegate mVoteSelectIndex:sender.tag isSelected:sender.isSelected];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
