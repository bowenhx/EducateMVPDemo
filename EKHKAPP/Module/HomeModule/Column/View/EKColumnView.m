/**
 -  EKColumnView.m
 -  EKHKAPP
 -  Created by ligb on 2017/9/8.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "EKColumnView.h"
#import "EKColumnModel.h"
#import "EKColumnViewCell.h"
#import "EKEditThemeViewController.h"
#import "EKNavigationViewController.h"
#import "BKThemeListViewController.h"

@interface EKColumnView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *vTableView;
@property (nonatomic, strong) NSMutableArray<EKColumnModel *> *vDatasource;
@property (nonatomic, strong) UIButton *editBtn;

@end

@implementation EKColumnView

+ (EKColumnView *)share {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithFrame:CGRectMake(-([UIScreen mainScreen].bounds.size.width), NAV_BAR_HEIGHT,  [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - NAV_BAR_HEIGHT)];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:sharedInstance];
    });
    return sharedInstance;
}

+ (void)animateColumnViewAction:(BOOL)isAnimation {
    EKColumnView *columnView = [EKColumnView share];
    if (columnView.x < 0) {
        [columnView showColumnViewAction:isAnimation];
    } else {
        [columnView hiddenColumnViewAction];
    }
}

+ (void)mReloadData {
//    if (LOGINSTATUS) {
//        [BKSaveData setArray:@[] key:kPreferForumInfoKey];
//        [[[EKColumnView share] editBtn] setTitle:@"加入討論" forState:UIControlStateNormal];
//    }
//    [[EKColumnView share] mLoadData];
}

//显示view
- (void)showColumnViewAction:(BOOL)isAnimation {
    
    //谷歌统计
    [EKGoogleStatistics mGoogleScreenAnalytics:kForumListPageIndex];
    
    CGFloat animationTime = 0;
    if (isAnimation) {
        animationTime = 0.35;
    }
    EKColumnView *columnView = [EKColumnView share];
    [UIView animateWithDuration:animationTime animations:^{
        columnView.transform = CGAffineTransformMakeTranslation(columnView.frame.size.width, 0);
    }];
}


//隐藏view(类方法)
+ (void)hiddenColumnViewAction {
    EKColumnView *columnView = [EKColumnView share];
    if (columnView.x >= 0) {
        [columnView hiddenColumnViewAction];
    }
}


//隐藏view(对象方法)
- (void)hiddenColumnViewAction {
    EKColumnView *columnView = [EKColumnView share];
    [UIView animateWithDuration:0.35 animations:^{
        columnView.transform = CGAffineTransformMakeTranslation(-columnView.frame.size.width, 0);
    }];
}

//编辑
- (void)mDidEditAction {
    [self hiddenColumnViewAction];
    EKEditThemeViewController *editThemeVC = [[EKEditThemeViewController alloc] initWithNibName:@"EKEditThemeViewController" bundle:nil];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    EKNavigationViewController *nav = [[EKNavigationViewController alloc] initWithRootViewController:editThemeVC];
    [window.rootViewController presentViewController:nav animated:NO completion:nil];
    [window bringSubviewToFront:nav.view];
}

//折叠展开
- (void)mDidExpandAction:(UIButton *)sender {
    self.vDatasource[sender.tag].isExpand = !self.vDatasource[sender.tag].isExpand;
    [_vTableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)mLoadData {
    [EKColumnModel mGetEKColumnModel:^(NSArray<EKColumnModel *> *array) {
        [self.vDatasource setArray:array];
        [self.vTableView reloadData];
        if (array.count) {
            [_editBtn setTitle:@"編輯" forState:UIControlStateNormal];
        } else {
            [_editBtn setTitle:@"加入討論" forState:UIControlStateNormal];
        }
    }];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.vDatasource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.vDatasource[section].isExpand ? self.vDatasource[section].subforums.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EKColumnViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"columnCell" forIndexPath:indexPath];
    EKForumCollectModel *model = self.vDatasource[indexPath.section].subforums[indexPath.row];
    [cell setText:model.name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hiddenColumnViewAction];
    //判断是否需要输入密码
    EKForumCollectModel *model = self.vDatasource[indexPath.section].subforums[indexPath.row];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kHomePushNextNotification
                                                            object:@{@"fid":@(model.fid),
                                                                     @"password":@""
                                                                     }];
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self sectionHeaderView:section];
}


#pragma mark - initView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self mAddItemView];
        
        [self mLoadData];
    }
    return self;
}

- (void)mAddItemView {
    UIView *iView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width-80, self.bounds.size.height)];
    iView.backgroundColor = [UIColor EKColorTableTitleDarkCyan];
    _vTableView = [[UITableView alloc] initWithFrame:CGRectInset(iView.bounds, 20, 0) style:UITableViewStylePlain];
    _vTableView.backgroundColor = [UIColor EKColorTableTitleDarkCyan];
    _vTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _vTableView.delegate = self;
    _vTableView.dataSource = self;
    [_vTableView registerNib:[UINib nibWithNibName:@"EKColumnViewCell" bundle:nil] forCellReuseIdentifier:@"columnCell"];
    [_vTableView setTableFooterView:[self footerView]];
    [iView addSubview:self.vTableView];

    //右边button ，作为隐藏该页面功能
    UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    touchBtn.frame = CGRectMake(iView.maxX, 0, 80, self.h);
    [self addSubview:iView];
    [self addSubview:touchBtn];
    [touchBtn addTarget:self action:@selector(hiddenColumnViewAction) forControlEvents:UIControlEventTouchUpInside];
}

//section head view
- (UIView *)sectionHeaderView:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _vTableView.w, 44)];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    icon.image = [UIImage imageNamed:@"home_menu_vi_circular"];
    icon.contentMode = UIViewContentModeCenter;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(icon.maxX+5, 0, headView.w-50, 44)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.vDatasource[section].name;
    UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    touchBtn.frame = CGRectMake(0, 0, headView.w, 44);
    touchBtn.tag = section;
    [touchBtn addTarget:self action:@selector(mDidExpandAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //如果含有子版块，显示折叠展开的箭头
    if (self.vDatasource[section].subforums.count > 0) {
        CGFloat arrowImageWH = 44;
        UIImageView *_vArrowImage = [[UIImageView alloc] init];
        _vArrowImage.frame = CGRectMake(headView.w - arrowImageWH, 0, arrowImageWH, arrowImageWH);
        _vArrowImage.contentMode = UIViewContentModeCenter;
        _vArrowImage.image = [UIImage imageNamed:@"home_menu_vi_triangle"];
        if (self.vDatasource[section].isExpand) {
            _vArrowImage.transform = CGAffineTransformMakeRotation(-M_PI_2);
        } else {
            _vArrowImage.transform = CGAffineTransformIdentity;
        }
        [headView addSubview:_vArrowImage];
    }
    
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, headView.h-0.5, headView.w, 0.5);
    layer.backgroundColor = [UIColor EKColorSeperateCyan].CGColor;
    [headView addSubview:icon];
    [headView addSubview:titleLabel];
    [headView addSubview:touchBtn];
    [headView.layer addSublayer:layer];
    return headView;
}

//footerView
- (UIView *)footerView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _vTableView.w, 74)];
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame = CGRectMake(0, footerView.h-33, footerView.w, 33);
    [_editBtn setTitle:@"編輯" forState:UIControlStateNormal];
    [_editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_editBtn updataBtnBackground];
    [footerView addSubview:_editBtn];
    [_editBtn addTarget:self action:@selector(mDidEditAction) forControlEvents:UIControlEventTouchUpInside];
    return footerView;
}

- (NSMutableArray<EKColumnModel *> *)vDatasource {
    if (!_vDatasource) {
        _vDatasource = [NSMutableArray array];
    }
    return _vDatasource;
}



@end
