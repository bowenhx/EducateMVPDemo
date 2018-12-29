/**
 -  EKFirstLaunchScrollView.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/14.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是程序首次启动时显示的给用户选择喜欢的版块的scrollView
 -  由于"首次启动"界面的跳转效果用UIViewController不好实现,所以使用了UIScrollView.
 -  本scrollView其实可以当做成控制器来看待,"选择年级"和"选择板块"的view也可以当做控制器来看待
 */

#import "EKFirstLaunchScrollView.h"
#import "EKFirstLaunchGradeView.h"
#import "EKFirstLaunchForumView.h"

@interface EKFirstLaunchScrollView () <EKFirstLaunchGradeViewDelegate, EKFirstLaunchForumViewDelegate>
//"选择年级"view
@property (nonatomic, strong) EKFirstLaunchGradeView *vGradeView;
//"选择版块"view
@property (nonatomic, strong) EKFirstLaunchForumView *vForumView;
@end

@implementation EKFirstLaunchScrollView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self mInitUI];
    }
    return self;
}


#pragma mark - 初始化UI
- (void)mInitUI {
    [self mInitSelfUI];
    [self mInitGradeView];
    [self mInitForumView];
}


//设置scrollView自身
- (void)mInitSelfUI {
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    self.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT);
    self.pagingEnabled = YES;
    self.bounces = NO;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.scrollEnabled = NO;
}


//设置"选择年级"view
- (void)mInitGradeView {
    _vGradeView = [[EKFirstLaunchGradeView alloc] init];
    _vGradeView.delegate = self;
    [self addSubview:_vGradeView];
    [_vGradeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.height.equalTo(self);
    }];
}


//设置"选择版块"view
- (void)mInitForumView {
    _vForumView = [[EKFirstLaunchForumView alloc] init];
    _vForumView.delegate = self;
    [self addSubview:_vForumView];
    [_vForumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self);
        make.left.equalTo(_vGradeView.mas_right);
    }];
}


#pragma mark - EKFirstLaunchGradeViewDelegate
//点击"选择年级"界面的"下一步"按钮的时候调用
- (void)mClickGradeNextStepButtonWithFirstLaunchListModel:(EKFirstLaunchListModel *)listModel {
    [self setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    //需要对选中的listModel进行subforum字段的处理(hidden字段)
    _vForumView.vListModel = [listModel mAddEmptySubforumModelAndSetHidden];
}


#pragma mark - EKFirstLaunchForumViewDelegate
//点击"选择版块"界面的"下一步"按钮的时候调用
- (void)mClickForumViewNextStepButton {
    //让首页不要默认加载第0个标签的数据
    [BKSaveData setBool:NO key:kIsHomeLoadFirstItemDataKey];
    //发送一个通知,让首页根据用户选择的年级与板块信息,重新加载数据并更新UI
    [[NSNotificationCenter defaultCenter] postNotificationName:kFirstLaunchSelectFinishNotification object:nil];
    
    //将自身从当前屏幕移除
    [UIView animateWithDuration:0.3f animations:^{
        self.contentOffset = CGPointMake(SCREEN_WIDTH * 2, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - 供外部访问的方法
/**
 显示"首次启动"界面,内部做好了显示时机的判断
 */
+ (void)mShowFirstLaunchScrollView {
    //用户未完成"首次启动"的选择的话,则需要继续显示"首次启动"界面
    if (![BKSaveData getBool:kIsFinishFirstLaunchChooseKey]) {
        EKFirstLaunchScrollView *firstLaunchScrollView = [[EKFirstLaunchScrollView alloc] init];
        [[UIApplication sharedApplication].keyWindow addSubview:firstLaunchScrollView];
    }
}


@end
