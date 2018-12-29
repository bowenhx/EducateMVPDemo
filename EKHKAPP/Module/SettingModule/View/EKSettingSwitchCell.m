/**
 -  EKSettingSwitchCell.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/7.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"设置"界面的第0个具有开关的cell
 */

#import "EKSettingSwitchCell.h"

@interface EKSettingSwitchCell ()
@property (nonatomic, strong) UISwitch *vSwitch;
@end

@implementation EKSettingSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat switchWidth = 51;
        CGFloat switchHeight = 31;
        CGFloat switchRightMargin = 10;
        _vSwitch = [[UISwitch alloc] init];
        [self.contentView addSubview:_vSwitch];
        [_vSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo(switchWidth);
            make.height.mas_equalTo(switchHeight);
            make.right.equalTo(self.contentView).offset(-switchRightMargin);
        }];
        [_vSwitch addTarget:self action:@selector(mSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}


- (void)mSwitchValueChanged:(UISwitch *)sender {
    if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(mSettingSwitchCellSwitchIsOn:)]) {
        [self.vDelegate mSettingSwitchCellSwitchIsOn:sender.isOn];
    }
}


- (void)setVIsSwitchOn:(BOOL)vIsSwitchOn {
    _vIsSwitchOn = vIsSwitchOn;
    
    _vSwitch.on = vIsSwitchOn;
}

@end
