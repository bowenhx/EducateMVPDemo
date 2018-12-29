//
//  CourseBaseViewController.m
//  EduKingdom
//
//  Created by HY on 16/7/7.
//  Copyright © 2016年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import "CourseBaseViewController.h"
#import "CourseSearchView.h"
#import "NewCourseView.h"
#import "CourseDirectoryView.h"
#import "CoursesSearchResultViewController.h"

@interface CourseBaseViewController ()<CourseSearchViewDelegate,NewCourseViewDelegate,CourseDirectoryViewDelegate>{
    CourseSearchView    *vSearchView;
    NewCourseView       *vNewView;
    CourseDirectoryView *vDirectoryView;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vCustomItemTopConstraint;

@end

@implementation CourseBaseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //添加广告
    [self mRequestInterstitialView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)mInitUI {
    self.navigationItem.title = @"課程搜索";
    //初始化三个子view，添加到滑动框架中
    vSearchView = [CourseSearchView mGetInstance];
    vSearchView.vDelegate = self;
    vNewView = [NewCourseView mGetInstance];
    vNewView.vDelegate = self;
    vDirectoryView = [CourseDirectoryView mGetInstance];
    vDirectoryView.vDelegate = self;
    [vCustomItem addItemView:@[vSearchView,vNewView,vDirectoryView] title:@[@"課程搜索",@"最新課程",@"課程目錄"] height:SCREEN_HEIGHT - NAV_BAR_HEIGHT - BOTTOM_TABBAR_HEIGHT];
    //适配ipX
    _vCustomItemTopConstraint.constant = NAV_BAR_HEIGHT;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - 课程搜索页面，点击搜索按钮代理方法
-(void)mSearchResoultClick:(NSDictionary *)dic{
    CoursesSearchResultViewController *vc = [[CoursesSearchResultViewController alloc] init];
    vc.vSourceParameter = dic;
    vc.vNavTitle = @"搜索結果";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 最新课程页面，点击cell的代理方法
-(void)mSelectRowClick:(CourseSearchModel *)model{
//    [EKWebViewController showWebViewWithTitle:@"課程詳情" forURL:model.weburl from:self];
}

#pragma mark - 课程目录页面，点击子分类的代理方法
-(void)mSelectDirectoryRowClick:(NSDictionary *)parameter title:(NSString *)title{
    //点击课程目录子分类，跳转到对应课程列表
    CoursesSearchResultViewController *vc = [[CoursesSearchResultViewController alloc] init];
    vc.vSourceParameter = parameter;
    vc.vNavTitle = title;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
