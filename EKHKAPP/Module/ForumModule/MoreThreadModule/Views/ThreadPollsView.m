//
//  ThreadPollsView.m
//  BKMobile
//
//  Created by 薇 颜 on 15/11/16.
//  Copyright © 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "ThreadPollsView.h"
#import "PollsViewController.h"
#import "EKLoginViewController.h"
@interface ThreadPollsView ()
{
    
}
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UILabel *label;
@end

@implementation ThreadPollsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] init];
        [_label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_label setTextColor:[UIColor EKColorNavigation]];
        [_label setFont:[UIFont systemFontOfSize:14.0]];
        [self addSubview:_label];
        
        self.btn = [[UIButton alloc] init];
        [_btn setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_btn addTarget:self action:@selector(actionPushToPolls:) forControlEvents:UIControlEventTouchUpInside];
        [_btn setEnabled:YES];

        
        [self addSubview:_btn];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_btn, _label);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_label]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_label(30)]" options:0 metrics:nil views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_label attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_btn]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_btn(30)]" options:0 metrics:nil views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_btn attribute:NSLayoutAttributeTop multiplier:1 constant:0]];

    }
    return self;
}

- (void)setThreadpolls:(NSDictionary *)threadpolls{
    _threadpolls = threadpolls;
    
    NSString *labelText = @"";
    //狀態 ＝ 1 可以投票
    if([_threadpolls[@"mystatus"] integerValue] == 1){
        labelText = @"點擊去投票";
    }else{
        //不能投票
        labelText = _threadpolls[@"statusmsg"];
    }
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:labelText];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    
    _label.attributedText = content;
    
}

- (IBAction)actionPushToPolls:(id)sender{
    if ([EKLoginViewController showLoginVC:_viewController from:@"inPage"]) {
        return;
    }
    PollsViewController *pollsViewController = [[PollsViewController alloc] initWithNibName:@"PollsViewController" bundle:nil];
    pollsViewController.tid = _tid;
    pollsViewController.password = _password;
    pollsViewController.pollsView = self;
    [_viewController.navigationController pushViewController:pollsViewController animated:YES];
}
@end
