/**
 -  EKADViewController.m
 -  EKHKAPP
 -  Created by HY on 2018/1/17.
 -  Copyright © 2018年 BaByKingdom. All rights reserved.
 -  说明:统一处理广告的类，继承于base，如果使用广告，页面需要继承于该类
 */

#import "EKADViewController.h"
#import "BADRequest.h"
#import "EKWebViewController.h"
#import "ADIDModel.h"
#import "EKADPageIndex.h"
#import "BADWindow.h"

@interface EKADViewController () <BADBannerViewDelegate, BADPopupViewDelegate, BADInterstitialDelegate>

//请求类
@property (nonatomic, strong) BADRequest *vRequest;
//标示一共有多少个banner
@property (nonatomic, assign) NSInteger vAdCount;
//标示banner逐个返回的index
@property (nonatomic, assign) NSInteger vAdIndex;
//全屏广告
@property (nonatomic, strong) BADInterstitial *vADInterstitial;
//弹窗广告
@property (nonatomic, strong) BADPopup    *vADPopup;
//例如：弹窗广告如果在一级界面，不能遮挡底部tabbar，需要传递距离底部高度
@property (nonatomic, readonly, assign) CGFloat vBottomHeight;

//存储请求回来的广告id，页面索引值
@property (nonatomic, strong) NSMutableArray <ADIDModel *> *vADIDArray;

//广告id模型类
@property (nonatomic, strong) ADIDModel *vAdIdModel;

@end

@implementation EKADViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNotificationRemoveADWindowActionKey
                                                  object:nil];
    NSLog(@"***********  dealloc = %s *********",__func__);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    _vRequest = nil;
//    _vADPopup = nil;
//    _vADInterstitial = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    _vAdIndex = 0;
//    _vBannerArray = [[NSMutableArray alloc] init];
//    _vADIDArray = [[NSMutableArray alloc] init];
//    _vAdIdModel = [[ADIDModel alloc] init];
    
//    //增加一个控制全屏和pop 广告隐藏通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(didRemoveWindowViewAction:)
//                                                 name:kNotificationRemoveADWindowActionKey
//                                               object:nil];
}

- (void)didRemoveWindowViewAction:(NSNotification *)object {
    BADWindow *windowValue = (BADWindow *)[object object];
  
    if (windowValue.vFullView && _vADInterstitial) {
        [windowValue.vFullView removeFromSuperview];
        windowValue.vFullView = nil;
        _vADInterstitial = nil;
    }
    
    if (windowValue.vBigPopView && _vADPopup) {
        _vADPopup.delegate = nil;
        _vADPopup = nil;
    }
}

#pragma mark - 请求广告id数据
- (void)mRequestAdID:(void(^) (void) )block  {
    
//    [_vAdIdModel mRequestAdID:^(NSArray<ADIDModel *> *adArray) {
//        if (adArray.count > 0) {
//            [self.vADIDArray setArray:adArray];
//            block();
//        }
//    }];
}

#pragma mark - 配置广告数据
- (BADRequest *)vRequest {
//    if (!_vRequest) {
//        _vRequest = [BADRequest request];
//    }
//    _vRequest.vUserid = USERID;
//    _vRequest.vUsername = [BKSaveUser mGetUser].username;
//
//    ADIDModel *adIDModel = [self mReturnADIDModel];
//    _vRequest.vPageId = adIDModel.pageID;
//
//    //    _vRequest.vBannerSize = @"";
//    //    _vRequest.vAdWidth = @"320";
//    //    _vRequest.vAdHeight = @"50";
//
//    return _vRequest;
    return nil;
}

#pragma mark --------- Interstitial广告 ---------

- (void)mRequestInterstitialView {
    [self mRequestAdID:^{
        //这里根据页面，去匹配后台数据，获得广告id值
//        ADIDModel *adIDModel = [self mReturnADIDModel];
//        _vADInterstitial = [BADInterstitial sharedInstance];
//        _vADInterstitial.adUnitID = adIDModel.fullscreen;
//        _vADInterstitial.delegate = self;
//        [_vADInterstitial loadRequest:self.vRequest];
    }];
}

- (void)adView:(BADInterstitial *)interstitialView didTouchInterstitialViewWithUrl:(NSString *)url {
//    [EKWebViewController showWebViewWithTitle:@"" forURL:url from:self];
}


#pragma mark --------- popup广告 ---------

- (BADPopup *)vADPopup {

     if (!_vADPopup) {
        //这里根据页面，去匹配后台数据，获得广告id值
//        ADIDModel *adIDModel = [self mReturnADIDModel];
//        _vADPopup = [[BADPopup alloc] initWithAdUnitID:adIDModel.popup];
//        _vADPopup.vBottomHeight = _vBottomHeight;
//        _vADPopup.delegate = self;
    }
    return _vADPopup;
}

- (void)mRequestPopupView:(CGFloat)vBottomSpace {
//    _vBottomHeight = vBottomSpace;
//    [self mRequestAdID:^{
//        [self.vADPopup loadRequest:self.vRequest];
//    }];
}

- (void)adView:(BADPopup *)popupView didTouchPopupViewWithUrl:(NSString *)url {
//    [EKWebViewController showWebViewWithTitle:@"" forURL:url from:self];
}


#pragma mark --------- banenr广告 ---------
- (void)mRequestBannerView {
//    [self mRequestAdID:^{
//        [self mLoadBannerAd];
//    }];
}

- (void)mLoadBannerAd {
//    ADIDModel *adIDModel = [self mReturnADIDModel];
//    NSArray *array = adIDModel.banner;
//    _vAdCount = array.count;
//    for (int i = 0; i < array.count; i++) {
//        NSString *bannerId = [NSString stringWithFormat:@"%@",[array objectAtIndex:i]];
//        //TODO: 这里bannersize赋值
//        BADBannerView *banner = [[BADBannerView alloc] initWithAdSize:BADADSIZE_LARGE];
//        banner.adUnitID = bannerId;
//        banner.delegate = self;
//        [banner loadRequest:self.vRequest];
//    }
}

#pragma mark - 代理，广告请求失败的回调
- (void)adView:(BADBannerView *)bannerView didFailToReceiveAdWithError:(NSString *)error {
//    [self mBannerAdCalculate];
}

#pragma mark - 代理，广告请求成功的回调
- (void)adViewDidReceiveAd:(BADBannerView *)bannerView {
//    [_vBannerArray addObject:bannerView];
//    [self mBannerAdCalculate];
}

#pragma mark - 代理，广告被点击的回调
- (void)adView:(BADBannerView *)bannerView didTouchBannerViewWithUrl:(NSString *)url {
//    [EKWebViewController showWebViewWithTitle:@"" forURL:url from:self];
}


#pragma mark - 其他业务逻辑处理

//banner广告计算
- (void)mBannerAdCalculate {
//    _vAdIndex = _vAdIndex + 1;
//
//    //如果请求的广告个数全部返回了，把数据给到外部，合并后显示banner
//    if (_vAdIndex == _vAdCount && _vBannerArray.count > 0) {
//        //处理banner返回个数小于三条的情况
//        [self mUnitBannerData];
//        //让子类使用处理好的banner数据
//        [self mMergeBannerAdData];
//    }
}

//请求到的banner数据已经全部返回，子类需要重写该方法,直接使用_vBannerArray
- (void)mMergeBannerAdData {
    NSLog(@"%s",__func__);
}

//处理banner返回少于三条的情况
- (NSMutableArray *)mUnitBannerData {
    //由于广告每隔四条显示一个，一个屏幕最多可能显示两条，所以单元格重用至少要三条广告
    //如果banner广告条数少于3，则需要生成内存地址不同的三条广告，防止滑动无重用view时候，出现空白cell
//    NSInteger bannerNum = 3; //banner不能少于的临界值
//    NSInteger count = 2; //需要遍历次数
//    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:0];
//    if (_vBannerArray.count > 0 && _vBannerArray.count < bannerNum ) {
//        for (int i = 0; i < count; i++) {
//            BADBannerView *bannerTemp;
//            if (_vBannerArray.count == 1) {
//                bannerTemp = [_vBannerArray objectAtIndex:0];
//            } else {
//                bannerTemp = [_vBannerArray objectAtIndex:i];
//            }
//
//            BADBannerView *banner = [[BADBannerView alloc] initWithAdSize:BADADSIZE_LARGE];
//            banner.adUnitID = bannerTemp.adUnitID;
//            banner.vBannerHeight = bannerTemp.vBannerHeight;
//            banner.delegate = self;
//            [banner loadRequest:self.vRequest];
//
//            [temp addObject:banner];
//        }
//        //注：这里是在原有广告条数上，add进去重新生成的实例view条数。
//        //如果一条广告，会遍历生成两个新的，共三条数据。
//        //如果两条广告，会重新复制这两条，共四条数据。
//        [_vBannerArray addObjectsFromArray:temp];
//    }
//
//    return _vBannerArray;
//}
//
//#pragma mark - 根据页面返回相对应的model值，用于取出广告id，请求广告
//- (ADIDModel *)mReturnADIDModel {
//    NSString *className = NSStringFromClass([self class]);
//    NSString *mPageIndex = [self vControllerNameDictionary][className];
//    if ([mPageIndex isEqualToString:kADThemeListPageIndex]) {
//        mPageIndex = [NSString stringWithFormat:@"%@_%@",mPageIndex,self.vAdFid];
//    } else if ([mPageIndex isEqualToString:kADThemeDetailPageIndex]) {
//        mPageIndex = [NSString stringWithFormat:@"%@_%@",mPageIndex,self.vAdFid];
//    }
//
//    //匹配到id后，返回该model
//    ADIDModel *saveMode;
//
//    //1:能匹配到后台返回的页面
//    for (ADIDModel *model in  self.vADIDArray) {
//        if ([model.page_id isEqualToString:mPageIndex]) {
//            model.pageID = mPageIndex;
//            saveMode = model;
//            break;
//        }
//    }
//
//    if (saveMode == nil && [mPageIndex rangeOfString:kADThemeListPageIndex].location != NSNotFound) {
//
//        //2:主题列表
//        for (ADIDModel *model in  self.vADIDArray) {
//            if ([model.page_id isEqualToString:kADThemeListPageIndex]) {
//                model.pageID = kADThemeListPageIndex;
//                saveMode = model;
//            }
//        }
//
//    } else if (saveMode == nil && [mPageIndex rangeOfString:kADThemeDetailPageIndex].location !=NSNotFound) {
//
//        //2:主题详情
//        for (ADIDModel *model in  self.vADIDArray) {
//            if ([model.page_id isEqualToString:kADThemeDetailPageIndex]) {
//                model.pageID = kADThemeDetailPageIndex;
//                saveMode = model;
//            }
//        }
//    }
//    return saveMode;
    return nil;
}



//以下页面可以在父类中，进行快捷的页面统计
- (NSDictionary *)vControllerNameDictionary {
    NSDictionary * vControllerNameDictionary =
    @{
      kADEKHomeViewController : kADHomePageIndex,//首页
      kADBKThemeListViewController : kADThemeListPageIndex,//主题列表
      kADEKThemeDetailViewController : kADThemeDetailPageIndex,//主题内容
      kADEKSearchViewController : kADSearchPageIndex,//搜索
      kADEKBKMilkViewController : kADBKMilkListPageIndex,//BKMilk文章列表
      kADEKSchoolAreaViewController : kADSchoolPageIndex,//学校
      kADCourseBaseViewController : kADCoursePageIndex,//课程
      kADBlogViewController : kADBlogPageIndex,//日志
      kADEKMyCenterViewController : kADMyCenterPageIndex,//个人中心
      kADEKLoginViewController : kADLoginPageIndex,//登录
      };
    return vControllerNameDictionary;
}


@end
