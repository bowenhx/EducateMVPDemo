/**
 -  EKAboutUsHeaderView.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/8.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"关于我们"界面的头部视图
 */

#import "EKAboutUsHeaderView.h"

@interface EKAboutUsHeaderView ()
//App图标imageView
@property (nonatomic, weak) UIImageView *appIconImageView;
//版本label
@property (nonatomic, weak) UILabel *versionLabel;
@end

@implementation EKAboutUsHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self mInitUI];
    }
    return self;
}


- (void)mInitUI {
    self.contentView.backgroundColor = [UIColor EKColorBackground];
    //设置app图标
    UIImageView *appIconImageView = [[UIImageView alloc] init];
    self.appIconImageView = appIconImageView;
    [self.contentView addSubview:appIconImageView];
    [appIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(-10);
        make.centerX.equalTo(self.contentView);
    }];
    appIconImageView.image = [UIImage imageNamed:@"personal_logo"];
    
    //设置label
    UILabel *versionLabel = [[UILabel alloc] init];
    self.versionLabel = versionLabel;
    [self.contentView addSubview:versionLabel];
    CGFloat versionLabelTopMargin = 5;
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(appIconImageView.mas_bottom).offset(versionLabelTopMargin);
        make.centerX.equalTo(self.contentView);
    }];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    versionLabel.text = [@"V" stringByAppendingString:[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    versionLabel.font = [UIFont systemFontOfSize:20];
    versionLabel.textColor = [UIColor EKColorTitleBlack];
}


@end
