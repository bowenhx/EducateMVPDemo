/**
 - BKMobile
 - EKWebViewController.m
 - Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
 - Created by Guibin on 15/4/23.
 - 说明：webView页面
 */

#import "EKWebViewController.h"
#import <WebKit/WebKit.h>

@interface EKWebViewController () <UIWebViewDelegate,
                                   WKNavigationDelegate,
                                   WKUIDelegate> {
    WKWebView * wkWebView;
}
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation EKWebViewController

- (void)dealloc{
    [wkWebView setNavigationDelegate:nil];
    [wkWebView setUIDelegate:nil];
    [wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor EKColorBackground];
    [self.navigationController.navigationBar setHidden:NO];
    
    wkWebView = [[WKWebView alloc] init];
    wkWebView.navigationDelegate = self;
    wkWebView.UIDelegate = self;
    if ([_url isKindOfClass:[NSURL class]]) {
        [wkWebView loadRequest:[NSURLRequest requestWithURL:(NSURL *)_url]];
    }else if ([_url isKindOfClass:[NSString class]]){
        [wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    }
    [self.view addSubview:wkWebView];
    [wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAV_BAR_HEIGHT);
    }];
    
    //进度条
    _progressView = [[UIProgressView alloc] init];
    [self.view addSubview:_progressView];
    _progressView.trackTintColor = [UIColor EKColorWebViewProgressTrackTintColor];
    _progressView.progressTintColor = [UIColor EKColorWebViewProgressTintColor];
    CGFloat progressViewHeight = 3;
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAV_BAR_HEIGHT);
        make.height.mas_equalTo(progressViewHeight);
    }];
    [wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

}

#pragma mark - WKUIDelegate  新建窗口
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        if (navigationAction.request) {
            [webView loadRequest:navigationAction.request];
        }
    }
    return nil;
}

#pragma mark - WKNavigationDelegate

/**
 *  页面开始加载时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


/**
 *  当内容开始返回时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}


/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

/**
 *  加载失败时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 *  @param error      错误
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    [self.view showHUDTitleView:error.localizedDescription image:nil];
}


#pragma mark - 返回按钮点击事件
- (void)mTouchBackBarButton {
    if (wkWebView.canGoBack) {
        [wkWebView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
+ (void)showWebViewWithTitle:(NSString *)title forURL:(NSString *)url from:(UIViewController *)controller {
    if (![url hasPrefix:@"http"]) {
        if ([url hasPrefix:@"facebook"]) {
            //facebook url 为fb://
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://"]];
            return;
        }
        
        // 1.获取应用程序的URL Scheme
         NSURL *appBUrl = [NSURL URLWithString:url];
        // 2.判断手机中是否安装了对应程序
        if ([[UIApplication sharedApplication] canOpenURL:appBUrl]) {
            // 3. 打开应用程序
            [[UIApplication sharedApplication] openURL:appBUrl];
        } else {
            [[UIApplication sharedApplication].keyWindow showError:@"跳轉失敗"];
        }
    } else if ([url rangeOfString:@"opento=out"].location != NSNotFound) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    } else {
        EKWebViewController *webVC = [[EKWebViewController alloc] initWithNibName:@"EKWebViewController" bundle:nil];
        webVC.url = url;
        webVC.title = title;
        [controller.navigationController pushViewController:webVC animated:YES];
    }
}

#pragma mark - 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            _progressView.hidden = YES;
            [_progressView setProgress:0 animated:NO];
        } else {
            _progressView.hidden = NO;
            [_progressView setProgress:newprogress animated:YES];
        }
    }
}


@end
