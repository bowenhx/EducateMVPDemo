/**
 -  BADBaseView.m
 -  ADSDK
 -  Created by HY on 2017/3/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BADBaseView.h"
#import "BADSaveAdModel.h"

//在app内部打开点击链接
static NSString *kInApp = @"inApp:";

//在app外部打开点击链接
static NSString *kInbrowser = @"inBrowser:";

#define INIOS8 [[UIDevice currentDevice].systemVersion doubleValue] < 9.0

@interface BADBaseView () <UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation BADBaseView
- (void)dealloc {
    NSLog(@"%s",__func__);
}

#pragma mark - 初始设置方法
- (void)mSettingViewWithModel:(BADDetailModel *)bkAdModel {
    self.infoModel = bkAdModel;
    self.frame = CGRectMake((SCREEN_WIDTH - bkAdModel.width)/2, 0, bkAdModel.width, bkAdModel.height);

    //给广告view添加点击手势
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mTouchAdViewEvent)];
    recognizer.delegate = self;
    [self addGestureRecognizer:recognizer];
    
    //html类型广告
    [self mInitHtmlTypeAd];
}
 
#pragma mark - WKWebView懒加载
- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.allowsInlineMediaPlayback = YES;
        _wkWebView = [[WKWebView alloc] initWithFrame:self.bounds configuration:config];
        _wkWebView.userInteractionEnabled = YES;
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        _wkWebView.userInteractionEnabled = NO; //禁止点击
        [_wkWebView.scrollView setScrollEnabled:NO];//禁止滚动
        [self addSubview:_wkWebView];
    }
    return _wkWebView;
}

#pragma mark - html类型广告
- (void)mInitHtmlTypeAd {
    if (INIOS8) {
        [self writeFileContent:_infoModel.content];
    }
    self.content = _infoModel.content;
}

- (void)setContent:(NSString *)content {
//    if (INIOS8) {
//        [self readFile];
//    } else {
        //注：这里设置了baseurl，用于防止广告使用缓存，第二次显示空白问题
        [self.wkWebView loadHTMLString:content baseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://image.baby-kingdom%u.com", arc4random() % 1000000]]];
//    }
}


#pragma mark - WKNavigationDelegate
/*
 *  当内容加载完成时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self didFinishLoadAdView];
}

/*
 *  在发送请求之前，决定是否跳转到该请求
 *
 *  @param webView          实现该代理的webview
 *  @param navigationAction 当前navigation
 *  @param decisionHandler  是否调转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - 其他逻辑

#pragma mark - 广告显示完成
- (void)didFinishLoadAdView {
    
    //广告显示完成，发送请求告诉后台
    [self mSendSuccessForBackground];

    //存储当前请求成功的广告信息
    [self mSaveAdInfo];
    
}

//广告显示完成，发送请求告诉后台
- (void)mSendSuccessForBackground {
    if ([_infoModel.imptracker isKindOfClass:[NSArray class]]) {
        [_infoModel.imptracker enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            //防止后台返回一个数字，造成崩溃
            if ([obj isKindOfClass:[NSString class]]) {
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:(NSString *)obj]];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        NSLog(@"");
                    }] resume];
                });
            } else {
                DLog(@"后台返回数据异常 %s",__func__);
            }
            
        }];
    } else {
        DLog(@"后台返回数据异常 %s",__func__);
    }
}

//存储当前请求成功的广告信息
- (void)mSaveAdInfo {
    //主要存储当前广告的id,和显示时间，用于请求时候，广告显示间隔流程
    double todayTime =  [[NSDate new] timeIntervalSince1970];
    
    BADDetailModel *infoModel = [[BADDetailModel alloc] init];
    infoModel.bannerid = self.infoModel.bannerid;
    infoModel.deliveryInterval = self.infoModel.deliveryInterval;
    infoModel.lastShowTime = todayTime;
    
    //保存当前显示的广告id和时间
    [BADSaveAdModel mSaveAdModel:infoModel];
}

#pragma mark - 点击广告view
- (void)mTouchAdViewEvent {
    NSLog(@"点击广告view");
    //点击后跳转的地址，需要判断是在APP内打开还是打开到外部浏览器：[inApp:http://xxxxxx.com/aaa 在APP内打开地址； inbrowser:http://xxxxxxxxx/bbb 外部浏览器打开  ]

    NSString *url = self.infoModel.landing;

    if ([url rangeOfString:kInApp].location != NSNotFound) {
        //app内部打开链接
        url = [url substringFromIndex:kInApp.length];
        if ([self.baseDelegate respondsToSelector:@selector(mTouchAdViewWithUrl:)]) {
            [self.baseDelegate mTouchAdViewWithUrl:url];
        }
    } else if ([url rangeOfString:kInbrowser].location != NSNotFound) {
        //app外部浏览器打开
        url = [url substringFromIndex:kInbrowser.length];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}



#pragma mark - 广告在ios8上，部分html加载显示空白，下面方法是把html写入本地temp，然后读取再加载的方法，

//返回写入temp文件的路径
- (NSString *)mAdFilePath {
    NSString *tmpDir =  NSTemporaryDirectory(); //temp文件
    NSString *filepath = [tmpDir stringByAppendingPathComponent:[NSString stringWithFormat:@"ad_%@_%@.html",self.bkAdModel.display_type,self.infoModel.bannerid]];
    return filepath;
}

//将数据写入所创建的路径中
-(void)writeFileContent:(NSString *)html {
    NSString *filePath = [self mAdFilePath];
    BOOL writeResult =  [html writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"广告写入 %@",writeResult?@"YES":@"NO");
}

//通过路径读取文件的数据
-(void)readFile{
    NSString *tempPath = [self mAdFilePath];
    NSURL *filePath = [NSURL fileURLWithPath:tempPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:filePath];
    [self.wkWebView loadRequest:request];
}



@end
