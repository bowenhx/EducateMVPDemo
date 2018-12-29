//
//  ActivityWebVC.m
//  BKMobile
//
//  Created by 薇 颜 on 15/11/13.
//  Copyright © 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "ActivityWebVC.h"
#import <WebKit/WebKit.h>
@interface ActivityWebVC ()<WKNavigationDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@end

@implementation ActivityWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (iOS8) {
        WKWebView * webView = [[WKWebView alloc] init];
        webView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -64);
        webView.navigationDelegate = self;
        if ([_url isKindOfClass:[NSURL class]]) {
            [webView loadRequest:[NSURLRequest requestWithURL:(NSURL *)_url]];
        }else if ([_url isKindOfClass:[NSString class]]){
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
        }
        [self.view addSubview:webView];
    }else{
        _webView.backgroundColor = [UIColor EKColorBackground];
        [_webView setMultipleTouchEnabled:YES];
        [_webView setContentMode:UIViewContentModeScaleAspectFill];
        [_webView setAutoresizesSubviews:YES];
        [_webView setScalesPageToFit:YES];
        if ([_url isKindOfClass:[NSURL class]]) {
            [_webView loadRequest:[NSURLRequest requestWithURL:(NSURL *)_url]];
        }else if ([_url isKindOfClass:[NSString class]]){
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
        }
    }
    self.view.backgroundColor = [UIColor EKColorBackground];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor EKColorNavigation]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitSuccessForActivity{
    //alert
    [[[UIAlertView alloc] initWithTitle:nil message:@"申請已提交"
                       cancelButtonItem:[RIButtonItem itemWithLabel:@"確定" action:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdataRevertNotification object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    }] otherButtonItems:nil, nil] show];
}

#pragma mark - webView delegate
- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    //判断活动提交活动信息成功
    if ([url rangeOfString:@"http://bksubmit//success"].location != NSNotFound) {
        [self submitSuccessForActivity];
        return NO;
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.view showHUDActivityView:@"正在加載..." shade:NO];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.view removeHUDActivity];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.view showHUDTitleView:error.description image:nil];
}


#pragma mark - WKNavigationDelegate

/**
 *  在收到响应后,决定是否跳转
 *
 *  @param webView            实现该代理的webview
 *  @param navigationResponse 当前navigation
 *  @param decisionHandler    是否跳转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {

    NSString *url = navigationResponse.response.URL.absoluteString;
    //判断活动提交活动信息成功
    if ([url rangeOfString:@"http://bksubmit//success"].location != NSNotFound) {
        [self submitSuccessForActivity];
        decisionHandler(WKNavigationResponsePolicyCancel);
    }
    // 允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    
}

/**
 *  页面开始加载时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.view showHUDActivityView:@"正在加載..." shade:NO];
    NSLog(@"%s", __FUNCTION__);
}

/**
 *  当内容开始返回时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.view removeHUDActivity];
    NSLog(@"%s", __FUNCTION__);
}
/**
 *  加载失败时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 *  @param error      错误
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (error.code == NSURLErrorCancelled)  return;
    [self.view showHUDTitleView:error.localizedDescription image:nil];
    NSLog(@"%s", __FUNCTION__);
}

@end
