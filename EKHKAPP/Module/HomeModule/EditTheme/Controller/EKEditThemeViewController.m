//
//  EKEditThemeViewController.m
//  EKHKAPP
//
//  Created by ligb on 2017/9/21.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import "EKEditThemeViewController.h"
#import "CustomScrollerHeadView.h"
#import "EKEditThemeModel.h"
#import "EKEditThemeTableViewCell.h"
#import "EKColumnView.h"
#import "BKThemeListViewController.h"

NSString *const themeCell = @"themeCell";
const float HEAD_HEIGHT = 44.f;

@interface EKEditThemeViewController ()<UITableViewDelegate, UITableViewDataSource, EKEditThemeTableViewCellDelegate, CustomScrollerHeadViewDelegate>
@property (strong, nonatomic) CustomScrollerHeadView *vHeadView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vTableViewTopConstraint;

@property (nonatomic, strong) NSMutableArray <EKEditThemeModel *> *dataSource;
@property (nonatomic, assign) NSInteger indexSection;

@end

@implementation EKEditThemeViewController

- (void)dealloc {
    NSLog(@"dealloc = %s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"版塊添加";
    [self vBackBarButton];
}


- (void)mInitUI {
    [self.tableView registerNib:[UINib nibWithNibName:@"EKEditThemeTableViewCell" bundle:nil] forCellReuseIdentifier:themeCell];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.vHeadView.delegate = self;
    //适配ipX
    _vTableViewTopConstraint.constant = iOS11 ? (NAV_BAR_HEIGHT + HEAD_HEIGHT) : HEAD_HEIGHT;
    
}

- (void)showTitleItemView {
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:self.dataSource.count];
    [self.dataSource enumerateObjectsUsingBlock:^(EKEditThemeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titles addObject:obj.name];
    }];
    
    
    [self.vHeadView setItemTitles:titles selectedBgColor:nil normalTextColor:[UIColor darkGrayColor] selectedTextColor:[UIColor EKColorYellow] bottomLineColor:nil];
    
    [self.tableView reloadData];
}

- (void)mInitData {
    _indexSection = 0;
    [self.view showHUDActivityView:@"正在加載..." shade:NO];
    [EKEditThemeModel mLoadThemeList:^(NSArray<EKEditThemeModel *> *data, NSString *netErr) {
        [self.view removeHUDActivity];
        [self.dataSource setArray:data];
        
        [self showTitleItemView];
    }];
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count ? self.dataSource[_indexSection].forumscount : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EKEditThemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:themeCell forIndexPath:indexPath];
    cell.delegate = self;
    [cell showItemModel:self.dataSource[_indexSection].subforums[indexPath.row] indexPath:indexPath];
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //跳转到主题列表
    EKEditThemeModel *editThemeModel = self.dataSource[_indexSection];
    EKThemeSubforumsModel *subForumModel = editThemeModel.subforums[indexPath.row];
    BKThemeListViewController *themeListViewController = [[BKThemeListViewController alloc] init];
    themeListViewController.vFid = @(subForumModel.fid).description;
    [self.navigationController pushViewController:themeListViewController animated:YES];
}


#pragma mark - EKEditThemeTableViewCellDelegate
- (void)didSelectedItemCell:(EKEditThemeTableViewCell *)cell {
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    EKThemeSubforumsModel *model = self.dataSource[_indexSection].subforums[path.row];
    
    if (LOGINSTATUS) {
        [self.view showHUDActivityView:@"正在加載..." shade:NO];
        [EKEditThemeModel collectItemModel:model updata:^{
            [self.view removeHUDActivity];
            [self.tableView reloadData];
            //同步更新侧滑数据
            [EKColumnView mReloadData];
        }];
    } else {//没用登陆情况
        [EKEditThemeModel cacheCollectItemModel:model themeModel:self.dataSource[_indexSection]];
        [self.tableView reloadData];
        //同步更新侧滑数据
        [EKColumnView mReloadData];
    }
   
}


#pragma mark - EKEditThemeTableViewCellDelegate
- (void)didSelectedItemActionView:(CustomScrollerHeadView *)iView itemButton:(UIButton *)btn {
    _indexSection = btn.tag;
    [self.tableView reloadData];
}

- (NSMutableArray <EKEditThemeModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (CustomScrollerHeadView *)vHeadView {
    if (!_vHeadView) {
        _vHeadView = [[CustomScrollerHeadView alloc] init];
        _vHeadView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        [self.view addSubview:_vHeadView];
        [_vHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(@(NAV_BAR_HEIGHT));
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(@(HEAD_HEIGHT));
        }];
    }
    return _vHeadView;
}

- (void)mTouchBackBarButton {
    [EKColumnView animateColumnViewAction:NO];
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
