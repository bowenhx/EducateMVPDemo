/**
 -  EKHomeWebViewController.h
 -  EKHKAPP
 -  Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
 -  Created by Guibin on 15/1/6.
 -  说明:这是"首页"跳转到的web控制器,内部包含对FaceBook和KMall等的处理
 */

#import "EKBaseViewController.h"

/**
 进入该web页面后，页面类型

 - Web_Page_Type_Normal: 普通的web跳转，例如：KMall，BKMilk
 - Web_Page_Type_TV: 爸妈TV页面，不设置UserAgent代理，防止video无法播放
 
 */
typedef NS_ENUM (NSUInteger, WebPageType) {
    WebPageTypeNormal = 0,
    WebPageTypeVideo
};


@interface EKHomeWebViewController : EKBaseViewController

@property (nonatomic, strong) NSString *vUrl;

@property (nonatomic, assign) WebPageType vWebPageType;

/**
 跳转到当前界面

 @param title 设置标题
 @param URLString webView要打开的URL的字符串
 @param viewController 从哪个控制器跳转
 @param pageType  页面类型
 */
+ (void)showHomeWebViewControllerWithTitle:(NSString *)title
                                 URLString:(NSString *)URLString
                        fromViewController:(UIViewController *)viewController
                                  pageType:(WebPageType)pageType;
;
@end
