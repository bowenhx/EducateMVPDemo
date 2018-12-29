//
//  EKHomeADView.m
//  EKHKAPP
//
//  Created by HY on 2017/11/15.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import "EKHomeADView.h"

@interface EKHomeADView()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation EKHomeADView

+ (EKHomeADView *)mGetInstanceWithUrl:(NSString *)url{
    EKHomeADView *view = [[[NSBundle mainBundle] loadNibNamed:@"EKHomeADView" owner:nil options:nil] firstObject];
    if (view) {
        [view mInitView:url];
    }
    return view;
}

- (void)mInitView:(NSString *)url {

    //配置信息
    WKWebViewConfiguration *config=[[WKWebViewConfiguration alloc] init];
    config.mediaPlaybackRequiresUserAction = NO;//开启自动播放
    config.allowsInlineMediaPlayback = YES;         //内联播放
    config.mediaPlaybackAllowsAirPlay = YES;
    
    _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    _wkWebView.backgroundColor = [UIColor clearColor];
    _wkWebView.navigationDelegate = self;
    [_wkWebView.scrollView setScrollEnabled:NO];//禁止滚动
    [self addSubview:_wkWebView];
    [_wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

//    NSString * turl = @"http://bapi.edu-kingdom.com/tag/ekad_api.php?width=1080&device=android&uid=0&position=1&action=index";

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_wkWebView loadRequest:request];
 
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *url = [[navigationAction.request URL] absoluteString];
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        //打开url
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    // 允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

@end
