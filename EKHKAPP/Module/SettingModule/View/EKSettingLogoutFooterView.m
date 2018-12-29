/**
 -  EKSettingLogoutFooterView.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/8.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"设置"界面的底部"退出当前登录账号"视图
 */

#import "EKSettingLogoutFooterView.h"

@interface EKSettingLogoutFooterView ()
//登出按钮
@property (nonatomic, strong) UIButton *vLogoutButton;
@end

@implementation EKSettingLogoutFooterView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self mInitUI];
    }
    return self;
}


- (void)mInitUI {
    //创建"登出"按钮
    _vLogoutButton = [[UIButton alloc] init];
    [_vLogoutButton setTitle:@"退出當前登錄賬號" forState:UIControlStateNormal];
    [_vLogoutButton setTitleColor:[UIColor EKColorTitleWhite] forState:UIControlStateNormal];
    [_vLogoutButton addTarget:self action:@selector(mClickLogoutButton) forControlEvents:UIControlEventTouchUpInside];
    _vLogoutButton.layer.cornerRadius = 5;
    _vLogoutButton.layer.masksToBounds = YES;
    [self addSubview:_vLogoutButton];
    [_vLogoutButton setBackgroundColor:[UIColor EKColorNavigation]];
    CGFloat margin = 10;
    [_vLogoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(margin);
        make.right.equalTo(self).offset(-margin);
    }];
}


//"登出"按钮监听事件
- (void)mClickLogoutButton {
    if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(mLogoutButtonDidClick)]) {
        [self.vDelegate mLogoutButtonDidClick];
    }
}

@end
