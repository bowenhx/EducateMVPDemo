//
//  ThreadActivityView.m
//  BKMobile
//
//  Created by 薇 颜 on 15/11/10.
//  Copyright © 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "ThreadActivityView.h"
#import "ActivityWebVC.h"
#import "EKLoginViewController.h"
#import "ActivityCancelVC.h"

@interface ThreadActivityView ()
{
    
}
@property (nonatomic, weak) IBOutlet UIImageView *imageView;   /**<活动类型*/
@property (nonatomic, weak) IBOutlet UILabel *labelClassName;   /**<活动类型*/
@property (nonatomic, weak) IBOutlet UILabel *labelStartDate;   /**<开始时间*/
@property (nonatomic, weak) IBOutlet UILabel *labelAddress;     /**<活动地址*/
@property (nonatomic, weak) IBOutlet UILabel *labelGender;      /**<性别*/
@property (nonatomic, weak) IBOutlet UILabel *labelMoney;       /**<花销*/
@property (nonatomic, weak) IBOutlet UILabel *labelAlreadyNumPeople1;/**<已经报名人数*/
@property (nonatomic, weak) IBOutlet UILabel *labelAlreadyNumPeople;/**<已经报名人数*/
@property (nonatomic, weak) IBOutlet UILabel *labelLastNumPeople1;/**<剩余报名人数*/
@property (nonatomic, weak) IBOutlet UILabel *labelLastNumPeople;/**<剩余报名人数*/
@property (nonatomic, weak) IBOutlet UILabel *labelEndDate1;     /**<截止时间*/
@property (nonatomic, weak) IBOutlet UILabel *labelEndDate;     /**<截止时间*/
@property (nonatomic, weak) IBOutlet UILabel *labelRemark;      /**<提示信息：报名成功，已报名等等*/

@property (nonatomic, assign) ActivityViewType activityViewType;    /**<视图类型*/

@property (nonatomic, weak) IBOutlet UIButton *btnJoin;         /**<报名按钮*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForlabelEndDate;/**<截止时间距离上面性别的距离，因为上面的（报名人数，剩余报名人数）在HK版本要隐藏掉*/
@end


@implementation ThreadActivityView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame withActivityViewType:(ActivityViewType)activityViewType{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ThreadActivityView" owner:self options:nil];
        if (arrayOfViews.count < 1) {
            return nil;
        }
        
        //判断活动费用是否等于0
        if (activityViewType == ActivityViewTypeIsNoCost) {
            self = arrayOfViews[0];     //没有【每人花销】显示
        }else{
            self = arrayOfViews[1];     //有【每人花销】显示
        }
        self.frame = frame;
        self.activityViewType = activityViewType;

    }
    return self;
}

- (void)setThreadacts:(NSDictionary *)threadacts{
    _threadacts = threadacts;
    
    //【活动類型】
    _labelClassName.text = _threadacts[@"classname"];
    
    //处理【开始时间】
    NSString *beginTime = _threadacts[@"starttimefrom"];
    NSString *starttimeto = _threadacts[@"starttimeto"];
    if (starttimeto.length && ![starttimeto isEqualToString:@"0"]) {
        beginTime = [NSString stringWithFormat:@"%@ 至 %@", beginTime, _threadacts[@"starttimeto"]];
    }
    
    _labelStartDate.text = beginTime;
    
    //【活动地点】
    _labelAddress.text = _threadacts[@"place"];
    
    //处理【性别】  0 不限;  1 男;  2 女
    NSInteger gender = [_threadacts[@"gender"] integerValue];
    if (gender == 1) {
        _labelGender.text = @"男";
    }else if (gender == 2){
        _labelGender.text = @"女";
    }else{
        _labelGender.text = @"不限";
    }
    
    //金額單位
    NSString *moneyUnits = @"元";

    moneyUnits = @"HKD";
    
    _labelAlreadyNumPeople1.hidden = YES;
    _labelAlreadyNumPeople.hidden = YES;
    _labelLastNumPeople.hidden = YES;
    _labelLastNumPeople1.hidden = YES;
    _heightForlabelEndDate.constant = 5.0;

    
    //【每人花销】
    if (_activityViewType == ActivityViewTypeIsHaveCost) {
        _labelMoney.text = [NSString stringWithFormat:@"%@ %@", _threadacts[@"cost"], moneyUnits] ;
    }
    
    //【已报名人数】
    _labelAlreadyNumPeople.text = [NSString stringWithFormat:@"%@ 人", _threadacts[@"joinnumber"]];
    
    //【剩余名额】
    if ([_threadacts[@"number"] integerValue] == 0) {
        _labelLastNumPeople.text = @"不限";
    }else{
        _labelLastNumPeople.text = [NSString stringWithFormat:@"%@ 人", _threadacts[@"overnumber"]];
    }
    
    
    //【截止报名时间】
    if ([_threadacts[@"expiration"] length]) {
        _labelEndDate.text = _threadacts[@"expiration"];
    }else{
        [_labelEndDate1 setHidden:YES];
        [_labelEndDate setHidden:YES];
    }
    
    
    //【图片】
    NSURL *thumbURL = [NSURL URLWithString:_threadacts[@"thumb"]];
    [_imageView sd_setImageWithURL:thumbURL placeholderImage:[UIImage imageNamed:kPlaceHolderActivity]];
    
    
    //判断活动及报名状态
    
    /*
     ActivityStatusNormal = 0,       //可以报名
     ActivityStatusFull = 1,         //名额已满
     ActivityStatusAlready = 2,      //已报名
     ActivityStatusAddMaterial = 3, //完善资料
     ActivityStatusCheck = 4, //已报名,等待审核
     */
    
    _labelRemark.text = @"";
    
   
}
- (void)setActivityStatus:(ActivityStatus)activityStatus{
    _activityStatus = activityStatus;
    
    switch (_activityStatus) {
        case ActivityStatusNormal:
        {
            _labelRemark.text = @"";
            [self chageJoinButtonStatusWithTitle:@"我要參加" withEnabled:YES];
            break;
        }
        case ActivityStatusFull:
        {
            _labelRemark.text = @"";
            [self chageJoinButtonStatusWithTitle:@"名額已滿" withEnabled:NO];
            break;
        }
        case ActivityStatusAlready:
        {
            _labelRemark.text = @"您已經參加了此活動";
            [self chageJoinButtonStatusWithTitle:@"取消報名" withEnabled:YES];
            break;
        }
        case ActivityStatusAddMaterial:
        {
            _labelRemark.text = @"";
            [self chageJoinButtonStatusWithTitle:@"完善資料" withEnabled:YES];
            break;
        }
        case ActivityStatusCheck:
        {
            _labelRemark.text = @"您的加入申請已發出，請等待發起者審批";
            [self chageJoinButtonStatusWithTitle:@"取消報名" withEnabled:YES];
            break;
        }
        default:
            break;
    }
    if (_activityisOver == ActivityisOverYES) {
        //活动结束
        [self chageJoinButtonStatusWithTitle:@"活動結束" withEnabled:NO];
        
    }
}
- (void)chageJoinButtonStatusWithTitle:(NSString *)title withEnabled:(BOOL)enabled{
    if (enabled) {
        [_btnJoin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnJoin setBackgroundColor:[UIColor EKColorNavigation]];
        
    }else{
        [_btnJoin setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_btnJoin setBackgroundColor:[UIColor lightGrayColor]];
    }
    [_btnJoin setTitle:title forState:UIControlStateNormal];
    [_btnJoin setEnabled:enabled];
    _btnJoin.layer.cornerRadius = 2;
}

/**
 *  點擊參加/取消報名按鈕
 */ 
- (IBAction)actionJoinBtnClick:(UIButton *)sender{
    
    if ([EKLoginViewController showLoginVC:_viewController from:@"inPage"]) {
        return;
    }
    
    //取消报名
    if (_activityStatus == ActivityStatusAlready || _activityStatus == ActivityStatusCheck) {
        
        ActivityCancelVC *cancelVC = [[ActivityCancelVC alloc] initWithNibName:@"ActivityCancelVC" bundle:nil];
        cancelVC.tid = _tid;
        [_viewController.navigationController pushViewController:cancelVC animated:YES];
        
    }else{
        //去报名
        ActivityWebVC *webViewController = [[ActivityWebVC alloc] initWithNibName:@"ActivityWebVC" bundle:nil];
        webViewController.url = _threadacts[@"joinurl"];
        webViewController.title = @"活動資料完善";
        [_viewController.navigationController pushViewController:webViewController animated:YES];
    }
    
}
- (void)changeStatus:(ActivityStatus)status{
    [self setActivityStatus:status];
}
@end
