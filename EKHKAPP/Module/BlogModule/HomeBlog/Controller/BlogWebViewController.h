/**
 -  BlogWebViewController.h
 -  EKHKAPP
 -  Created by HY on 2017/11/1.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：日志详情页面，web，含分享
 */

@interface BlogWebViewController : EKBaseViewController
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic , copy) NSString *url;
@property (nonatomic , copy)NSString *tid;  //帖子tid or 日誌id
@property (nonatomic , copy)NSString *name; //帖子標題 or 日誌標題
@property (nonatomic , copy)NSString *uid; //日志所属用户id
@property (nonatomic , assign) NSInteger ispassword;
@end
