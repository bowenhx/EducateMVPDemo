//
//  CommentViewCell.m
//  BKMobile
//
//  Created by Guibin on 15/8/7.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "CommentViewCell.h"
//#import "UIImageView+WebCache.h"
#import "BTextKit.h"

@interface CommentViewCell ()
{
    __weak IBOutlet UIImageView *_iconImage;
    
    __weak IBOutlet UILabel *_nameLab;
    
    __weak IBOutlet NSLayoutConstraint *_textHeight;
    
}
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@end

@implementation CommentViewCell


- (void)awakeFromNib {
    // Initialization code
//    _commentTextView.layer.borderWidth = 1;
//    _commentTextView.layer.borderColor = [UIColor redColor].CGColor;
    _iconImage.layer.masksToBounds = YES;
    _iconImage.layer.cornerRadius = 22;
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setItem:(CommentModel *)item{
    _textHeight.constant = item.viewHeight;
    NSURL *iconURL = [NSURL URLWithString:item.avatar];
    [_iconImage sd_setImageWithURL:iconURL
                  placeholderImage:[UIImage imageNamed:kPlaceHolderAvatar]];
    
    _nameLab.text = item.author;
    
    self.commentTextView.attributedText = item.attString;
//    DLog(@"comment = %@",item.comment);
    
    [BTextKit appendGIF:self.commentTextView list:item.smileyInf];
    
}

@end
