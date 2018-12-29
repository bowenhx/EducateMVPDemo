//
//  RootWebViewController.m
//  EKHKAPP
//
//  Created by ligb on 2018/12/28.
//  Copyright © 2018 BaByKingdom. All rights reserved.
//

#import "RootWebViewController.h"

@interface RootWebViewController ()<UIWebViewDelegate,
WKNavigationDelegate,
WKUIDelegate,UIWebViewDelegate>
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) NSUInteger index;
@end

@implementation RootWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _index = 100;
    self.navigationItem.title = @"点击没反应，尝试点击右上角";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(didSelectPush)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
     UIView *toolbarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.h - 44, SCREEN_WIDTH, 44)];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, SCREEN_WIDTH, self.view.h - NAV_BAR_HEIGHT - toolbarView.h)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
//    _webView.layer.borderColor = [UIColor redColor].CGColor;
//    _webView.layer.borderWidth = 1;
   
    toolbarView.backgroundColor = [UIColor EKColorGray];
    [self.view addSubview:toolbarView];
    
    NSArray *images = @[@"首页", @"后退", @"前进", @"刷新"];
    float space = (SCREEN_WIDTH - 44 * 4 - 20) / 3;
    for (int i= 0; i< images.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10 + i * (44+space), 0, 44, 44);
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [toolbarView addSubview:button];
        button.tag = i;
        [button addTarget:self action:@selector(didSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    
    if ([_url isKindOfClass:[NSURL class]]) {
        [_webView loadRequest:[NSURLRequest requestWithURL:(NSURL *)_url]];
    } else if ([_url isKindOfClass:[NSString class]]){
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    }
    
}


- (void)didSelectAction:(UIButton *)btn {
    switch (btn.tag) {
        case 0:
        {
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
            break;
        }
        case 1:
        {
            [_webView goForward];
            break;
        }
        case 2:
        {
            [_webView goBack];
            break;
        }
        case 3:
        {
            [_webView reload];
            break;
        }
    }
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = [request.URL absoluteString];
    //拦截链接跳转
    if (url.length) {
        if ([url hasSuffix:@".mobileprovision"]) {
            [[UIApplication sharedApplication] openURL:request.URL];
            return NO;
        } else if ([url hasSuffix:@".plist"] && [url hasPrefix:@"itms-services:"] && _index == 100) {
            [_webView loadRequest:request];
            _index += 1;
        }
    }
    return YES;
}

- (void)didSelectPush {
    if (_url.length) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
    }
}

@end
