//
//  EKThemeDetailHeadCell.m
//  EKHKAPP
//
//  Created by ligb on 2017/11/1.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import "EKThemeDetailHeadCell.h"

@interface EKThemeDetailHeadCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *replies;

@property (weak, nonatomic) IBOutlet UILabel *views;

@property (weak, nonatomic) IBOutlet UIButton *forunBtn;

@end


@implementation EKThemeDetailHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)uploadHeadListData:(ThreadsDetailModel *)data{
    if (data) {
        //self.collectBtn.selected = data.favid;
        self.title.text = data.subject;
        [self.forunBtn setTitle:[NSString stringWithFormat:@"%@ >",data.fname] forState:UIControlStateNormal];
        self.replies.text = [NSString stringWithFormat:@"%zd",data.replies];
        self.views.text = [NSString stringWithFormat:@"%zd",data.views];
    }
}

- (IBAction)forumAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(mThemeTypeHeadAction)]) {
        [_delegate mThemeTypeHeadAction];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
