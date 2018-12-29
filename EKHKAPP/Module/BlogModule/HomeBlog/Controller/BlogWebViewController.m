#import "BlogWebViewController.h"
#import <WebKit/WebKit.h>
#import <Social/Social.h>

//用來保存查看日志的密碼
static NSString * BLOG_PASSWIRD_KEY =  @"BLOG_PASSWIRD_KEY";

@interface BlogWebViewController ()<UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate>

//日志分享url
@property (nonatomic , copy) NSString *shareUrl;

@end

@implementation BlogWebViewController

- (void)dealloc{
    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"日誌";
    self.view.backgroundColor = [UIColor EKColorBackground];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    //设置导航栏右侧,分享按钮
    [self.vRightBarButton setImage:[UIImage imageNamed:@"personal_share_unpressed"] forState:UIControlStateNormal];
    
    //验证密码
    [self verifyPassword];
}

- (void)loadRequest {
    //配置信息
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES;
    _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -64) configuration:config];
    _wkWebView.navigationDelegate = self;
    [_wkWebView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_wkWebView setBackgroundColor:[UIColor clearColor]];
    [_wkWebView setMultipleTouchEnabled:YES];
    [_wkWebView setUserInteractionEnabled:YES];
    [_wkWebView setContentMode:UIViewContentModeScaleAspectFill];
    [_wkWebView setAutoresizesSubviews:YES];
    [_wkWebView.scrollView setShowsHorizontalScrollIndicator:NO];
    [_wkWebView.scrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:_wkWebView];
    
    if ([self.url isKindOfClass:[NSURL class]]) {
        [_wkWebView loadRequest:[NSURLRequest requestWithURL:(NSURL *)self.url]];
    }else if ([self.url isKindOfClass:[NSString class]]){
        [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
}

#pragma mark - 验证日志详情页面需要密码查看
- (void)verifyPassword {
    //加密日志，如果日志是当前用户发表的，就不需要验证密码，可以直接打开看
    if (self.ispassword && self.uid != USERID) {
        //需要密码才能查看
        //需要密碼時
        NSDictionary *forumDic = [BKSaveData getDictionary:BLOG_PASSWIRD_KEY];
        if (forumDic) {
            //當字典有值，取出對應的密碼來驗證
            NSString *tempstr =[NSString stringWithFormat:@"blog_pw_%@",self.tid];
            NSString *pw = forumDic[tempstr];
            if ([BKTool isStringBlank:pw]) {
                //弹出密码输入框
                [self addAlertViewAction];
            }else{
                //验证密码请求
                [self verifyPasswordAction:pw showActivity:@"正在驗證..."];
            }
        } else {
            //弹出密码输入框
            [self addAlertViewAction];
        }
    } else {
        //验证密码请求
        [self verifyPasswordAction:@"" showActivity:@"正在獲取鏈接"];
    }
}

- (void)verifyPasswordAction:(NSString *)pw showActivity:(NSString *)text {
    [self.view showHUDActivityView:text shade:NO];
    __weak typeof(self) bself = self;
    [EKHttpUtil mHttpWithUrl:kBlogDetailURL parameter:@{@"token":TOKEN,@"id":self.tid,@"uid":self.uid,@"password":pw} response:^(BKNetworkModel *model, NSString *netErr) {
        [self.view removeHUDActivity];
        if (netErr) {
            [self.view showHUDTitleView:netErr image:nil];
        }else if (model.status == 1) {
            if ([model.data isKindOfClass:[NSDictionary class]]) {
                self.url = model.data[@"webviewurl"];
                self.shareUrl = model.data[@"shareurl"];
                [self loadRequest];
                
                //進入該頁面后，當密碼不為空時，存到本地字典中
                NSDictionary *dic = [BKSaveData getDictionary:BLOG_PASSWIRD_KEY];
                NSMutableDictionary *addPawDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                
                NSString *tempstr =[NSString stringWithFormat:@"blog_pw_%@",self.tid];
                [addPawDic setObject:pw forKey:tempstr];
                [BKSaveData setDictionary:addPawDic key:BLOG_PASSWIRD_KEY];
            }
        } else if (model.status == 0) {
            [bself.view showHUDTitleView:model.message image:nil];
        } else {
            [bself.view showHUDTitleView:@"密碼錯誤，請重新輸入" image:nil];
            //弹出密码输入框
            [self addAlertViewAction];
        }
    }];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.view showHUDActivityView:@"正在加載..." shade:NO];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"%s",  __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.view removeHUDActivity];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (error.code == NSURLErrorCancelled)   return;
    [self.view showHUDTitleView:error.localizedDescription image:nil];
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - UIAlertView
- (void)addAlertViewAction {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"加密日誌，請輸入密碼" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定", nil];
    //添加一个密码输入框
    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alertView show];
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.backgroundColor = [UIColor whiteColor];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.borderStyle = UITextBorderStyleNone;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){
        [super mTouchBackBarButton];
    } else {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if ([BKTool isStringBlank:textField.text]) {
            [self.view showHUDTitleView:@"输入密码才能訪問" image:nil];
        } else {
            //去验证密码是否正确
            [self verifyPasswordAction:textField.text showActivity:@"正在驗證..."];
        }
    }
}

#pragma mark - 分享按钮
- (void)mTouchRightBarButton {
    UIImage *imageToShare = [UIImage imageNamed:kShareImageName];
    [BKTool mSystemShare:self urlToShare:self.shareUrl textToShare:_name imageToShare:imageToShare];
}

@end
