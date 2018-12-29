//
//  BaseTableViewController.m
//  BKMobile
//
//  Created by ligb on 16/12/7.
//  Copyright © 2016年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "BaseTableViewController.h"
const NSInteger top = 64;
@interface BaseTableViewController ()



@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setStyle:(BTableStyle)style{
    _style = style;
    [self tableView];
}


- (void)addTabViewTopLineView{
    UIImageView *imageLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"def_iv_Lace"]];
    imageLine.backgroundColor = [UIColor EKColorBackground];
    [self.view addSubview:imageLine];
    
    
    [imageLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(top);
        make.height.mas_equalTo(10);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageLine);
        make.left.right.bottom.equalTo(self.view);
    }];
}


/**
 懒加载
 @return tableView
 */
- (UITableView *)tableView{
    if (!_tableView) {
        ///这里的table 不做自动尺寸适配，是因为考虑页面还有其他view，故做一个默认的frame
        switch (_style) {
            case BTableViewStylePlain:
                 _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
                break;
            default:
                 _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
                break;
        }
      
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor EKColorBackground];
//        _tableView.scrollsToTop = YES;
        [self.view addSubview:_tableView];

    }
    return _tableView;
}


/**
 懒加载
 @return mutableArray 数据源
 */
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}


- (void)addHeaderRefreshingBlock:(void (^)(void))block{
    if (_tableView) {
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            block();
        }];
    }
    [_tableView.mj_header beginRefreshing];
}


- (void)addFooterRefreshingBlock:(void (^)(void))block{
    if (_tableView) {
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
             block ();
        }];
        
        _tableView.mj_footer.hidden = YES;
    }
}


- (void)endRefresh{
    if (_tableView.mj_header.isRefreshing) {
        [_tableView.mj_header endRefreshing];
    }else if ([_tableView.mj_footer isRefreshing]){
        [_tableView.mj_footer endRefreshing];
    }
}


#pragma  UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
