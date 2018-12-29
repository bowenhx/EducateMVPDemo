/**
 -  EKFirstLaunchFailView.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/16.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"首次启动"界面加载后台数据失败时显示的界面.只会在"选择年级"的界面出现,因为网络请求是这个界面发起的
 */

#import "EKFirstLaunchFailView.h"

@interface EKFirstLaunchFailView ()
//绑定的xib的主view
@property (nonatomic, weak) IBOutlet UIView *vContentView;
//"重试"按钮
@property (weak, nonatomic) IBOutlet UIButton *vRetryButton;
//提示没有网路服务的两个label
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *vNoticeLabelArray;
//点击"重试"按钮的时候执行的回调
@property (nonatomic, copy) void(^retryDidClickCallBack)(void);
@end

@implementation EKFirstLaunchFailView
- (instancetype)initWithFrame:(CGRect)frame retryDidClickCallBack:(void(^)(void))retryDidClickCallBack {
    if (self = [super initWithFrame:frame]) {
        [self mInitUI];
        _retryDidClickCallBack = retryDidClickCallBack;
    }
    return self;
}


#pragma mark - 初始化UI
- (void)mInitUI {
    //加载并绑定xib视图
    [[NSBundle mainBundle] loadNibNamed:@"EKFirstLaunchFailView" owner:self options:nil];
    [self addSubview:self.vContentView];
    self.vContentView.frame = self.bounds;
}


#pragma mark - 按钮监听事件
//点击"重试"
- (IBAction)mRetry:(id)sender {
    //修改自身的type类型并更新UI
    self.vType = EKFirstLaunchFailViewTypeLoading;
    //执行回调block
    if (self.retryDidClickCallBack) {
        self.retryDidClickCallBack();
    }
}


#pragma mark - 重写setter方法,更新UI
- (void)setVType:(EKFirstLaunchFailViewType)vType {
    _vType = vType;
    
    //处理提示没有网路服务的两个label的隐藏状态
    for (UILabel *label in _vNoticeLabelArray) {
        label.hidden = _vType;
    }
    
    //处理"重试"按钮的可点击状态及背景颜色
    _vRetryButton.enabled = !_vType;
    if (_vType == EKFirstLaunchFailViewTypeNotice) {
        _vRetryButton.backgroundColor = [UIColor EKColorYellow];
    } else {
        _vRetryButton.backgroundColor = @"CCCCCC".color;
    }
}



@end
