/**
 -  EKSchoolAreaViewController.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/8.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是标签栏的第1个控制器--"学校"
 */

#import "EKSchoolAreaViewController.h"
#import "EKSchoolSelectMenuView.h"
#import "EKSchoolBigAreaModel.h"
#import "EKSchoolAreaCollectionHeaderView.h"
#import "EKSchoolAreaCell.h"
#import "EKSchoolListViewController.h"

//cell的缓存标识符
static NSString *schoolAreaCellID = @"EKSchoolAreaCellID";
//collectionView组头视图缓存标识符
static NSString *schoolAreaCollectionHeaderViewID = @"EKSchoolAreaCollectionHeaderViewID";

@interface EKSchoolAreaViewController () <EKSchoolSelectMenuViewDelegate,
                                          UICollectionViewDelegate,
                                          UICollectionViewDataSource,
                                          EKSchoolAreaCollectionHeaderViewDelegate,
                                          UITextFieldDelegate>
//搜索框
@property (weak, nonatomic) IBOutlet UITextField *vSearchTextField;
//搜索按钮
@property (weak, nonatomic) IBOutlet UIButton *vSearchButton;
@property (weak, nonatomic) IBOutlet EKSchoolSelectMenuView *vSchoolSelectMenuView;
@property (weak, nonatomic) IBOutlet UICollectionView *vCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vSearchTextFieldTopConstraint;
//后台返回的数据源数组
@property (strong, nonatomic) NSArray <EKSchoolBigAreaModel *> *vSchoolAreaModelDataSource;
//用来记录当前选择的学校类型的按钮下标
@property (assign, nonatomic) NSInteger vSelectedSchoolTypeIndex;
//存储了三种学校类型的字符串的数组,用来给跳转到的"学校列表"界面设置title
@property (strong, nonatomic) NSArray <NSString *> *vSchoolTypeStringArray;
@end

@implementation EKSchoolAreaViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //添加广告
    [self mRequestInterstitialView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 初始化UI
- (void)mInitUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    _vSchoolSelectMenuView.delegate = self;
    _vSearchButton.enabled = NO;
    //适配ipX
    _vSearchTextFieldTopConstraint.constant = NAV_BAR_HEIGHT + 16;
    //设置collectionView
    [self mInitCollectionView];
}


//设置collectionView
- (void)mInitCollectionView {
    //注册cell
    UINib *cellNib = [UINib nibWithNibName:@"EKSchoolAreaCell" bundle:nil];
    [_vCollectionView registerNib:cellNib forCellWithReuseIdentifier:schoolAreaCellID];
    //注册组头视图
    UINib *headerViewNib = [UINib nibWithNibName:@"EKSchoolAreaCollectionHeaderView" bundle:nil];
    [_vCollectionView registerNib:headerViewNib
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:schoolAreaCollectionHeaderViewID];
}


//触摸空白处,隐藏键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - 初始化数据
- (void)mInitData {
    [self.view showHUDActivityView:@"正在加載..." shade:NO];
    [EKSchoolBigAreaModel mRequestSchoolAreaDataWithCallBack:^(NSArray<EKSchoolBigAreaModel *> *data, NSString *netErr) {
        [self.view removeHUDActivity];
        if (netErr) {
            [self.view showError:netErr];
        } else {
            _vSchoolAreaModelDataSource = data;
            [_vCollectionView reloadData];
        }
    }];
}


#pragma mark - UITextFieldDelegate
//点击键盘回车的时候调用
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (![BKTool isStringBlank:textField.text]) {
        //输入框有文字时才可进行搜索
        [self mClickSearchButton:nil];
        return NO;
    }
    return YES;
}


#pragma mark - 搜索框textField监听事件
//文字发生变化时调用
- (IBAction)mSearchTextFieldWordChange:(UITextField *)sender {
    //没有文字时,"搜索"按钮失效.反之相反
    _vSearchButton.enabled = ![BKTool isStringBlank:sender.text];
}


#pragma mark - "搜索"按钮监听事件
- (IBAction)mClickSearchButton:(id)sender {
    [self.view endEditing:YES];
    //跳转到"学校列表"界面
    EKSchoolListViewController *schoolListViewController = [[EKSchoolListViewController alloc] init];
    schoolListViewController.keyword = _vSearchTextField.text;
    schoolListViewController.title = @"搜索學校";
    [self.navigationController pushViewController:schoolListViewController animated:YES];
}


#pragma mark - EKSchoolSelectMenuViewDelegate
//"学校类型"按钮点击的时候调用
- (void)schoolTypeButtonDidClickWithIndex:(NSInteger)index {
    [self.view endEditing:YES];
    //记录当前选择的学校类型按钮下标
    _vSelectedSchoolTypeIndex = index;
}


#pragma mark - EKSchoolAreaCollectionHeaderViewDelegate
//组头视图被触摸的时候调用
- (void)mSchoolAreaCollectionHeaderViewDidTouch {
    [self.view endEditing:YES];
}


#pragma mark - UICollectionViewDataSource
//返回组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _vSchoolAreaModelDataSource.count;
}


//返回每组的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _vSchoolAreaModelDataSource[section].areas.count;
}


//返回cell
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EKSchoolAreaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:schoolAreaCellID forIndexPath:indexPath];
    cell.vSchoolSmallAreaModel = _vSchoolAreaModelDataSource[indexPath.section].areas[indexPath.row];
    return cell;
}


//返回组头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        EKSchoolAreaCollectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                      withReuseIdentifier:schoolAreaCollectionHeaderViewID
                                                                                             forIndexPath:indexPath];
        header.vSchoolBigAreaModel = _vSchoolAreaModelDataSource[indexPath.section];
        header.delegate = self;
        return header;
    }
    return nil;
}


#pragma mark - UICollectionViewDelegate
//点击cell时候调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    //跳转到"学校列表"界面
    //1.设置areaID
    EKSchoolSmallAreaModel *smallAreaModel = _vSchoolAreaModelDataSource[indexPath.section].areas[indexPath.row];
    NSArray *areaIDArray = @[smallAreaModel.kinder_id,
                             smallAreaModel.primary_id,
                             smallAreaModel.intl_id];
    NSString *areaID = areaIDArray[_vSelectedSchoolTypeIndex];
    
    //2.设置标题
    NSString *title = [NSString stringWithFormat:@"%@ - %@", self.vSchoolTypeStringArray[_vSelectedSchoolTypeIndex], smallAreaModel.name];
    
    //3.跳转
    EKSchoolListViewController *schoolListViewController = [[EKSchoolListViewController alloc] init];
    schoolListViewController.areaID = areaID;
    schoolListViewController.title = title;
    DLog(@"要跳转到的学校列表界面的ID为 : %@",areaID);
    [self.navigationController pushViewController:schoolListViewController animated:YES];
}


//collectionView开始滚动时调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


#pragma mark - 懒加载
- (NSArray<NSString *> *)vSchoolTypeStringArray {
    if (!_vSchoolTypeStringArray) {
        _vSchoolTypeStringArray = @[@"幼稚園", @"小學", @"國際學校"];
    }
    return _vSchoolTypeStringArray;
}

@end
