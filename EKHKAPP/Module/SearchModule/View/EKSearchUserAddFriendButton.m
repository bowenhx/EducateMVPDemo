/**
 -  EKSearchUserAddFriendButton.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/22.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:"搜索用户"的cell的"加为好友"按钮
 */

#import "EKSearchUserAddFriendButton.h"

@implementation EKSearchUserAddFriendButton
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setTitle:@"解除好友" forState:UIControlStateNormal];
        [self setTitle:@"加為好友" forState:UIControlStateSelected];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor EKColorTitleGray] forState:UIControlStateNormal];
        self.layer.borderWidth = 1;
    }
    return self;
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = [UIColor EKColorYellow];
        self.layer.borderColor = [UIColor EKColorYellow].CGColor;
    } else {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor EKColorTitleGray].CGColor;
    }
}

@end
