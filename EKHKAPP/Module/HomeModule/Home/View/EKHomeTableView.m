/**
 -  EKHomeTableView.m
 -  EKHKAPP
 -  Created by ligb on 2017/9/14.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "EKHomeTableView.h"
#import "EKHomePresenter.h"
#import "EKHomeActivityView.h"
#import "EKHomeFirstCell.h"
#import "EKHomeSecondCell.h"
#import "EKHomeThirdCell.h"
#import "EKHomeFourCell.h"
#import "EKHomeFifthlyCell.h"
#import "EKLoginViewController.h"
#import "EKThemeDetailViewController.h"
#import "BKThemeListViewController.h"
#import "EKHomeADView.h"
#import "EKHomeWebViewController.h"

//表高度，默认1，不显示
static CGFloat staticHeight = 1;

NSString *const firstCell = @"firstCell";
NSString *const secondCell = @"secondCell";
NSString *const thirdCell = @"thirdCell";
NSString *const fourCell = @"fourCell";
NSString *const fifthlyCell = @"fifthlyCell";

@interface EKHomeTableView () <UITableViewDelegate,
                               UITableViewDataSource,
                               BKLoopImageViewDelegate,
                               EKHomeVoteDelegate,
                               EKHomeFourCellDelegate,
                               EKHomeFifthlyCellDelegate>


@property (nonatomic, strong) EKHomeActivityView *vActivityView;
@property (nonatomic, strong) UIView *vHeader1SectionView;
@property (nonatomic, strong) UIView *vHeader3SectionView;
@property (nonatomic, strong) UIView *vFooter2SectionView;
@property (nonatomic, strong) UIView *vFooter3SectionView;
//管理置顶左侧上下广告的两个button的数组
@property (nonatomic, strong) NSArray <UIButton *> *vHomeTopDownAdvertiseButtonArray;
@property (nonatomic, strong) NSArray <EKHomeActivityEventModel *> *vActivityArray;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *voteIdArray;
@property (nonatomic, strong) EKHomePresenter *presenter;
@property (nonatomic, copy)   NSString *vSelectDate;
@property (nonatomic, assign) BOOL isExpand;
@end

@implementation EKHomeTableView

//选择投票
- (void)mVoteSelectIndex:(NSInteger)index isSelected:(BOOL)selected {
    
    if (!LOGINSTATUS) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(mUserNotLogigWithPush)]) {
            [self.delegate mUserNotLogigWithPush];
        }
        return;
    }
    if (!selected && self.voteIdArray.count >= self.vOteModel.maxchoices) {
        NSString *contMac = [NSString stringWithFormat:@"最多可以選擇%zd項",self.vOteModel.maxchoices];
        [self showHUDTitleView:contMac image:nil];
        return;
    } else {
        __block BOOL isValue = NO;
        [_voteIdArray enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (index == obj.integerValue) {
                isValue = YES;
            }
        }];
        
        if (isValue) {
            [self.voteIdArray removeObject:@(index)];
        } else {
            [self.voteIdArray addObject:@(index)];
        }
    }
    [_vTableView reloadData];
}

//确定投票action
- (void)mVoteAction{
    if (!LOGINSTATUS) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(mUserNotLogigWithPush)]) {
            [self.delegate mUserNotLogigWithPush];
        }
        return;
    }
    
    if (!self.voteIdArray.count) {
        [self showHUDTitleView:@"請選擇后再投票" image:nil];
        return;
    }
    NSString *pollanswers = [self.voteIdArray componentsJoinedByString:@","];
    [self showHUDActivityView:kStartLoadingText shade:NO];
    
    //添加统计
    NSString *tempStr = [NSString stringWithFormat:@"tid=%ld",(long)self.vOteModel.tid];
    [EKGoogleStatistics mGoogleActionAnalytics:kHomeVotePageIndex label:tempStr];
    
    [EKHomeVoteModel mBeginVoteActionTid:self.vOteModel.tid selectVote:pollanswers block:^(NSString *error,BOOL status) {
        if (status) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kHomeVoteRefreshNotification object:nil];
                [self showHUDActivityView:@"更新中..." shade:NO];
            });
        } else {
            [self showError:error];
        }
        [self removeHUDActivity];
    }];
}

- (void)updataActivityDate {
    [self mLoadActivityData];
}

//展开更多view
- (void)mExpandMoreAction {
    _isExpand = !_isExpand;
    
    [self reloadActivityViewAnimations];

    if (!_isExpand) {
        //折叠后更新cell 位置
        CGRect rect = [_vTableView rectForHeaderInSection:3];
        [_vTableView scrollRectToVisible:rect animated:NO];
    }
}


//BKMilk cell的组头视图内部的按钮的监听事件
- (void)mClickMilkMoreButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mHomeTableViewMilkMoreButtonDidClick)]) {
        [self.delegate mHomeTableViewMilkMoreButtonDidClick];
    }
}

//获取活动列表数据
- (void)mRequestActivityData:(NSString *)date {
    [EKHomeActivityModel mLoadActivityDate:date block:^(NSArray<EKHomeActivityModel *> *data, NSString *error) {
        self.userInteractionEnabled = YES;
        [self removeHUDActivity];
        if (error) {
            self.vActivityView.vUpdate = date;
            self.vActivityArray = @[];
        } else {
            _isExpand = NO;
            self.vActivityArray = [data[0].events copy];
            self.vActivityView.vUpdate = [data[0].date copy];
        }
        [self reloadActivityViewAnimations];
    }];
}

//刷新学校行事历view
- (void)reloadActivityViewAnimations {
    
    //有效解决刷新单个cell或者section闪一下的问题
    [UIView setAnimationsEnabled:NO];
    [_vTableView beginUpdates];
    [_vTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationMiddle];
    [_vTableView endUpdates];
    [UIView setAnimationsEnabled:YES];

}

#pragma mark - 所有执行的代理方法
//表头,点击滑动view  BLoopImageViewDelegate
- (void)mTouchLoopImageView:(BKLoopImageView *)imageView didSelectItem:(BKLoopViewModel *)item {
    DLog(@"点击banner item = %@",item);
    UIViewController *viewController = [self myViewController];
    //根据后台字段的有无,决定跳转到web/帖子详情/帖子列表中的一种
    if (![BKTool isStringBlank:item.skipurl]) {
        NSString *title = nil;
        if ([BKTool isStringBlank:item.title]) {
            title = @"精選";
        } else {
            title = item.title;
        }
        [EKHomeWebViewController showHomeWebViewControllerWithTitle:title URLString:item.skipurl fromViewController:viewController pageType:WebPageTypeNormal];
    } else if (![BKTool isStringBlank:item.tid]) {
        EKThemeDetailViewController *detailViewController = [[EKThemeDetailViewController alloc] init];
        detailViewController.tid = @(item.tid.integerValue);
        [viewController.navigationController pushViewController:detailViewController animated:YES];
    } else if (![BKTool isStringBlank:item.fid]) {
        BKThemeListViewController *themeListViewController = [[BKThemeListViewController alloc] init];
        themeListViewController.vFid = item.fid;
        [viewController.navigationController pushViewController:themeListViewController animated:YES];
    }
}

#pragma mark - EKHomeFourCellDelegate
//点击TV cell 内部的按钮的时候调用
- (void)mHomeFourCellButtonDidClickWithIndex:(NSInteger)index {
    //回传当前点击的TV Model
    if (self.delegate && [self.delegate respondsToSelector:@selector(mHomeTableViewTVCellDidClickWithIndex:)]) {
        [self.delegate mHomeTableViewTVCellDidClickWithIndex:index];
    }
}


#pragma mark - EKHomeFifthlyCellDelegate
//点击KMall的cell时候调用
- (void)mCollectionViewDidClickItemWithIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mHomeTableViewKMallCellDidClickWithIndex:)]) {
        [self.delegate mHomeTableViewKMallCellDidClickWithIndex:index];
    }
}


#pragma mark - 按钮监听事件
//点击顶部左侧上下广告按钮时候调用
- (void)mClickHomeTopDownAdvertiseButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mHomeTableViewTopUpDownAdvertiseButtonDidClickWithIndex:)]) {
        //回传按钮索引
        NSInteger index = [self.vHomeTopDownAdvertiseButtonArray indexOfObject:button];
        [self.delegate mHomeTableViewTopUpDownAdvertiseButtonDidClickWithIndex:index];
    }
}


#pragma mark - TableViewDelegate/Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.presenter.vHeadHeight.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return _vHomeListModel.thread.count;
        }
        case 1: {
            return _vHomeListModel.milk.count;
        }
        case 2: {
            if (_isExpand) {
                return _vActivityArray.count;
            } else {
                return _vActivityArray.count > 2 ? 2 : _vActivityArray.count;
            }
        }
        case 3: {
            return _vOteModel.options.count;
        }
        default: {
            return 2;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.presenter.vHeadHeight.count - 1 && indexPath.row == 1) {
        return [self.presenter.vHeadHeight[indexPath.section][2] floatValue];
    }
    return [self.presenter.vHeadHeight[indexPath.section][1] floatValue];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            EKHomeFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:firstCell forIndexPath:indexPath];
            cell.vHomeThreadModel = _vHomeListModel.thread[indexPath.row];
            return cell;
        }
        case 1: {
            EKHomeSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:secondCell forIndexPath:indexPath];
            cell.vHomeMilkModel = _vHomeListModel.milk[indexPath.row];
            return cell;
        }
        case 2: {
            return [self mActivityTableView:tableView cellForRow:indexPath];
        }
        case 3: {
            EKHomeThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:thirdCell forIndexPath:indexPath];
            cell.delegate = self;
            [cell mUpdata:_vOteModel.options[indexPath.row] selectSet:self.voteIdArray duration:_vOteModel.myselect];
            return cell;
        }
        case 4: {
            if (indexPath.row == 0) {
                EKHomeFourCell *cell = [tableView dequeueReusableCellWithIdentifier:fourCell forIndexPath:indexPath];
                cell.delegate = self;
                cell.vHomeTVModelDataSource = _vHomeListModel.tv;
                return cell;
            } else {
                EKHomeFifthlyCell *cell = [tableView dequeueReusableCellWithIdentifier:fifthlyCell forIndexPath:indexPath];
                cell.delegate = self;
                cell.vHomeKMallModelDataSource = _vHomeListModel.kmall;
                return cell;
            }
        }
    }
    return nil;
}

//活动cell，根绝日期来展示
- (UITableViewCell *)mActivityTableView:(UITableView *)tableView cellForRow:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defineCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defineCell"];
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.imageView.image = [UIImage imageNamed:@"home_menu_vi_circular_t"];
    EKHomeActivityEventModel *eventModel = _vActivityArray[indexPath.row];
    cell.textLabel.text = eventModel.name;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.backgroundColor = indexPath.row % 2 ? [UIColor EKHeadColorYellow] : [UIColor EKHomeCellYeallow];
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 4) {
        //第二个广告位的高度
        if (self.vHomeBannerArray.count > 1) {
            BADBannerView *view  = self.vHomeBannerArray[1];
            return view.vBannerHeight;
        } else {
            return staticHeight;
        }
    } else {
        return [self.presenter.vHeadHeight[section][0] floatValue];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: {//顶部轮播广告图片view
            return [self mHeadLoopView:(NSInteger)section];
        }
        case 1: {//选择更多文章head view
            return [self headerSectionView:[self.presenter.vHeadHeight[section][0] floatValue]];
        }
        case 2: { //活动日期选择view
            return self.vActivityView;
        }
        case 3: {//投票主题view
            return [self headerVoteView:[self.presenter.vHeadHeight[section][0] floatValue]];
        }
        case 4: { //第二个广告位
            return  [self mReturnHomeADViewWithFrameTag:1];
        }
        default:
            return nil;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        //第一个广告位的高度
        if (self.vHomeBannerArray.count > 0) {
            BADBannerView *view  = self.vHomeBannerArray[0];
            return view.vBannerHeight;
        } else {
            return staticHeight;
        }
    } else if (section == 2 && _vActivityArray.count < 3) {
        if (_vFooter2SectionView) {
            [_vFooter2SectionView removeFromSuperview];
            _vFooter2SectionView = nil;
        }
        return staticHeight;
    } else {
        return [self.presenter.vFootHeight[section] floatValue];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:{
            //第一个广告位
            return  [self mReturnHomeADViewWithFrameTag:0];
        }
        case 2:{
            return [self footerSection2View:[self.presenter.vFootHeight[section] floatValue]];
        }
        case 3: {
            return [self footerSection3View:[self.presenter.vFootHeight[section] floatValue]];
        }
        default:
            return nil;
    }
}


//cell点击时候调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mHomeTableViewCellDidClickAtIndexpath:)]) {
        if (indexPath.section == 2) {
            [self.delegate mHomeTableViewTopActivityData:self.vActivityArray[indexPath.row]];
        } else {
            [self.delegate mHomeTableViewCellDidClickAtIndexpath:indexPath];
        }
    }
}

#pragma mark - 重写setter方法, 更新UI
//更新顶部左侧上下广告按钮的UI
- (void)setVHomeTopUpDownAdvertiseDataSource:(NSArray<EKHomeTopUpDownAdvertiseModel *> *)vHomeTopUpDownAdvertiseDataSource {
    _vHomeTopUpDownAdvertiseDataSource = vHomeTopUpDownAdvertiseDataSource;
    [_vTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}


//更新顶部轮播banner的UI
- (void)setVHomeLoopImageViewDataSource:(NSArray<BKLoopViewModel *> *)vHomeLoopImageViewDataSource {
    _vHomeLoopImageViewDataSource = vHomeLoopImageViewDataSource;
    [_vTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}


//更新四个列表
- (void)setVHomeListModel:(EKHomeListModel *)vHomeListModel {
    _vHomeListModel = vHomeListModel;
    [_vTableView reloadData];
}

//投票数据
- (void)setVOteModel:(EKHomeVoteModel *)vOteModel {
    [self removeHUDActivity];
    [self.voteIdArray removeAllObjects];
    _vOteModel = vOteModel;
    if (!_vOteModel.myselect) {//当未参与过
        _vOteModel.myselect = !_vOteModel.overdue;//判断是否过期，过期后表示投过票
    }
    
    [_vTableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - InitView (包括左右view 的创建)
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //添加item view
        [self mAddItemViews];
       
        //获取活动列表数据
        [self mLoadActivityData];
    }
    return self;
}

//注册cell
- (void)mAddItemViews {
    [self.vTableView registerNib:[UINib nibWithNibName:@"EKHomeFirstCell" bundle:nil] forCellReuseIdentifier:firstCell];
    [self.vTableView registerNib:[UINib nibWithNibName:@"EKHomeSecondCell" bundle:nil] forCellReuseIdentifier:secondCell];
    [self.vTableView registerNib:[UINib nibWithNibName:@"EKHomeThirdCell" bundle:nil] forCellReuseIdentifier:thirdCell];
    [self.vTableView registerNib:[UINib nibWithNibName:@"EKHomeFourCell" bundle:nil] forCellReuseIdentifier:fourCell];
    [self.vTableView registerNib:[UINib nibWithNibName:@"EKHomeFifthlyCell" bundle:nil] forCellReuseIdentifier:fifthlyCell];
    [self.vTableView registerClass:[EKHomeFifthlyCell class] forCellReuseIdentifier:fifthlyCell];
}

- (void)mLoadActivityData {
    NSString *date = [BKTool getTodyDate:@"yyyy-MM-dd"];
    [self mRequestActivityData:date];
}

- (UIView *)mHeadLoopView:(NSInteger)section {
    CGFloat headHeight = [self.presenter.vHeadHeight[section][0] floatValue];
    UIView *headView = [self mReturnHeadView:headHeight bgColor:[UIColor whiteColor]];
    //1.左侧上下广告
    _vHomeTopDownAdvertiseButtonArray = [NSArray array];
    NSMutableArray <UIButton *> *tempButtonArray = [NSMutableArray array];
    CGFloat buttonWidth = headHeight / 2;
    for (NSInteger i = 0; i < 2; i++) {
        EKHomeTopUpDownAdvertiseModel *model = _vHomeTopUpDownAdvertiseDataSource[i];
        UIButton *button = [self mReturnButtonFrame:CGRectZero imgNormal:nil imgSelect:nil text:model.title textColor:[UIColor whiteColor] tag:i target:@selector(mClickHomeTopDownAdvertiseButton:)];
        [headView addSubview:button];
        [tempButtonArray addObject:button];
        //根据数据源,设置UI
        NSURL *imageURL = [NSURL URLWithString:model.thumb];
        [button sd_setBackgroundImageWithURL:imageURL
                                    forState:UIControlStateNormal
                            placeholderImage:[UIImage imageNamed:kPlaceHolderGray]];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headView);
            make.width.mas_equalTo(buttonWidth);
        }];
    }
    _vHomeTopDownAdvertiseButtonArray = tempButtonArray.copy;
    [_vHomeTopDownAdvertiseButtonArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    
    //2.轮播banner
    [headView addSubview:self.vLoopImgView];
    _vLoopImgView.itemsArr = _vHomeLoopImageViewDataSource;
    return headView;
}

//查看BKMilk更多文章head view
- (UIView *)headerSectionView:(CGFloat)height {
    if (!_vHeader1SectionView) {
        _vHeader1SectionView = [self mReturnHeadView:height bgColor:[UIColor EKColorTableBackgroundGray]];
        UILabel *textLab = [self mReturnLabelFrame:CGRectMake(10, 0, _vHeader1SectionView.w-55, _vHeader1SectionView.h) text:@"學習教育" textColor:[UIColor EKColorTitleGray] font:18];
        [_vHeader1SectionView addSubview:textLab];
        UIImageView *imageMake = [self mReturnimageViewFrame:CGRectMake(_vHeader1SectionView.w - 50, 0, 50, 44) imageString:@"vi_double"];
        imageMake.contentMode = UIViewContentModeCenter;
        [_vHeader1SectionView addSubview:imageMake];
        UIButton *button = [self mReturnButtonFrame:_vHeader1SectionView.bounds imgNormal:nil imgSelect:nil text:nil textColor:nil tag:0 target:@selector(mClickMilkMoreButton)];
        [_vHeader1SectionView addSubview:button];
    }
    return _vHeader1SectionView;
}

//投票head section view
- (UIView *)headerVoteView:(CGFloat)height {
    if (!_vHeader3SectionView) {
        _vHeader3SectionView = [self mReturnHeadView:height bgColor:[UIColor EKColorNavigation]];
        UILabel *textLab = [self mReturnLabelFrame:CGRectMake(80, 0, _vHeader3SectionView.w-110, _vHeader3SectionView.h) text:nil textColor:[UIColor whiteColor] font:18];
        textLab.tag = 100;
        [_vHeader3SectionView addSubview:textLab];
    }
    UILabel *tempLab = [_vHeader3SectionView viewWithTag:100];
    tempLab.text = _vOteModel.subject;
    return _vHeader3SectionView;
}

//footer 展开查看更多活动数据view
- (UIView *)footerSection2View:(CGFloat)height {
    if (_vFooter2SectionView) {
        [_vFooter2SectionView removeFromSuperview];
        _vFooter2SectionView = nil;
    }
    
    if (!_vFooter2SectionView && _vActivityArray.count > 2) {
        _vFooter2SectionView = [self mReturnHeadView:height bgColor: [UIColor EKHeadColorYellow]];
        UIButton *button = [self mReturnButtonFrame:CGRectMake(0, 0, 100, height) imgNormal:@"home_bottom_unpressed" imgSelect:@"home_topa_unpressed" text:nil textColor:nil tag:100 target:@selector(mExpandMoreAction)];
        button.centerX = _vFooter2SectionView.centerX;
        [_vFooter2SectionView addSubview:button];
    } else {
        return nil;
    }
    UIButton *tempBtn = [_vFooter2SectionView viewWithTag:100];
    tempBtn.selected = _isExpand;
    return _vFooter2SectionView;
}

//footer 投票按钮view
- (UIView *)footerSection3View:(CGFloat)height {
    if (!_vFooter3SectionView) {
        _vFooter3SectionView = [self mReturnHeadView:height bgColor:[UIColor EKColorNavigation]];
        UIButton *button = [self mReturnButtonFrame:CGRectMake(80, 5, _vFooter3SectionView.w - 130, 30) imgNormal:nil imgSelect:nil text:@"投票" textColor:[UIColor EKColorNavigation] tag:100 target:@selector(mVoteAction)];
        [button imageWithColor:[UIColor whiteColor]];
        [_vFooter3SectionView addSubview:button];
    }
    UIButton *tempBtn = [_vFooter3SectionView viewWithTag:100];
    tempBtn.enabled = !_vOteModel.myselect;//是否投过票
    if (_vOteModel.myselect) {
        [tempBtn setTitle:@"投票結果" forState:UIControlStateNormal];
        [tempBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tempBtn setBackgroundImage:nil forState:UIControlStateNormal];
    } else {
        [tempBtn setTitle:@"投票" forState:UIControlStateNormal];
        [tempBtn setTitleColor:[UIColor EKColorNavigation] forState:UIControlStateNormal];
        [tempBtn imageWithColor:[UIColor whiteColor]];
    }
    return _vFooter3SectionView;
}

- (UIImageView *)mReturnimageViewFrame:(CGRect)rect imageString:(NSString *)url {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    if ([url hasPrefix:@"htpp"]) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    } else if (url) {
        imageView.image = [UIImage imageNamed:url];
    }
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

- (UIButton *)mReturnButtonFrame:(CGRect)rect imgNormal:(NSString *)imgN imgSelect:(NSString *)imgS text:(NSString *)text textColor:(UIColor *)colr tag:(NSInteger)tag target:(SEL)action {
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame = rect;
    customButton.tag = tag;
    customButton.titleLabel.font = [UIFont systemFontOfSize:15];
    if (text) [customButton setTitle:text forState:UIControlStateNormal];
    if (colr) [customButton setTitleColor:colr forState:UIControlStateNormal];
    if (imgN) [customButton setImage:[UIImage imageNamed:imgN] forState:UIControlStateNormal];
    if (imgS) [customButton setImage:[UIImage imageNamed:imgS] forState:UIControlStateSelected];
    [customButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return customButton;
}

- (UILabel *)mReturnLabelFrame:(CGRect)rect text:(NSString *)text textColor:(UIColor *)color font:(CGFloat)font {
    UILabel *textLabel = [[UILabel alloc] initWithFrame:rect];
    textLabel.text = text;
    textLabel.textColor = color;
    textLabel.font = [UIFont systemFontOfSize:font];
    textLabel.numberOfLines = 0;
    return textLabel;
}

- (UIView *)mReturnHeadView:(CGFloat)height bgColor:(UIColor *)color {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    sectionView.backgroundColor = color;
    return sectionView;
}

#pragma mark - 广告view
- (UIView *)mReturnHomeADViewWithFrameTag:(int)tag {
    if (_vHomeBannerArray.count > 1) {
        BADBannerView *bannerView = _vHomeBannerArray[tag];
        return bannerView;
    }
    return nil;
}


#pragma mark - 表头,初始化滑动view
- (BKLoopImageView *)vLoopImgView{
    if (!_vLoopImgView) {
        _vLoopImgView = [[BKLoopImageView alloc] initWithImageItems:nil delegate:self];
    }
    return _vLoopImgView;
}

- (UITableView *)vTableView {
    if (!_vTableView) {
        _vTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _vTableView.delegate = self;
        _vTableView.dataSource = self;
        _vTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _vTableView.separatorColor = [UIColor clearColor];
        [self addSubview:_vTableView];
        [_vTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self);
        }];
    }
    return _vTableView;
}

- (EKHomePresenter *)presenter {
    if (!_presenter) {
        _presenter = [[EKHomePresenter alloc] init];
    }
    return _presenter;
}

- (EKHomeActivityView *)vActivityView {
    if (!_vActivityView) {
        _vActivityView = [EKHomeActivityView getHomeActivityView];
        __weak typeof(self) bself = self;
        _vActivityView.updataDate = ^(NSString *date) {
            bself.userInteractionEnabled = NO;
            [bself showHUDActivityView:kStartLoadingText shade:NO];
            [bself mRequestActivityData:date];
        };
    }
    _vActivityView.alpha = 1;
    [_vActivityView layoutIfNeeded];
    return _vActivityView;
}
- ( NSMutableArray<NSNumber *> *)voteIdArray {
    if (!_voteIdArray) {
        _voteIdArray = [NSMutableArray array];
    }
    return _voteIdArray;
}

//广告数据
- (NSArray <BADBannerView *> *)vHomeADArray {
    if (!_vHomeBannerArray) {
        _vHomeBannerArray = [NSMutableArray array];
    }
    return _vHomeBannerArray;
}

@end
