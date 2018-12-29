/**
 -  EKHomeWebViewController.m
 -  EKHKAPP
 -  Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
 -  Created by Guibin on 15/1/6.
 -  说明:这是"首页"跳转到的web控制器,内部包含对FaceBook和KMall等的处理
 */

#import "EKHomeWebViewController.h"
#import "BKUserHelper.h"

@interface EKHomeWebViewController () <WKNavigationDelegate,
                                       WKScriptMessageHandler,
                                       WKUIDelegate> {
    WKWebView *_wkWebView;
    NSMutableURLRequest *request;
    NSMutableArray *_location;
    WKBackForwardListItem *_lastItem;
    NSString *_lastIfrmaeUrl;
}
//进度条
@property (nonatomic, strong) UIProgressView *progressView;
@property(nonatomic, strong) WKWebViewConfiguration *wvc;
@end

@implementation EKHomeWebViewController
- (void)dealloc{
    [_wkWebView setNavigationDelegate:nil];
    [_wkWebView setUIDelegate:nil];
    [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //在这里开启JS交互参数
    [_wvc.userContentController addScriptMessageHandler:self name:@"kmlocation"];
    [_wvc.userContentController addScriptMessageHandler:self name:@"kmreload"];
    [_wvc.userContentController addScriptMessageHandler:self name:@"kmlocationcurrent"];
    [_wvc.userContentController addScriptMessageHandler:self name:@"iframe"];
    [_wvc.userContentController addScriptMessageHandler:self name:@"kmclose"];
}

//在这里释放JS交互参数,防止循环引用
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"kmlocation"];
    [_wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"kmreload"];
    [_wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"kmlocationcurrent"];
    [_wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"iframe"];
    [_wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"kmclose"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _location = [NSMutableArray array];
    _lastItem = nil;
    _lastIfrmaeUrl = nil;
    self.view.backgroundColor = [UIColor EKColorBackground];
    [self setWebView];
}

- (void)setWebView{
    
    //爸妈tv的web不要设置userAgent代理，否则会导致部分video无法播放
    if (self.vWebPageType == WebPageTypeNormal) {
        //用户代理，防止点击facebook/google登录，无法跳转界面的问题
        NSString *userAgent = @"Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_3 like Mac OS X) AppleWebKit/603.3.8 (KHTML, like Gecko) Version/10.0 Mobile/14G60 Safari/602.1";
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : userAgent}];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //注入js，防止点击facebook登录，无法跳转界面的问题
    NSString *js = @"\
    window.open=function(target){\
    window.webkit.messageHandlers.kmlocation.postMessage(window.location.href);\
    location.href=target;\
    };\
    var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}\
    window.webkit.messageHandlers.kmlocationcurrent.postMessage(window.location.href);\
    window.close = function(){window.webkit.messageHandlers.kmclose.postMessage('window.close');};\
    window.opener = {};\
    window.opener.location = {};\
    window.opener.location.replace = function(e){window.webkit.messageHandlers.iframe.postMessage(e);};\
    window.opener.location.closed = 0;\
    window.opener.location.reload = function(r){\
    window.webkit.messageHandlers.kmreload.postMessage(location.href);\
    };";
    
    //WKWebViewConfiguration
    self.wvc = [[WKWebViewConfiguration alloc] init];
    WKUserScript *mainScript = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    [_wvc.userContentController addUserScript:mainScript];

    _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:_wvc];
    _wkWebView.navigationDelegate = self;
    _wkWebView.UIDelegate = self;
    _wkWebView.backgroundColor = [UIColor EKColorBackground];
    [self.view addSubview:_wkWebView];
    [_wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NAV_BAR_HEIGHT);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    //设置进度条
    [self.view insertSubview:_wkWebView belowSubview:self.progressView];
    [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_vUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    //设置缓存，如果用户是登录状态，要同步登录kmall
    if (LOGINSTATUS) {
        [request setValue:[BKUserHelper setKmallWebCookies] forHTTPHeaderField:@"Cookie"];
    }
    [_wkWebView loadRequest:request];
}


// JS调用OC时会走此代理方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"kmlocationcurrent"]) {
        if ([message.body rangeOfString:@"facebook.com/plugins/close_popup.php"].location != NSNotFound) {
            if (_lastItem && ![self isFacebookLogin]) {
                [_wkWebView goToBackForwardListItem:_lastItem];
                _lastItem = nil;
            }
        }
    }
    if ([message.name isEqualToString:@"kmclose"]) {
        if (_lastItem) {
            [_wkWebView goToBackForwardListItem:_lastItem];
            _lastItem = nil;
        }
    }
    if ([message.name isEqualToString:@"iframe"]) {
        _lastIfrmaeUrl = message.body;
    }
    if ([message.name isEqualToString:@"kmlocation"]) {
        [_location addObject:message.body];
        if (!_lastItem) {
            _lastItem = _wkWebView.backForwardList.currentItem;
        }
    } else if ([message.name isEqualToString:@"kmreload"]) {
        NSInteger index = _location.count - 1;
        if (_location.count > 1) {
            if ([_location containsObject:message.body]) {
                NSInteger adIndex = [_location indexOfObject:message.body];
                index = adIndex - 1 >= 0 ? : 0;
            }
        }
        NSString *url = _location[index];
        [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
}


//新建窗口
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (![navigationAction.targetFrame isMainFrame]) {
        if (!_lastItem) {
            _lastItem = webView.backForwardList.currentItem;
        }
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark - WKNavigationDelegate
//页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {}


//当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {}


//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (_lastIfrmaeUrl) {
        NSString *js = [NSString stringWithFormat: @"var ifr = document.querySelector(\"iframe[title='fb:like Facebook Social Plugin']\");ifr.contentWindow.location.replace(\"%@\");", _lastIfrmaeUrl];
        [webView evaluateJavaScript:js completionHandler:nil];
        _lastIfrmaeUrl = nil;
    }
}


//加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    [self.view showHUDTitleView:error.localizedDescription image:nil];
}


//在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - 逻辑处理

- (int)getRandomNumber:(int)from to:(int)to{
    return (int)(from + (arc4random() % (to - from + 1)));
}


#pragma mark - 返回按钮点击事件
- (void)mTouchBackBarButton {
    if (_wkWebView.canGoBack) {
        if (_lastItem) {
            [_wkWebView goToBackForwardListItem:_lastItem];
            _lastItem = nil;
        } else {
            [_wkWebView goBack];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - 判断facebook是否登录的逻辑
- (BOOL)isFacebookLogin {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *arr = storage.cookies;
    __block BOOL has = NO;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSHTTPCookie *ce = arr[idx];
        if ([ce.name isEqualToString:@"c_user"]) {
            has = YES;
        }
    }];
    return has;
}


#pragma mark - ***** 进度条
- (UIProgressView *)progressView {
    if (!_progressView) {
        UIProgressView *progressView = [[UIProgressView alloc] init];
        [self.view addSubview:progressView];
        progressView.trackTintColor = [UIColor EKColorWebViewProgressTrackTintColor];
        progressView.progressTintColor = [UIColor EKColorWebViewProgressTintColor];
        
        CGFloat progressViewHeight = 3;
        [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(NAV_BAR_HEIGHT);
            make.height.mas_equalTo(progressViewHeight);
        }];
        self.progressView = progressView;
    }
    return _progressView;
}


#pragma mark - 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == _wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        } else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}


+ (void)showHomeWebViewControllerWithTitle:(NSString *)title
                                 URLString:(NSString *)URLString
                        fromViewController:(UIViewController *)viewController
                                  pageType:(WebPageType)pageType
{
    EKHomeWebViewController *homeWebViewController = [[EKHomeWebViewController alloc] init];
    homeWebViewController.navigationItem.title = title;
    homeWebViewController.vUrl = URLString;
    homeWebViewController.vWebPageType = pageType;
    [viewController.navigationController pushViewController:homeWebViewController animated:YES];
}

@end
