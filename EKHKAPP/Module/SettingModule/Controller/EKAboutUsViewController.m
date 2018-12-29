/**
 -  EKAboutUsViewController.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/8.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是从"设置"界面进入的"关于我们"界面
 */

#import "EKAboutUsViewController.h"
#import "EKAboutUsCellModel.h"
#import "EKAboutUsHeaderView.h"

static NSString *aboutUsCellID = @"aboutUsCellID";

@interface EKAboutUsViewController () <UITableViewDataSource,
                                       UITableViewDelegate>
@property (nonatomic, strong) UITableView *vTableView;
//底部的显示大小版本号的label
@property (nonatomic, strong) UILabel *vBottomLabel;
@property (nonatomic, strong) NSArray <EKAboutUsCellModel *> *vAboutUsCellModelArray;
@end

@implementation EKAboutUsViewController

#pragma mark - 初始化UI
- (void)mInitUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"關於我們";
    self.view.backgroundColor = [UIColor EKColorBackground];
    [self mInitTableView];
    [self mInitBottomLabel];
}


- (void)mInitTableView {
    _vTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_vTableView];
    [_vTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAV_BAR_HEIGHT);
    }];
    _vTableView.bounces = NO;
    _vTableView.dataSource = self;
    _vTableView.delegate = self;
    _vTableView.tableFooterView = [[UIView alloc] init];
    _vTableView.backgroundColor = [UIColor EKColorBackground];
    _vTableView.rowHeight = 43;
    _vTableView.separatorInset = UIEdgeInsetsZero;
    _vTableView.separatorColor = [UIColor EKColorSeperateWhite];
    //注册头部视图和cell
    [_vTableView registerClass:[EKAboutUsHeaderView class] forHeaderFooterViewReuseIdentifier:aboutUsHeaderViewID];
    [_vTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:aboutUsCellID];
}


//设置底部的大小版本号label
- (void)mInitBottomLabel {
    _vBottomLabel = [[UILabel alloc] init];
    [self.view addSubview:_vBottomLabel];
    CGFloat bottomLabelBottomMargin = -10;
    [_vBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(bottomLabelBottomMargin);
    }];
    // 获取app版本&build版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
    _vBottomLabel.text = [NSString stringWithFormat:@"version %@  build %@",version,build];
    _vBottomLabel.textColor = [UIColor lightGrayColor];
    _vBottomLabel.font = [UIFont systemFontOfSize:14];
}


#pragma mark - 初始化数据
- (void)mInitData {
    _vAboutUsCellModelArray = [EKAboutUsCellModel mGetAboutUsCellModelArray];
}


#pragma mark - UITableViewDataSource
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _vAboutUsCellModelArray.count;
}


//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:aboutUsCellID forIndexPath:indexPath];
    tableViewCell.textLabel.text = _vAboutUsCellModelArray[indexPath.row].vTitle;
    tableViewCell.textLabel.font = [UIFont systemFontOfSize:15];
    tableViewCell.textLabel.textColor = [UIColor EKColorTitleBlack];
    tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return tableViewCell;
}


#pragma mark - UITableViewDelegate
//返回组头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    EKAboutUsHeaderView *aboutHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:aboutUsHeaderViewID];
    return aboutHeaderView;
}


// 返回组头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SCREEN_HEIGHT / 3;
}


//点击cell时候调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //从数组中获取要执行的方法名
    NSString *selectorName = _vAboutUsCellModelArray[indexPath.row].vSelectorName;
    if (!selectorName) {
        return;
    }
    //从数组中获取要执行的方法名
    SEL selector = NSSelectorFromString(selectorName);
    IMP imp = [self methodForSelector:selector];
    void (*func)(id, SEL) = (void *)imp;
    func(self, selector);
}


#pragma mark - 点击cell时执行的方法
//"喜歡我們，評分鼓勵"
- (void)mLikeUs {
    // 跳转到AppStore评论界面
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kAppStoreCommentURL]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreCommentURL]];
    }
}


//分享給朋友
- (void)mShare {

    //添加统计
    NSString *googleString = [NSString stringWithFormat:@"uid=%@", USERID];
    NSDictionary *parameter = @{@"uid": USERID};
    [super mAddAnalyticsWithPageIndex:kShareAppPageIndex googleString:googleString parameter:parameter];
    
    UIImage *imageToShare = [UIImage imageNamed:kShareImageName];
    [BKTool mSystemShare:self urlToShare:kDownloadURL textToShare:kMyModule_ShareText imageToShare:imageToShare];
}


//關於 Edu Kingdom
- (void)mAboutEduKingdom {
    [EKWebViewController showWebViewWithTitle:@"關於EduKingdom" forURL:kAboutUsURL from:self];
}


//隱私條例
- (void)mPrivacy {
    [EKWebViewController showWebViewWithTitle:@"隱私條例" forURL:kUserPrivacyURL from:self];
}


@end
