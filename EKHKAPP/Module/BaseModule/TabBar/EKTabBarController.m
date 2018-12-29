/**
 -  EKTabBarController.m
 -  EKHKAPP
 -  Created by HY on 2017/9/7.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "EKTabBarController.h"
#import "EKNavigationViewController.h"
#import "UIColor+app.h"

@interface EKTabBarController () <UITabBarControllerDelegate>

@end

@implementation EKTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViewControllers];
    
    [self addNotification];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectIndex:) name:kTabbarIndexChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mShowRedBadge) name:kRemotePushNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mRemoveRedBadge) name:kNoRemotePushNotification object:nil];
}

#pragma mark - 添加所有子控制器
- (void)addViewControllers {
    //准备所有控制器的参数
    NSArray *childViewControllerArray = @[
                                          @{@"className":@"EKHomeViewController", @"icon":@"home", @"title":@"首頁"},
//                                          @{@"className":@"EKSchoolAreaViewController", @"icon":@"school", @"title":@"學校"},
                                          @{@"className":@"CourseBaseViewController", @"icon":@"course", @"title":@"課程"},
//                                          @{@"className":@"BlogViewController", @"icon":@"log", @"title":@"日誌"},
                                          @{@"className":@"EKMyCenterViewController", @"icon":@"my", @"title":@"我的"},
                                          ];
    //遍历数组,创建导航控制器,并设置标签控制器的子控制器
    NSMutableArray <UINavigationController *> *tempMutableArray = [NSMutableArray array];
    for (NSDictionary *dictionary in childViewControllerArray) {
        EKNavigationViewController *navigationViewController = [self mCreateControllerWithDictionary:dictionary];
        [tempMutableArray addObject:navigationViewController];
    }
    self.viewControllers = tempMutableArray;
    self.tabBar.barTintColor = [UIColor EKColorNavigation];
    self.tabBar.translucent = NO; //取消tabBar的透明效果。
    self.delegate = self;
}

#pragma mark - 创建子控制器
- (EKNavigationViewController *)mCreateControllerWithDictionary:(NSDictionary *)dictionary {
    //1.创建控制器
    NSString *className = dictionary[@"className"];
    Class viewControllerClass = NSClassFromString(className);
    UIViewController *viewController = [[viewControllerClass alloc] init];
    //2.设置tabBarItem图标
    NSString *unpressedImageName = [NSString stringWithFormat:@"tab_%@_unpressed",dictionary[@"icon"]];
    NSString *pressedImageName = [NSString stringWithFormat:@"tab_%@_pressed",dictionary[@"icon"]];
    viewController.tabBarItem.image = [[UIImage imageNamed:unpressedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:pressedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (IS_IPAD) {
        [viewController.tabBarItem setImageInsets:UIEdgeInsetsMake(0, -37, 0, 37)]; //移动图片的位置
    } else {
        [viewController.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)]; //移动图片的位置
    }
    //3.设置导航条标题
    viewController.navigationItem.title = dictionary[@"title"];
    
    return [[EKNavigationViewController alloc] initWithRootViewController:viewController];
}


- (void)didSelectIndex:(NSNotification *)obj {
    NSInteger index = [[obj object] integerValue];
    self.tabBarController.selectedIndex = index;
}


//在"我的"显示未读消息提醒小红点
- (void)mShowRedBadge {
    if (LOGINSTATUS) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor redColor];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 5;//圆形
        label.tag = 888;
        
        //确定小红点的位置
        float percentX = (4 + 0.6) / 5; //3代表item的索引值，5代表总数
        CGFloat x = ceilf(percentX * self.tabBar.size.width);
        CGFloat y = 5;
        label.frame = CGRectMake(x, y, 10, 10);//圆形大小为10
        [self.tabBar addSubview:label];
    }
}


//移除"我的"小红点
- (void)mRemoveRedBadge {
    //按照tag值进行移除
    for (UIView *subView in self.tabBar.subviews) {
        if (subView.tag == 888) {
            [subView removeFromSuperview];
        }
    }
}


@end
