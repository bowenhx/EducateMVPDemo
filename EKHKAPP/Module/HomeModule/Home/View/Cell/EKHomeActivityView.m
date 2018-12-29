/**
 -  EKHomeActivityView.m
 -  EKHKAPP
 -  Created by ligb on 2017/9/18.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "EKHomeActivityView.h"
#import "EKHomeActivityModel.h"
@interface EKHomeActivityView ()

@property (weak, nonatomic) IBOutlet UILabel *vAgoLabel;
@property (weak, nonatomic) IBOutlet UILabel *vAfterLabel;
@property (weak, nonatomic) IBOutlet UILabel *vYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *vMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *vDayLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBtnLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBtnLeading;
@property (nonatomic, assign) NSInteger vToday;
@property (nonatomic, assign) NSInteger vMonth;
@property (nonatomic, assign) NSInteger vMonthCount;
@property (nonatomic, assign) BOOL isChange;
@end

@implementation EKHomeActivityView

+ (EKHomeActivityView *)getHomeActivityView {
    return [[NSBundle mainBundle] loadNibNamed:@"EKHomeActivityView" owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor EKHeadColorYellow];
    if (SCREEN_WIDTH > 320) {
        _leftBtnLeading.constant += 20;
        _rightBtnLeading.constant += 20;
    }
}

- (void)setVUpdate:(NSString *)vUpdate {
    _vUpdate = vUpdate;
    NSString *agoStr = [vUpdate substringFromIndex:vUpdate.length-2];
    _vYearLabel.text = [vUpdate substringToIndex:4];
    _vMonthLabel.text = [self mChangeMonthString:vUpdate];
    _vDayLabel.text = agoStr;
    if (![agoStr isEqualToString:@"01"]) {
        _vAgoLabel.text = [self mJudgeTodayString:agoStr.integerValue-1];
        if (agoStr.integerValue < 10) {
            _vToday = [agoStr substringFromIndex:agoStr.length-1].integerValue;
        } else {
            _vToday = agoStr.integerValue;
        }
    }
    
    if (agoStr.integerValue+1 <= _vMonthCount) {
        _vAfterLabel.text = [self mJudgeTodayString:agoStr.integerValue+1];
    }
}

- (NSString *)mChangeMonthString:(NSString *)month {
    month = [month substringFromIndex:5];
    month = [month substringToIndex:2];
    if (month.integerValue < 10) {
        _vMonth = [month substringFromIndex:month.length-1].integerValue;
    } else {
        _vMonth = month.integerValue;
    }
    //记录当前月份一共有多少天
    _vMonthCount = [EKHomeActivityModel mGetManyDaysInThisYear:_vYearLabel.text.integerValue withMonth:_vMonth];
    return [EKHomeActivityModel monthChangeAction:month];
}


- (IBAction)mSelectTimeAction:(UIButton *)sender {
    if (sender.tag == 100) {
        //前一天
        [self mChangeTodayNumber:YES];
    } else {
        //后一天
        [self mChangeTodayNumber:NO];
    }
    
    if (_updataDate) {
        NSString *date = [NSString stringWithFormat:@"%@-%@-%@",_vYearLabel.text, [self mJudgeTodayString:_vMonth], _vDayLabel.text];
        DLog(@"date = %@",date);
        _updataDate(date);
    }
}

- (void)mChangeTodayNumber:(BOOL)isAgo {
    if (isAgo) {
        _vToday --;
    } else {
        _vToday ++;
    }
    
    _vDayLabel.text = [self mJudgeTodayString:_vToday];
    NSInteger agoNum = _vToday, afterNum = _vToday;
    agoNum --;
    afterNum ++;
    if (afterNum > _vMonthCount) {
        afterNum = 1;
    }
    
    _vAgoLabel.text = [self mJudgeTodayString:agoNum];
    _vAfterLabel.text = [self mJudgeTodayString:afterNum];
    
    if (isAgo && agoNum < 1) {
       
        //计算上一个月有多少天
        _vMonth --;
        NSInteger upYear = _vYearLabel.text.integerValue;
        if (_vMonth < 1) {
            _vMonth = 12;
            upYear --;
            _vYearLabel.text = [NSString stringWithFormat:@"%zd",upYear];
        }
        _vMonthCount = [EKHomeActivityModel mGetManyDaysInThisYear:upYear withMonth:_vMonth];
        if (_vToday == 1) {
            _vMonth ++;
            _vAgoLabel.text = [NSString stringWithFormat:@"%zd",_vMonthCount];
            return;
        }
        _vDayLabel.text =  [NSString stringWithFormat:@"%zd",_vMonthCount];
        _vAgoLabel.text = [NSString stringWithFormat:@"%zd",_vMonthCount-1];
        
        _vToday = _vMonthCount;
    }
    
    if (isAgo && agoNum == _vMonthCount-2 && !_isChange) {
        _isChange = YES;
        _vToday = _vMonthCount;
        //更新月份
        _vMonthLabel.text = [EKHomeActivityModel monthChangeAction:[self mJudgeTodayString:_vMonth]];
        _vAgoLabel.text = [self mJudgeTodayString:_vMonthCount - 1];
        _vDayLabel.text = [self mJudgeTodayString:_vToday];
        _vAfterLabel.text = [self mJudgeTodayString:1];
        [self mChangeTodayNumber:true];
    } else {
        _isChange = NO;
    }
    
    
    if (!isAgo && _vToday > _vMonthCount) {
        //计算下一个月有多少天
        _vMonth ++;
        NSInteger nextYear = _vYearLabel.text.integerValue;
        if (_vMonth > 12) {
            //当月份大月12月时，要从1月开始，年份累加
            _vMonth = 1;
            nextYear ++;
            _vYearLabel.text = [NSString stringWithFormat:@"%zd",nextYear];
        }
        _vMonthCount = [EKHomeActivityModel mGetManyDaysInThisYear:nextYear withMonth:_vMonth];
        _vMonthLabel.text = [EKHomeActivityModel monthChangeAction:[self mJudgeTodayString:_vMonth]];
        _vAgoLabel.text = [NSString stringWithFormat:@"%zd",_vMonthCount];
        _vToday = 1;//从新开始计算天数
        NSInteger temp = _vMonth -1;//计算上个月多少天重新刷新数据
        NSInteger topMonth = [EKHomeActivityModel mGetManyDaysInThisYear:nextYear withMonth:temp];
        _vAgoLabel.text = [self mJudgeTodayString:topMonth];
        _vDayLabel.text = [self mJudgeTodayString:_vToday];
        _vAfterLabel.text = [self mJudgeTodayString:2];
        
    }
    
}

- (NSString *)mJudgeTodayString:(NSInteger)temp {
    if (temp < 10) {
        return [NSString stringWithFormat:@"0%zd",temp];
    } else {
        return [NSString stringWithFormat:@"%zd",temp];
    }
}



@end
