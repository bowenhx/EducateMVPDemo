/**
 - BKMobile
 - EKWebViewController.h
 - Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
 - Created by Guibin on 15/4/23.
 - 说明：webView页面
 */

#import "EKBaseViewController.h"

@interface EKWebViewController : EKBaseViewController
@property (nonatomic, strong) WKWebView *vWebView;
@property (nonatomic , copy) NSString *url;
+ (void)showWebViewWithTitle:(NSString *)title forURL:(NSString *)url from:(UIViewController *)controller;

@end

