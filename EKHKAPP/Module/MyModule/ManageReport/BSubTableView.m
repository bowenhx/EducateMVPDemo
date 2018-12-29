//
//  BSubTableView.m
//  BKMobile
//
//  Created by Guibin on 15/2/11.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
//

#import "BSubTableView.h"

@interface BSubTableView ()

@end

@implementation BSubTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc] init];
        _tableView.tableFooterView = [[UIView alloc] init];
        [self addSubview:_tableView];
    }
    return self;
}



- (void)layoutSubviews
{
    _tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.bounds));
}



@end
