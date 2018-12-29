/**
 -  EKMilkMoreViewController.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/29.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是首页点击进入的"BKMilk更多"界面
 */

#import "EKMilkMoreViewController.h"
#import "EKMilkMoreListModel.h"
#import "EKMilkMoreCell.h"
#import "EKHomeWebViewController.h"

//cell缓存标识符
static NSString * milkMoreCellID = @"EKMilkMoreCellID";

//cell高度
static CGFloat kMilkCellHeight = 58;


@interface EKMilkMoreViewController () <UITableViewDelegate, UITableViewDataSource>
#pragma mark - 属性 - UI
//主体的tableView
@property (weak, nonatomic) IBOutlet UITableView *vTableView;
#pragma mark - 属性 - 数据源
//后台返回的数据源数组
@property (nonatomic, strong) NSMutableArray <EKMilkMoreListModel *> *vMilkMoreListDataSource;
@end

@implementation EKMilkMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self mRequestPopupView:0];
    [self mRequestInterstitialView];
    [self mRequestBannerView];
    
    //添加谷歌统计
    [EKGoogleStatistics mGoogleActionAnalytics:kBKMilkListPageIndex label:self.vTabid];
}

- (void)mMergeBannerAdData {
    NSLog(@"%@",self.vBannerArray);
    
    //合并广告数据和网络请求到的列表数据
    if (self.vBannerArray.count > 0 && _vMilkMoreListDataSource.count > 0) {
        //合并数据，刷新表
        [self mMergingBKMilkDataSource];
    }
}

#pragma mark - 初始化UI
- (void)mInitUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    //注册cell
    UINib *cellNib = [UINib nibWithNibName:@"EKMilkMoreCell" bundle:nil];
    [_vTableView registerNib:cellNib forCellReuseIdentifier:milkMoreCellID];
    _vTableView.tableFooterView = [[UIView alloc] init];
    _vTableView.rowHeight = 56;
}


#pragma mark - 初始化数据
- (void)mInitData {
    _vMilkMoreListDataSource = [NSMutableArray array];
    [self.view showHUDActivityView:@"正在加載..." shade:NO];
    [EKMilkMoreListModel mRequestMilkMoreListDataWithTabid:_vTabid page:1 callBack:^(NSString *netErr, NSArray<EKMilkMoreListModel *> *data) {
        [self.view removeHUDActivity];
        if (netErr) {
            [self.view showError:netErr];
        } else {
            
            _vMilkMoreListDataSource = [NSMutableArray arrayWithArray:data];
            //合并广告数据和网络请求到的列表数据
            if (self.vBannerArray.count > 0 && _vMilkMoreListDataSource.count > 0) {
                [self mMergingBKMilkDataSource];
            } else {
                [_vTableView reloadData];
            }
        }
    }];
}


#pragma mark - 合并列表和banner广告数据
- (void)mMergingBKMilkDataSource {
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
    __block int i = 0;
    [_vMilkMoreListDataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //判断在适当的位置插入数据
        if (idx >0 && idx % kADSpace == 0 ) {
            if (self.vBannerArray.count > i ) {
                EKMilkMoreListModel *model = [[EKMilkMoreListModel alloc] init];
                model.type = kAD;
                model.data = self.vBannerArray[i];
                [tempArray addObject:model];
                i++;
            }
        }
        EKMilkMoreListModel *model = (EKMilkMoreListModel *)obj;
        model.type = kNormal;
        [tempArray addObject:model];
        if (i == self.vBannerArray.count) i = 0;
    }];
    
    //重新赋值，合并过的数据源
    [_vMilkMoreListDataSource setArray:tempArray];
    
    //刷新表
    [self.vTableView reloadData];
    
}


#pragma mark - UITableViewDataSource
//返回行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _vMilkMoreListDataSource.count;
}


//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //列表会穿插banner广告cell
    EKMilkMoreListModel *listModel = [_vMilkMoreListDataSource objectAtIndex:indexPath.row];
    
    if ([listModel.type isEqualToString:kAD]) {

        static NSString * const definCell = @"adCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:definCell];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:definCell];
        }
        BADBannerView *bannerView = (BADBannerView *)[cell.contentView viewWithTag:199];
        if (bannerView != nil) {
            [bannerView removeFromSuperview];
        }
        //添加banner广告view
        bannerView  = (BADBannerView *)listModel.data;
        bannerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, bannerView.vBannerHeight);
        [bannerView setTag:199];
        [cell.contentView addSubview:bannerView];
        return cell;
        
    } else {
        EKMilkMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:milkMoreCellID forIndexPath:indexPath];
        cell.vMilkMoreListModel = _vMilkMoreListDataSource[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    EKMilkMoreListModel *listModel = [_vMilkMoreListDataSource objectAtIndex:indexPath.row];
    
    if ([listModel.type isEqualToString:kAD]) {
        BADBannerView  *bannerView = listModel.data;
        return bannerView.vBannerHeight;
    } else {
        return kMilkCellHeight;
    }
}


#pragma mark - UITableViewDelegate
//点击cell的时候调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //跳转到详情页
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EKMilkMoreListModel *milkMoreListModel = _vMilkMoreListDataSource[indexPath.row];
    [EKHomeWebViewController showHomeWebViewControllerWithTitle:milkMoreListModel.title
                                                      URLString:milkMoreListModel.url
                                             fromViewController:self
                                                       pageType:WebPageTypeNormal];
    
    //添加谷歌统计
    NSString *str = [NSString stringWithFormat:@"url=%@",milkMoreListModel.url];
    [EKGoogleStatistics mGoogleActionAnalytics:kBKMilkContentPageIndex label:str];
}

@end
