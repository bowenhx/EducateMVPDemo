/**
 -  EKUserInformationDeleteFriendButton.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/2.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"好友基本资料"界面的"解除好友""加为好友"按钮
 */

#import "EKUserInformationDeleteFriendButton.h"

@implementation EKUserInformationDeleteFriendButton
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setTitle:@"解除好友" forState:UIControlStateNormal];
        [self setTitle:@"加為好友" forState:UIControlStateSelected];
        [self setTitleColor:[UIColor EKColorNavigation] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor EKColorTitleGray] forState:UIControlStateNormal];
        self.layer.borderWidth = 1;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.layer.borderColor = [UIColor EKColorNavigation].CGColor;
        [self setTitle:@"加為好友" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor EKColorNavigation] forState:UIControlStateNormal];
    } else {
        self.layer.borderColor = [UIColor EKColorTitleGray].CGColor;
        [self setTitle:@"解除好友" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor EKColorTitleGray] forState:UIControlStateNormal];
    }
}
@end
