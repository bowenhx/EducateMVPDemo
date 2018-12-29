/**
 -  EKBaseViewController.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/8.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:EK项目的基类viewController文件
 */

#import "EKBaseViewController.h"
#import "EKColumnView.h"
#import "EKNavigationViewController.h"
#import "BKUserHelper.h"

@interface EKBaseViewController ()

@end

@implementation EKBaseViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self mSetNavLeftItem];
    
    //初始化UI
    [self mInitUI];
    
    //初始化数据
    [self mInitData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //在父类中进行一些页面的谷歌统计
//    [EKGoogleStatistics mAddStatisticsAnalytics:self];

    if (self.navigationController.viewControllers.count == 1) {
        //从二级页面返回一级主页面后，需要remove，防止重复注册通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kHomePushNextNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNextViewController:) name:kHomePushNextNotification object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //结束友盟统计
//    [EKGoogleStatistics mEndStatisticsAnalytics:self];
    
    if (self.navigationController.viewControllers.count == 1) {
        //一级页面相互切换时remove掉通知，防止出现多个通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kHomePushNextNotification object:nil];
    }
}

//初始化UI
- (void)mInitUI {
    
}

//初始化数据
- (void)mInitData {
    
}

#pragma mark - 导航栏左侧按钮（返回按钮，个别页面需要重写监听该按钮的点击事件）
- (UIButton *)vBackBarButton {
    if (nil == _vBackBarButton) {
        UIImage *imageBack = [UIImage imageNamed:@"home_return_unpressed"];
        _vBackBarButton = [UIButton buttonWithType: UIButtonTypeCustom];
        _vBackBarButton.frame = CGRectMake(0, 0, imageBack.size.width, 44);
        _vBackBarButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _vBackBarButton.titleLabel.font = [UIFont boldSystemFontOfSize:(17)];
        [_vBackBarButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
        [_vBackBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
        [_vBackBarButton setImage:imageBack forState:UIControlStateNormal];
        _vBackBarButton.contentMode = UIViewContentModeLeft;
        [_vBackBarButton addTarget: self action: @selector(mTouchBackBarButton) forControlEvents: UIControlEventTouchUpInside];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView: _vBackBarButton];
        right.style = UIBarButtonItemStylePlain;
        self.navigationItem.leftBarButtonItem = right;
    }
    return _vBackBarButton;
}

//导航栏左边侧返回按钮的点击方法
- (void)mTouchBackBarButton {
    NSLog(@"导航栏左侧按钮的点击方法");
    [self.view endEditing:true];
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 导航栏右侧按钮
- (UIButton *)vRightBarButton {
    if (nil == _vRightBarButton) {
        _vRightBarButton = [UIButton buttonWithType: UIButtonTypeCustom];
        _vRightBarButton.frame = CGRectMake(0, 0, 60, 60);
        _vRightBarButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_vRightBarButton setTitleColor:[UIColor EKColorTitleWhite] forState:UIControlStateNormal];
        _vRightBarButton.titleLabel.font = [UIFont boldSystemFontOfSize:(15)];
        [_vRightBarButton setImageEdgeInsets:UIEdgeInsetsMake(0, 25, 0, -25)];
        [_vRightBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
        [_vRightBarButton addTarget: self action: @selector(mTouchRightBarButton) forControlEvents: UIControlEventTouchUpInside];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView: _vRightBarButton];
        right.style = UIBarButtonItemStylePlain;
        self.navigationItem.rightBarButtonItem = right;
    }
    return _vRightBarButton;
}

//导航栏右侧按钮的点击方法
- (void)mTouchRightBarButton {
    NSLog(@"导航栏右侧按钮的点击方法");
}

#pragma mark - 一级界面，导航栏左侧，侧边栏按钮
- (void)mSetNavLeftItem {
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navLeftView];
    } else {
        [self vBackBarButton];
    }
}

- (UIView *)navLeftView {
    if (!_navLeftView) {
        UIImage *imageMenu = [UIImage imageNamed:@"home_menu_unpressed"];
        _navLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageMenu.size.width, 44)];
        UIButton *expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        expandBtn.frame = CGRectMake(0, 0, 44, 44);
        [expandBtn setImage:imageMenu forState:UIControlStateNormal];
        [expandBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 10)];
        [_navLeftView addSubview:expandBtn];
        [expandBtn addTarget:self action:@selector(mNavExpandAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navLeftView;
}

- (void)mNavExpandAction {
    [self.view endEditing:YES];
    [EKColumnView animateColumnViewAction:YES];
}

#pragma mark - 点击侧边栏中cell，跳转下个页面的通知
- (void)pushNextViewController:(NSNotification *)object {
    [self showNextViewControllerName:@"BKThemeListViewController" params:[object object] isPush:YES];
}

- (void)showNextViewControllerName:(NSString *)name params:(NSDictionary *)params isPush:(BOOL)isPush {
    Class viewController = NSClassFromString(name);
    UIViewController *controller = [[viewController alloc] init];
    [controller setParames:params];
    if (isPush) {
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        EKNavigationViewController *nav = [[EKNavigationViewController alloc] initWithRootViewController:controller];
        [self presentViewController:nav animated:YES completion:nil];
    }
}


#pragma mark - 添加统计
- (void)mAddAnalyticsWithPageIndex:(NSString *)pageIndex googleString:(NSString *)googleString parameter:(NSDictionary *)parameter {
  
    //google统计
    [EKGoogleStatistics mGoogleActionAnalytics:pageIndex label:googleString];
  
    //umeng统计
    [MobClick event:pageIndex attributes:parameter];
    
    //用户追踪
    NSMutableDictionary *trackDict = [NSMutableDictionary dictionaryWithDictionary:parameter];
    //如果有uid参数,则需要去除掉uid参数
    //如果有且只有一个uid参数,则参数字典直接置为nil
    if ([parameter valueForKey:@"uid"]) {
        if (1 == parameter.count) {
            trackDict = nil;
        } else {
            [trackDict removeObjectForKey:@"uid"];
        }
    }
    [BKUserHelper trackingUserDataForType:pageIndex
                             dicExtraData:trackDict];
}
@end
