//
//  EKNavigationViewController.m
//  EKHKAPP
//
//  Created by ligb on 2017/9/22.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import "EKNavigationViewController.h"
#import "EKThemeDetailViewController.h"

@interface EKNavigationViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation EKNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航条背景
    self.navigationBar.barTintColor = [UIColor EKColorNavigation];
    //设置导航文字颜色
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
   
    self.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"home_return_unpressed"];
    
    //隐藏返回按钮后的文字，将返回按钮的文字position设置不在屏幕上显示
    [self.navigationItem.leftBarButtonItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-SCREEN_WIDTH, -SCREEN_HEIGHT) forBarMetrics:UIBarMetricsDefault];
    
    __weak typeof (self)weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    
    //注册打开帖子内容页的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mOpenThemeDetail:) name:kOpenTopicDetailNotification object:nil];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    if (self.viewControllers.count >0){
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


#pragma mark - 通知，通过外部超链接打开app到详情页面
- (void)mOpenThemeDetail:(NSNotification *)notification{
    NSNumber *tid = notification.object;
    if (tid) {
        EKThemeDetailViewController *detailViewController = [[EKThemeDetailViewController alloc] init];
        detailViewController.tid = tid;
        [self.visibleViewController.navigationController pushViewController:detailViewController animated:YES];
    } else {
        DLog(@"无id，无法跳转到详情页面 %s",__func__);
    }
    
}

@end
