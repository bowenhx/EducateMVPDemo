//
//  MessageWebViewController.m
//  BKMobile
//
//  Created by ligb on 2017/5/18.
//  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "MessageWebViewController.h"
#import <WebKit/WebKit.h>
#import "MessageInputView.h"
#import "UIScrollView+KeyboardControl.h"
#import "Message.h"
#import "EmotionView.h"
#import "EKUserInformationViewController.h"
#import "EKWebViewController.h"
#import "BKFaceManage.h"

#define FACE_VIEW_HEIGHT  (SCREEN_WIDTH / 7 * 4 + 37)

NSString * const webScriptMessage  = @"skipUserCenter";
NSInteger const webViewTopHtight   = 64;
NSInteger const messageInputHeight = 52;
NSInteger const keyboardHeight     = 216;

@interface MessageWebViewController ()<WKNavigationDelegate,
                                       WKScriptMessageHandler,
                                       UIScrollViewDelegate,
                                       WKUIDelegate,
                                       MessageInputViewDelegate,
                                       EmotionViewDelegate,
                                       EmotionViewDataSource>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) MessageInputView *inputView;

@property (nonatomic, strong) EmotionView   *emotionView;

//记录滑动范围，作用与键盘view和表情view 弹出是改变webView 的scrollView 的contentOffset
@property (nonatomic, assign) NSInteger lastContentOffsetY;

//记录webView 的ScrollView 的contentOffset值，方便再次显示时页面不在之前的可视范围内
@property (nonatomic, assign) CGPoint contentOffset;

//判断是否跳转到个人资料页面
@property (nonatomic, assign) BOOL  targetFrame;

//记录旧的textView contentSize Heigth
@property (nonatomic, assign) CGFloat previousTextViewContentHeight;

@end

@implementation MessageWebViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:_inputView.inputTextView];
}

- (void)tapBackBtn{
   
    [_webView.scrollView disSetupPanGestureControlKeyboardHide:NO];
    _webView.navigationDelegate = nil;
    _webView.scrollView.delegate = nil;
    _webView = nil;
    
    [_inputView removeFromSuperview];
    [_emotionView removeFromSuperview];
    
    [super mTouchBackBarButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = self.friendName;
    
    [self registerNotificationCenter];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _targetFrame = NO;
    if (_contentOffset.y > 0) {
        _webView.scrollView.contentOffset = _contentOffset;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:webScriptMessage];
}

- (void)mInitUI {
    @WEAKSELF(self);
    self.webView.scrollView.keyboardWillChange = ^(CGRect keyboardRect, UIViewAnimationOptions options, double duration, BOOL showKeyborad) {
        [UIView animateWithDuration:duration delay:0.3f options:options animations:^{
            CGFloat keyboardY = [selfWeak.view convertRect:keyboardRect fromView:nil].origin.y - selfWeak.inputView.h;
            CGFloat messageBottom = selfWeak.view.h - selfWeak.inputView.h;
            
            [selfWeak.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(MIN(keyboardY, messageBottom));
            }];
            
            [selfWeak.webView.scrollView setContentOffset:CGPointMake(0, selfWeak.webView.scrollView.contentSize.height - keyboardHeight) animated:YES];
            
        } completion:nil];
    };
}

- (void)mInitData {
    if (_webURL) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            _webURL = [_webURL stringByAppendingString:@"&ipadflag=1"];
        }
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webURL]]];
    } else {
        [self.view showError:@"獲取私訊出錯"];
    }
   
}


/**
 添加textView 通知
 */
- (void)registerNotificationCenter{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged:) name:UITextViewTextDidChangeNotification object:self.inputView.inputTextView];
    
    [self.webView.scrollView setupPanGestureControlKeyboardHide:NO];

}

#pragma mark - NSNotification
- (void)textDidChanged:(NSNotification *)notif //监听文字改变 换行时要更改输入框的位置
{
    CGFloat maeight = [MessageInputView maxHeight];
    
    CGFloat contentH = ceilf([self.inputView.inputTextView sizeThatFits:self.inputView.inputTextView.size].height);
    
    BOOL isShrinking = contentH < _previousTextViewContentHeight;
    CGFloat changeInHeight = contentH - _previousTextViewContentHeight;
    
    if (!isShrinking && (_previousTextViewContentHeight == maeight || !_inputView.inputTextView.text.length)) {
        changeInHeight = 0.f;
    } else {
        changeInHeight = MIN(changeInHeight, maeight - _previousTextViewContentHeight);
    }
    
    if (changeInHeight) {
        [UIView animateWithDuration:.3 animations:^{
            [_inputView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_inputView.y - changeInHeight);
                make.height.mas_equalTo(_inputView.h + changeInHeight);
            }];

            [self.inputView adjustTextViewHeightBy:changeInHeight];
        }];
        self.previousTextViewContentHeight = MIN(contentH, maeight);
    }
    
    
    if (self.previousTextViewContentHeight == maeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           CGPoint bottomOffset = CGPointMake(0.f, contentH - self.inputView.inputTextView.h);
                           [self.inputView.inputTextView setContentOffset:bottomOffset animated:YES];
                       });
    }

    
}


#pragma mark
#pragma mark WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSDictionary *body = message.body;
    NSLog(@"body = %@",body);
    if ([body isKindOfClass:[NSDictionary class]]) {
        _targetFrame = YES;
        EKUserInformationViewController *userInformationViewController = [[EKUserInformationViewController alloc] init];
        userInformationViewController.userImageURLString = body[@"userAvatar"];
        userInformationViewController.uid = body[@"uid"];
        userInformationViewController.name = body[@"userName"];
        
        [self.navigationController pushViewController:userInformationViewController animated:YES];
    }
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString *url = navigationAction.request.URL.absoluteString;
    
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        if (!_targetFrame) {
            [EKWebViewController showWebViewWithTitle:@"" forURL:url from:self];
            decisionHandler(WKNavigationActionPolicyCancel);
        } else {
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    } else {
        //允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
//    [self.view removeHUDActivity];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //webView 加载完成时，记录下contentOffset
    _contentOffset = webView.scrollView.contentOffset;
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
//     [self.view showHUDActivityView:@"正在加載..." shade:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self.view showHUDTitleView:error.localizedDescription image:nil];
}



- (void)finishSendMessage{
    [self.inputView.inputTextView setText:nil];
    self.inputView.inputTextView.enablesReturnKeyAutomatically = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.inputView.inputTextView.enablesReturnKeyAutomatically = YES;
        [self.inputView.inputTextView reloadInputViews];
        [self hiddenEmotionViewOrInputView];
    });
    
    [self textDidChanged:nil];
}


/**
 取消键盘，并且影藏表情view
 */
- (void)hiddenEmotionViewOrInputView{
    if (self.inputView.inputTextView.isFirstResponder) {
        [self.inputView.inputTextView resignFirstResponder];
    }
    
    //适配iphonex
    CGFloat topSpace = 0;
    if (IPHONEX) {
        topSpace = IPHONEX_BottomAddHeight;
    }
    
    if (self.emotionView.y < self.view.h) {
        UIButton *faceBtn = [_inputView viewWithTag:1];
        faceBtn.selected = NO;
        [UIView animateWithDuration:.3f animations:^{
            [_emotionView setY:self.view.h];
           
            [_inputView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view.h - messageInputHeight - topSpace);
            }];
        }];
        //发送完消息后显示最底部
        _lastContentOffsetY = 0;
    }

}

#pragma mark
#pragma mark MessageInputViewDelegate
/**
 *  输入框刚好开始编辑
 *
 *  @param messageInputTextView 输入框对象
 */
- (void)inputTextViewDidBeginEditing:(ChatMessageTextView *)messageInputTextView{
    //重新设定offset值，防止weiView滑动与键盘消失冲突
    _lastContentOffsetY = 0;
}

/**
 *  输入框将要开始编辑
 *
 *  @param messageInputTextView 输入框对象
 */
- (void)inputTextViewWillBeginEditing:(ChatMessageTextView *)messageInputTextView{
    if (!_previousTextViewContentHeight)
        _previousTextViewContentHeight = ceilf([messageInputTextView sizeThatFits:messageInputTextView.frame.size].height);
}

/**
 *  发送文本消
 *
 *  @param text 目标文本消息
 */
- (void)didSendTextAction:(NSString *)text{
    if (!text.length) {
        [self.view showHUDTitleView:@"信息內容不能為空！" image:nil];
        return;
    }
    [self.view showHUDActivityView:@"正在發送..." shade:NO];
    //处理特殊字符
    NSString *sendMessage = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)text, nil, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8));
    NSDictionary *parameter = @{@"token":TOKEN, @"message": sendMessage, @"touid": _friendUID};
    [EKHttpUtil mHttpWithUrl:kMessageSendURL parameter:parameter response:^(BKNetworkModel *model, NSString *netErr) {
        //发送失败
        [self.view removeHUDActivity];
        
        if (netErr) {
            [self.view showHUDTitleView:netErr image:nil];
        }else {
            if (model.status == 1) {
                [self.webView reload];
                [self finishSendMessage];
                [self.view showSuccess:model.message];
            }else{
                [self.view showHUDTitleView:model.message image:nil];
            }
        }
    }];

}

/**
 *  发送表情
 *
 *  @param facePath 目标表情的本地路径
 */
- (void)didSendFaceAction:(BOOL)sendFace{
    if (sendFace) {
        [self layoutOtherMenuViewHiden:NO];
    } else {
        [self.inputView.inputTextView becomeFirstResponder];
    }
}


/**
 选择相册或者拍照
 */
- (void)didSendImageAction{
    
}


#pragma mark - EmotionViewDataSource
- (NSArray *)emotionList{
    return [BKFaceManage sharedInstance].vSmiliesArray;
}


#pragma mark EmotionViewDelegate
- (void)didSelecteEmotion:(SmiliesButton *)emotion{
    _inputView.inputTextView.text = [NSString stringWithFormat:@"%@%@", _inputView.inputTextView.text, emotion.search];
}



#pragma mark - Other Menu View Frame Helper Mehtod

- (void)layoutOtherMenuViewHiden:(BOOL)hide {
    [self.inputView.inputTextView resignFirstResponder];
    self.emotionView.alpha = 0;
    [UIView animateWithDuration:0.2 delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        __block CGRect inputViewFrame = self.inputView.frame;
        __block CGRect otherMenuViewFrame;
        
        void (^InputViewAnimation)(BOOL hide) = ^(BOOL hide) {
            [_inputView mas_updateConstraints:^(MASConstraintMaker *make) {
                if (hide) {
                    make.top.mas_equalTo(self.view.h - _inputView.h);
                } else {
                    make.top.mas_equalTo(CGRectGetMinY(otherMenuViewFrame) - CGRectGetHeight(inputViewFrame));
                }
            }];
            
        };
        
        void (^EmotionManagerViewAnimation)(BOOL hide) = ^(BOOL hide) {
            otherMenuViewFrame = _emotionView.frame;
            otherMenuViewFrame.origin.y = (hide ? CGRectGetHeight(self.view.frame) : (CGRectGetHeight(self.view.frame) - CGRectGetHeight(otherMenuViewFrame)));
            _emotionView.alpha = !hide;
            _emotionView.frame = otherMenuViewFrame;
        };
        
        EmotionManagerViewAnimation(hide);
        InputViewAnimation(hide);
        [_webView.scrollView setContentOffset:CGPointMake(0, _webView.scrollView.contentSize.height -  keyboardHeight) animated:NO];
    } completion:^(BOOL finished) {
    }];
}



#pragma mark UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _lastContentOffsetY = scrollView.contentOffset.y;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < _lastContentOffsetY) {
        //向上
        [self hiddenEmotionViewOrInputView];
    } else if (scrollView.contentOffset.y > _lastContentOffsetY) {
        //向下
    }
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _contentOffset = scrollView.contentOffset;
}

#pragma mark
#pragma  mark init items

- (WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        //注入JS 事件
        [configuration.userContentController addScriptMessageHandler:self name:webScriptMessage];
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.delegate = self;
        _webView.scrollView.backgroundColor = [UIColor EKColorBackground];
        [self.view addSubview:_webView];
        
        //适配iphonex
        CGFloat topSpace = 0;
        if (IPHONEX) {
            topSpace = IPHONEX_BottomAddHeight;
        }
        
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(webViewTopHtight);
            make.bottom.equalTo(self.view).offset(-messageInputHeight - topSpace);
        }];
    }
    return _webView;
}


/**
 键盘输入框view

 @return inputView
 */
- (MessageInputView *)inputView{
    if (!_inputView) {
        _inputView = [[MessageInputView alloc] initWithFrame:CGRectZero];
        [_inputView setDelegate:self];
        [_inputView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_inputView];
        //适配iphonex
        CGFloat topSpace = 0;
        if (IPHONEX) {
            topSpace = IPHONEX_BottomAddHeight;
        }
        [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.h - messageInputHeight - topSpace);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(messageInputHeight);
        }];
    }
    [self.view bringSubviewToFront:_inputView];
    return _inputView;
}


/**
 表情view

 @return emotionView
 */
- (EmotionView *)emotionView{
    if (!_emotionView) {
        _emotionView = [[EmotionView alloc] initWithFrame:CGRectMake(0.f, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), FACE_VIEW_HEIGHT)];
        _emotionView.delegate = self;
        _emotionView.dataSource = self;
        _emotionView.backgroundColor = [UIColor whiteColor];
        _emotionView.alpha = 0.0;
        [self.view addSubview:_emotionView];
    }
    return _emotionView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
