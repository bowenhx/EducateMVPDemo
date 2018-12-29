//
//  PollsCell.m
//  BKMobile
//
//  Created by 颜 薇 on 15/11/18.
//  Copyright © 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "PollsCell.h"

@interface PollsCell()
{
    
}
@property (nonatomic, strong) UIView    *selectView;
@property (nonatomic, strong) UIView    *progressView;/**<進度*/
@property (nonatomic, strong) UIView    *progressBgView;/**<進度背景*/
@property (nonatomic, strong) UILabel   *labelTitle;/**<标题*/
@property (nonatomic, strong) UILabel   *labelNumber;/**<百分比*/
@property(nonatomic, assign)PollsCellStyleType pollsCellType;
@end

@implementation PollsCell

-(instancetype)initWithPollCellStyle:(PollsCellStyleType)pollCellStyle withReuseIdentifier:(NSString *)resureIdentifer{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resureIdentifer];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.pollsCellType = pollCellStyle;
    switch (pollCellStyle) {
        case PollsCellStyleTypeOfSelect:
        {
            
            _progressBgView = [[UIView alloc] init];
            [_progressBgView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [_progressBgView setBackgroundColor:[@"DDF9F8" color]];
            [_progressBgView setHidden:YES];
            [self.contentView addSubview:_progressBgView];
            
            _labelTitle = [[UILabel alloc] init];
            [_labelTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
            [_labelTitle setNumberOfLines:2];
            [_labelTitle setMinimumScaleFactor:10];
            [self.contentView addSubview:_labelTitle];
            
            _selectView = [[UIView alloc] init];
            [_selectView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [_selectView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"select_gou"]]];
            [_selectView setHidden:YES];
            [self.contentView addSubview:_selectView];
            NSDictionary *views = NSDictionaryOfVariableBindings(_selectView, _progressBgView);
            
            
            //_selectView layout
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_selectView(25)]" options:0 metrics:nil views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_selectView(25)]" options:0 metrics:nil views:views]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_selectView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_selectView attribute:NSLayoutAttributeTrailing multiplier:1 constant:12]];
            
            //_labelTitle
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_labelTitle attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_labelTitle attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:10]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_labelTitle attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10]];
            //_progressBgView
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_progressBgView]|" options:0 metrics:nil views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_progressBgView]|" options:0 metrics:nil views:views]];
            
            break;
        }
        case PollsCellStyleTypeOfShow:
        {

            _progressBgView = [[UIView alloc] init];
            [_progressBgView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self.contentView addSubview:_progressBgView];
            
            _progressView = [[UIView alloc] init];
            [_progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self.contentView addSubview:_progressView];
            
            _labelTitle = [[UILabel alloc] init];
            [_labelTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
            [_labelTitle setTextColor:[UIColor darkGrayColor]];
            [_labelTitle setNumberOfLines:2];
            [_labelTitle setMinimumScaleFactor:0.6];
            [_labelTitle setAdjustsFontSizeToFitWidth:YES];
            [self.contentView addSubview:_labelTitle];
            
            _labelNumber = [[UILabel alloc] init];
            [_labelNumber setAdjustsFontSizeToFitWidth:YES];
            [_labelNumber setMinimumScaleFactor:0.6f];
            [_labelNumber setTextAlignment:NSTextAlignmentRight];
            [_labelNumber setTextColor:[UIColor grayColor]];
            [_labelNumber setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self.contentView addSubview:_labelNumber];
            
            NSDictionary *views = NSDictionaryOfVariableBindings(_labelTitle, _labelNumber, _progressView, _progressBgView);
            //_labelTitle
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_labelTitle attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_labelTitle attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:10]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_labelNumber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_labelTitle attribute:NSLayoutAttributeTrailing multiplier:1 constant:5]];
            
            //_labelNumber
            NSLayoutConstraint *numberConstraintH = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_labelNumber attribute:NSLayoutAttributeTrailing multiplier:1 constant:10];
            numberConstraintH.priority = UILayoutPriorityDefaultHigh;
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_labelNumber attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
            [self.contentView addConstraint:numberConstraintH];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_labelNumber(>=90)]" options:0 metrics:nil views:views]];
            
            
        
            
            //_progressView
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_progressView]|" options:0 metrics:nil views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_progressView]|" options:0 metrics:nil views:views]];
            
            //_progressBgView
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_progressBgView]|" options:0 metrics:nil views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_progressBgView]|" options:0 metrics:nil views:views]];
            
            break;
        }
        default:
            break;
    }
    return self;
}

- (void)setOption:(NSDictionary *)option{
    _option = option;
    
    _labelTitle.text = _option[@"polloption"];//標題
    if (_pollsCellType == PollsCellStyleTypeOfShow) {
        
        CGFloat percent = [_option[@"percent"] floatValue];//投票百分比ceilf(percent)
        _labelNumber.text = [NSString stringWithFormat:@"%@(%.2lf％)", _option[@"votes"], percent];
        //自己是否有選擇
        BOOL isSelect = [_option[@"myselect"] boolValue];
        if (isSelect) {
            [_progressView setBackgroundColor:[@"AEE6EB" color]];
            [_progressBgView setBackgroundColor:[@"DDF9F8" color]];            
        }else{
            [_progressView setBackgroundColor:[@"E5E5E8" color]];
            [_progressBgView setBackgroundColor:[@"F6F6F6" color]];
        }
        CGFloat progressViewWidth = SCREEN_WIDTH * (percent/100);
        DLog(@"screen : %f prgWidth : %f percent: %f", SCREEN_HEIGHT, progressViewWidth, percent);
        DLog(@"bgframe : %@", NSStringFromCGRect(_progressBgView.frame));
        [_progressView setTranslatesAutoresizingMaskIntoConstraints:YES];
        [_progressView setFrame:CGRectMake(0, 0, 0, kPollsCellHeight)];
        [UIView animateWithDuration:0.7 animations:^{
            [_progressView setFrame:CGRectMake(0, 0, progressViewWidth, kPollsCellHeight)];
        }];
    }else{
        
    }
}
- (void)setIsSelectStatus:(BOOL)isSelectStatus{
    _isSelectStatus = isSelectStatus;
    if (_isSelectStatus) {
        [_progressBgView setHidden:NO];
        [_selectView setHidden:NO];
    }else{
        [_progressBgView setHidden:YES];
        [_selectView setHidden:YES];
    }
}
@end
