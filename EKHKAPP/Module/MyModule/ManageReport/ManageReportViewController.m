//
//  ManageReportViewController.m
//  BKMobile
//
//  Created by bowen on 15/12/16.
//  Copyright © 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "ManageReportViewController.h"
#import "BSubTableView.h"
#import "ManageReportTableViewCell.h"
#import "EKThemeDetailViewController.h"
#import "UIButton+EXCell.h"
#import "ReportModel.h"
#import "EKCornerSelectMenuView.h"

@interface ManageReportViewController () <UITableViewDataSource,
                                          UITableViewDelegate,
                                          UIAlertViewDelegate,
                                          EKCornerSelectMenuViewDelegate>
{
    __weak IBOutlet UIScrollView *_scrollViewBg;
    
    NSMutableArray      *_tableArray;
    NSMutableArray      *_dataSource;
    
    UIButton_EXCell     *_tempButton;       //临时button
    
    NSInteger           _selectType;//標題類型區分
    NSInteger           _page;  //選擇頁數
    NSInteger           _reportids; //舉報id
}
//顶部的选择视图
@property (strong, nonatomic) EKCornerSelectMenuView *vSelectMenuView;
@property (nonatomic , copy)   NSString      *listtype;/* 列表数据类型*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vScrollViewTopConstraint;
@end

@implementation ManageReportViewController

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor EKColorTableBackgroundGray];
    _vSelectMenuView = [[EKCornerSelectMenuView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 280) / 2, 30 + NAV_BAR_HEIGHT, 280, 30)
                                                          titleArray:@[@"最新", @"已處理"]
                                                            delegate:self
                                                                type:EKCornerSelectMenuViewTypeNormal
                                                       selectedIndex:0];
    [self.view addSubview:_vSelectMenuView];
    _scrollViewBg.contentSize = CGSizeMake(SCREEN_WIDTH * 2, _scrollViewBg.contentSize.height);
    //适配ipX
    _vScrollViewTopConstraint.constant = 91 + NAV_BAR_HEIGHT;
    
    for (int i=0; i<2; i++) {
        /**
         *  页面tableView
         */
        BSubTableView *bsuTableView = [[BSubTableView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT- NAV_BAR_HEIGHT - 44)];
        bsuTableView.tableView.delegate = self;
        bsuTableView.tableView.dataSource = self;
        bsuTableView.tableView.rowHeight = UITableViewAutomaticDimension;
        bsuTableView.tableView.estimatedRowHeight = 163;
        bsuTableView.tableView.separatorInset = UIEdgeInsetsZero;
        bsuTableView.tableView.separatorColor = [UIColor EKColorSeperateWhite];
        //注册nibCell
        UINib *nibCell = [UINib nibWithNibName:@"ManageReportTableViewCell" bundle:nil];
        [bsuTableView.tableView registerNib:nibCell forCellReuseIdentifier:@"manageReportCell"];
        [_tableArray addObject:bsuTableView];
        [_scrollViewBg addSubview:bsuTableView];
        
        /**
         添加下拉刷新，上拉加载延展
         */
        //添加下拉刷新功能
        bsuTableView.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pulldownRefresh)];
        
        //添加上拉加载更多功能
        bsuTableView.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upLoadingRefresh)];
        
        bsuTableView.tableView.mj_footer.hidden = YES;
    }

    //开始下拉刷新
    [[self myTableView].mj_header beginRefreshing];

}

- (void)disposedData:(NSArray *)data
{
    if (_page == 1) {
        [_dataSource removeAllObjects];
    }
    
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ReportModel *model = obj;
        NSString *str = nil;
        if ([model.msglist isKindOfClass:[NSArray class]]) {
            str = [model.msglist componentsJoinedByString:@"\n"];
        }else if ([model.msglist isKindOfClass:[NSString class]])
        {
            str = model.msglist;
        }
        
        [_dataSource addObject:obj];
        
    }];
    
    [[self myTableView] reloadData];
    
}
- (void)initDatas
{
     _selectType = 0;
     _page = 1;
    _tableArray     = [[NSMutableArray alloc] initWithCapacity:0];
    _dataSource     = [[NSMutableArray alloc] initWithCapacity:0];
}
#pragma mark 获取当前用户密码
- (NSString *)loginPassword
{
    NSString *pawskey = [BKSaveData getString:kUserPasswordIndexKey];
    NSString *paws = [AESCrypt decrypt:pawskey password:kUserPasswordKey];
    return paws;
}
- (void)requestData
{
    NSString *paws = [self loginPassword];
    NSDictionary *dict = @{@"token":TOKEN,
                           @"admin_password":paws,
                           @"listtype":_listtype,
                           @"page":@(_page)};
    _vSelectMenuView.userInteractionEnabled = NO;
    [EKHttpUtil mHttpWithUrl:kReportAdminURL parameter:dict response:^(BKNetworkModel *model, NSString *netErr) {
        _vSelectMenuView.userInteractionEnabled = YES;
        if (netErr) {
            [self.view showHUDTitleView:netErr image:nil];
        }else{
            if (model.status == 1) {
                NSArray *array = model.data[@"list"];
                NSMutableArray *tempArray = [NSMutableArray array];
                for (NSDictionary *dic in array) {
                    ReportModel *model = [[ReportModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [tempArray addObject:model];
                }
                [self disposedData:tempArray];
                
                NSInteger max_page = [model.data[@"page"][@"max_page"] integerValue];
                if (_page >= max_page) {
                    [[self myTableView].mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                [self.view showHUDTitleView:model.message image:nil];
            }
            [[self myTableView] mEndRefresh];
        }
    }];
   
}


#pragma mark - EKCornerSelectMenuViewDelegate
- (void)mEKCornerSelectMenuView:(EKCornerSelectMenuView *)selectMenuView didClickWithIndex:(NSInteger)index {
    _selectType = index;
    [[self myTableView].mj_header beginRefreshing];
    [_scrollViewBg setContentOffset:CGPointMake(_selectType * _scrollViewBg.frame.size.width, 0) animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用戶舉報";
    [self initDatas];
    [self initView];
}
- (void)pulldownRefresh
{
    if (_selectType == 0) {
        _page = 1;
        
        self.listtype = @"newreport";
    }else{
        _page = 1;
        self.listtype = @"resolved";
    }
    [self requestData];
}
- (void)upLoadingRefresh
{
    if (_selectType == 0) {
        _page ++;
        self.listtype = @"newreport";
       
    }else{
        _page ++;
        self.listtype = @"resolved";
    }
     [self requestData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UITableView *)myTableView
{
    BSubTableView *subTabView = (BSubTableView *)_tableArray[_selectType];
    return subTabView.tableView;
}

#pragma mark TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self myTableView].mj_footer.hidden = _dataSource.count == 0;
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    ManageReportTableViewCell *cell = [[self myTableView] dequeueReusableCellWithIdentifier:@"manageReportCell"];
    [self cellForManageReportViewCell:cell indexPath:indexPath];
    
    return cell;

}
- (void)cellForManageReportViewCell:(ManageReportTableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    cell.btnDelete.row  = indexPath.row;
    cell.btnDispose.row = indexPath.row;
    
    if (_selectType == 0) {
        cell.labFruit.hidden = YES;
        cell.labFruitStatus.hidden = YES;
        cell.btnDelete.hidden = NO;
    }else{
        cell.labFruit.hidden = NO;
        cell.labFruitStatus.hidden = NO;
        cell.btnDelete.hidden = YES;
    }
    
    ReportModel *model = [_dataSource objectAtIndex:indexPath.row];
    [cell refreshView:model]; //赋值操作
   
    [cell.btnDelete addTarget:self action:@selector(selectDeleteItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDispose addTarget:self action:@selector(selectDisposeItemAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ReportModel *model = [_dataSource objectAtIndex:indexPath.row];
    //跳转到帖子详情界面
    NSDictionary *paramter = @{@"tid" : [NSNumber numberWithInteger:model.tid],
                               @"pid" : @(model.pid) };
    [super showNextViewControllerName:@"EKThemeDetailViewController" params:paramter isPush:YES];
}

#pragma mark 刪除舉報
- (void)selectDeleteItemAction:(UIButton_EXCell *)btn
{
    ReportModel *model = [_dataSource objectAtIndex:btn.row];
    _tempButton = btn;
    _reportids = model.mId;
    [[[UIAlertView alloc] initWithTitle:nil message:@"是否刪除本條舉報？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定", nil] show];
}

#pragma mark 處理舉報
- (void)selectDisposeItemAction:(UIButton_EXCell *)btn
{
    ReportModel *model = [_dataSource objectAtIndex:btn.row];
    if (_selectType == 0) {
        /*
         creditsvalues为处理该记录时对举报者的奖惩操作，0为忽略，+或-为对应的积分操作，同理，如果用于批量处理需要用逗号隔开，如+5,-2,0。
         */

        NSString *paws = [self loginPassword];
        NSInteger reportid = model.mId;
        NSInteger uid = model.uid;
        [EKHttpUtil mHttpWithUrl:kReportDealURL parameter:@{@"token":TOKEN,@"admin_password":paws,@"reportids":@(reportid),@"creditsvalues":@(0),@"reportuids":@(uid)} response:^(BKNetworkModel *model, NSString *netErr) {
            [self.view showHUDTitleView:model.message image:nil];
            if (netErr) {
                [self.view showHUDTitleView:netErr image:nil];
            }else{
                if (model.status == 1) {
                    //删除成功重新加载api 数据列表
                    [_dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (btn.row == idx) {
                            *stop = true;
                            if (*stop == true) {
                                [_dataSource removeObjectAtIndex:idx];
                                [[self myTableView] reloadData];
                                 return ;
                            }
                        }
                    }];
                } else{
                    [self.view showHUDTitleView:model.message image:nil];
                }
            }
        }];
    }else{
        NSInteger reportid = model.mId;
        NSString *paws = [self loginPassword];
        [EKHttpUtil mHttpWithUrl:kReportDeleteURL parameter:@{@"token":TOKEN,@"admin_password":paws,@"reportids":@(reportid)} response:^(BKNetworkModel *model, NSString *netErr) {
            [self.view showHUDTitleView:model.message image:nil];
            if (netErr) {
                [self.view showHUDTitleView:netErr image:nil];
            }else{
                if (model.status == 1) {
                    _page = 1;
                    //删除成功重新加载api 数据列表
                    [_dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (btn.row == idx) {
                            *stop = true;
                            if (*stop == true) {
                                [_dataSource removeObjectAtIndex:idx];
                                [[self myTableView] reloadData];
                            }
                            return ;
                        }
                    }];
                }else{
                    [self.view showHUDTitleView:model.message image:nil];
                }
            }
        }];
    }
}

#pragma mark AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
         NSString *paws = [self loginPassword];
        [EKHttpUtil mHttpWithUrl:kReportDeleteURL parameter:@{@"token":TOKEN,@"admin_password":paws,@"reportids":@(_reportids)} response:^(BKNetworkModel *model, NSString *netErr) {
            [self.view showHUDTitleView:model.message image:nil];
            if (netErr) {
                [self.view showHUDTitleView:netErr image:nil];
            }else{
                if (model.status == 1) {
                    //删除成功重新加载api 数据列表
                    [_dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (_tempButton.row == idx) {
                             *stop = true;
                            if (*stop == true) {
                                [_dataSource removeObjectAtIndex:idx];
                                [[self myTableView] reloadData];
                            }
                            return ;
                        }
                    }];
                }else{
                    [self.view showHUDTitleView:model.message image:nil];
                }
            }
        }];
    
    }
}


@end
