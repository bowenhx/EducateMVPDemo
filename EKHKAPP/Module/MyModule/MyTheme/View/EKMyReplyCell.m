/**
 -  EKMyReplyCell.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/25.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"我的主题"界面的"回复"cell
 */

#import "EKMyReplyCell.h"

@interface EKMyReplyCell ()
@property (weak, nonatomic) IBOutlet UILabel *vMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *vLastPostLabel;
@property (weak, nonatomic) IBOutlet UILabel *vReplyLabel;

@end

@implementation EKMyReplyCell
- (void)setVMyThemeModel:(EKMyThemeModel *)vMyThemeModel {
    _vMyThemeModel = vMyThemeModel;
    
    _vMessageLabel.text = vMyThemeModel.message;
    _vLastPostLabel.text = vMyThemeModel.lastpost;
    
    NSString *author =  vMyThemeModel.author;
    NSString *subject = vMyThemeModel.subject;
    NSString *appending = [NSString stringWithFormat:@"回覆%@的發帖：%@",author,subject];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:appending];
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:13]
                             range:NSMakeRange(2, author.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:@"336A68".color
                             range:NSMakeRange(2, author.length)];
    _vReplyLabel.attributedText = attributedString;
}

@end
