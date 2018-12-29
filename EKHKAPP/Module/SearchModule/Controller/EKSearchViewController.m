/**
 -  EKSearchViewController.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/21.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:从首页右上角进入的"搜索"界面
 */

#import "EKSearchViewController.h"
#import "EKCornerSelectMenuView.h"
#import "EKSearchCellModel.h"
#import "EKSearchBaseCell.h"
#import "EKSearchUserCell.h"
#import "EKSearchUserModel.h"
#import "EKSearchUserAlertController.h"
#import "EKSearchAddFriendViewController.h"
#import "EKLoginViewController.h"
#import "EKUserInformationViewController.h"
#import "EKSearchForumModel.h"

@interface EKSearchViewController () <UITableViewDataSource,
                                      UITableViewDelegate,
                                      EKSearchUserCellDelegate,
                                      EKSearchUserAlertControllerDelegate,
                                      UITextFieldDelegate>
#pragma mark - 属性 - UI
@property (strong, nonatomic) EKCornerSelectMenuView *vSelectMenuView;
//"輸入關鍵字"label
@property (weak, nonatomic) IBOutlet UILabel *vEnterKeyWordLabel;
//搜索框
@property (weak, nonatomic) IBOutlet UITextField *vSearchTextField;
//主体的tableView
@property (weak, nonatomic) IBOutlet UITableView *vTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vEnterKeyWordLabelTopConstraint;
#pragma mark - 属性 - 数据源
//cell对应的model数据源数组
@property (strong, nonatomic) NSMutableArray <EKSearchCellModel *> *vSearchCellModelDataSource;
#pragma mark - 属性 - 记录属性
//用来记录用户点击"搜索"按钮的时候,选中的要搜索的数据类型(论坛或用户)
@property (assign, nonatomic) EKSearchType vCurrentType;
//记录下来用户点击"搜寻"按钮的时候,文本框的文字内容.
@property (copy, nonatomic) NSString *vCuttentSearchText;
//记录下来当前搜索到的页码
@property (assign, nonatomic) NSInteger vCurrentPage;
@end

@implementation EKSearchViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dealloc{
    DLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加广告
    [self mRequestInterstitialView];
    [self mRequestPopupView:0];
}

#pragma mark - 初始化UI
- (void)mInitUI {
    self.title = @"搜尋論壇";
    //适配ipX
    _vEnterKeyWordLabelTopConstraint.constant = 70 + NAV_BAR_HEIGHT;
    [self mInitSelectMenuView];
    [self mInitEnterKeyWordLabel];
    [self mInitTableView];
}


//设置菜单选择视图
- (void)mInitSelectMenuView {
    CGFloat selectMenuViewLeft = 48;
    CGFloat selectMenuViewTop = 20 + NAV_BAR_HEIGHT;
    CGFloat selectMenuViewHeight = 31;
    _vSelectMenuView = [[EKCornerSelectMenuView alloc] initWithFrame:CGRectMake(selectMenuViewLeft, selectMenuViewTop, SCREEN_WIDTH - 2 * selectMenuViewLeft, selectMenuViewHeight)
                                                          titleArray:@[@"論 壇", @"用 戶"]
                                                            delegate:nil
                                                                type:EKCornerSelectMenuViewTypeNormal
                                                       selectedIndex:0];
    [self.view addSubview:_vSelectMenuView];
}


//设置"输入关键字"label
- (void)mInitEnterKeyWordLabel {
    //设置字间距
    NSDictionary *attributes = @{NSKernAttributeName : @(3),
                                 NSFontAttributeName : [UIFont systemFontOfSize:16]};
    _vEnterKeyWordLabel.attributedText = [[NSAttributedString alloc] initWithString:@"輸入關鍵字"
                                                                         attributes:attributes];
}


//设置tableView
- (void)mInitTableView {
    [_vTableView registerNib:[UINib nibWithNibName:@"EKSearchForumCell" bundle:nil]
      forCellReuseIdentifier:searchForumCellID];
    [_vTableView registerNib:[UINib nibWithNibName:@"EKSearchUserCell" bundle:nil]
      forCellReuseIdentifier:searchUserCellID];
    _vTableView.tableFooterView = [[UIView alloc] init];
    //添加上拉刷新控件
    _vTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(mPullUpRefresh)];
    //默认隐藏.有数据时候再显示
    _vTableView.hidden = YES;
}


//触摸空白处,收回键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - 上拉刷新
- (void)mPullUpRefresh {
    //page参数+1
    _vCurrentPage ++;
    [self mRequestSearchCellModelData];
}


#pragma mark - 按钮监听事件
- (IBAction)mClickSearchButton:(id)sender {
    [self.view endEditing:YES];
    //未登录时点击"搜索"按钮,需要跳转到"登录"界面
    if ([EKLoginViewController showLoginVC:self from:@"inPage"]) {
        return;
    }
    _vCuttentSearchText = _vSearchTextField.text;
    _vCurrentType = _vSelectMenuView.vSelectedIndex;
    if ([BKTool isStringBlank:_vSearchTextField.text]) {
        [self.view showError:@"請輸入關鍵字"];
        return;
    }
    [self.view showHUDActivityView:@"正在加載..." shade:NO];
    [_vTableView.mj_footer resetNoMoreData];
    //将当前的page参数置为1
    _vCurrentPage = 1;
    [self mRequestSearchCellModelData];
}


#pragma mark - 私有方法 - 加载网络数据
- (void)mRequestSearchCellModelData {
    DLog(@"论坛或用户:%zd   文本框内容:%@   page:%zd",_vCurrentType,_vCuttentSearchText,_vCurrentPage);
    //添加统计
    NSString *googleString = [NSString stringWithFormat:@"keyword=%@", _vCuttentSearchText];
    NSDictionary *parameter = @{@"keyword" : _vCuttentSearchText};
    [super mAddAnalyticsWithPageIndex:kSearchPageIndex googleString:googleString parameter:parameter];
   
    [EKSearchCellModel mRequestSearchCellModelArrayWithType:_vCurrentType withSearchText:_vCuttentSearchText withPage:_vCurrentPage withCallBack:^(NSString *netErr, NSArray<EKSearchCellModel *> *searchCellModelArray, NSString *message) {
        
       [self.view removeHUDActivity];
       if (netErr) {
           [self.view showError:netErr];
       } else {
           _vTableView.hidden = NO;
           if (searchCellModelArray.count) {
               if (_vTableView.mj_footer.isRefreshing) {
                   [_vSearchCellModelDataSource addObjectsFromArray:searchCellModelArray];
               } else {
                   _vSearchCellModelDataSource = [NSMutableArray arrayWithArray:searchCellModelArray];
               }
           } else {
               //如果没有数据返回,则后台肯定会返回message
               //根据当前page是否为1,来推断当前是显示没有更多数据的信息到黑框上,还是在底部控件显示
               if (1 == _vCurrentPage) {
                   [self.view showError:message];
                   [_vSearchCellModelDataSource removeAllObjects];
               } else {
                   [_vTableView.mj_footer endRefreshingWithNoMoreData];
                   return ;
               }
           }
           [_vTableView reloadData];
           //如果用户切换了搜索的类型,得让tableView滚回到顶部
           if (searchCellModelArray.count && !_vTableView.mj_footer.isRefreshing) {
               [_vTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
           }
       }
       [_vTableView.mj_footer endRefreshing];
   }];
}


#pragma mark - UITableViewDataSource
//返回组数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _vSearchCellModelDataSource.count;
}


//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EKSearchBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:_vSearchCellModelDataSource[indexPath.row].vReuseIdentifier];
    id vModel = _vSearchCellModelDataSource[indexPath.row].vModel;
    cell.vModel = vModel;
    //设置"搜索用户"cell的代理对象
    if ([vModel isKindOfClass:[EKSearchUserModel class]]) {
        EKSearchUserCell *userCell = (EKSearchUserCell *)cell;
        if ([userCell isKindOfClass:[EKSearchUserCell class]]) {
            userCell.delegate = self;
        }
    }
    return cell;
}


#pragma mark - UITableViewDelegate
//返回行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _vSearchCellModelDataSource[indexPath.row].vRowHeight;
}


//点击cell时候调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id vModel = _vSearchCellModelDataSource[indexPath.row].vModel;
    if ([vModel isKindOfClass:[EKSearchForumModel class]]) {
        //如果点击的是"搜索论坛"的cell,则跳转到对应的"帖子详情"界面
        EKSearchForumModel *forumModel = vModel;
        NSDictionary *paramter = @{@"tid":[NSNumber numberWithInteger:forumModel.tid.integerValue],
                                   @"pid":@(0)};
        [super showNextViewControllerName:@"EKThemeDetailViewController" params:paramter isPush:YES];
    } else {
        //如果点击的是"搜索用户"的cell,则跳转到对应的"用户基本资料"界面
        EKSearchUserModel *userModel = vModel;
        EKUserInformationViewController *userInformationViewController = [[EKUserInformationViewController alloc] init];
        userInformationViewController.userImageURLString = userModel.avatar;
        userInformationViewController.uid = userModel.uid;
        userInformationViewController.name = userModel.username;
        [self.navigationController pushViewController:userInformationViewController animated:YES];
    }
}


#pragma mark - EKSearchUserCellDelegate - 搜索用户时候显示的cell的代理方法
//当"搜索用户"cell的 "加为好友"/"解除好友" 按钮被点击的时候调用
- (void)mSearchUserCellAddFriendButtonDidClickWithCell:(EKSearchUserCell *)cell {
    //根据索引,获取到model,进而获取到好友关系状态
    NSInteger row = [_vTableView indexPathForCell:cell].row;
    EKSearchUserModel *userModel = (EKSearchUserModel *)_vSearchCellModelDataSource[row].vModel;
    if (![userModel isKindOfClass:[EKSearchUserModel class]]) {
        return;
    }
    BOOL isFriend = userModel.isfriend.boolValue;
    //如果是朋友关系的话,则弹出解除好友的弹窗,否则push到申请好友的界面
    if (isFriend) {
        EKSearchUserAlertController *alertController = [[EKSearchUserAlertController alloc] initWithDelegate:self withRow:row];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        EKSearchAddFriendViewController *addFriendViewController = [[EKSearchAddFriendViewController alloc] init];
        addFriendViewController.vUserName = userModel.username;
        addFriendViewController.vUid = userModel.uid;
        [self.navigationController pushViewController:addFriendViewController animated:YES];
    }
}


#pragma mark - EKSearchUserAlertControllerDelegate - 解除好友的弹窗控制器的代理方法
//解除好友弹窗的"确定"按钮点击的时候调用
- (void)mSearchUserAlertControllerConfirmButtonDidClickWithRow:(NSInteger)row {
    EKSearchUserModel *searchUserModel = _vSearchCellModelDataSource[row].vModel;
    [self.view showHUDActivityView:@"正在加載..." shade:NO];
    [EKSearchUserModel mRequestDeleteFriendWithUid:searchUserModel.uid callBack:^(BOOL isSuccess, NSString *message) {
        [self.view removeHUDActivity];
        [self.view showSuccess:message];
        if (isSuccess) {
            //修改数据源model的isfriend字段为0,并更新tableView的UI
            EKSearchUserModel *searchUserModel = _vSearchCellModelDataSource[row].vModel;
            searchUserModel.isfriend = @(0).description;
            [_vTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]]
                                 withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}


#pragma mark - UITextFieldDelegate
//点击键盘回车时调用
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self mClickSearchButton:nil];
    return NO;
}


@end
