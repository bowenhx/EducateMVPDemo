/**
 -  EKFirstLaunchGradeViewController.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/13.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:"首次启动"界面的第一层界面,"选择年级"
 */

#import "EKFirstLaunchGradeView.h"
#import "EKFirstLaunchGradePickerLabel.h"
#import "EKFirstLaunchForumView.h"
#import "EKFirstLaunchGradeView+ShowLoadFailView.h"

@interface EKFirstLaunchGradeView () <UIPickerViewDataSource, UIPickerViewDelegate>
//绑定的xib的主view
@property (nonatomic, weak) IBOutlet UIView *vContentView;
//后台返回的数据源数组
@property (nonatomic, strong) NSArray <EKFirstLaunchListModel *> *vListModelDataSource;
//中间的pickerView
@property (weak, nonatomic) IBOutlet UIPickerView *vPickerView;
//用来适配ipX
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vTopImageViewTopMargin;
@end

@implementation EKFirstLaunchGradeView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self mInitUI];
        [self mInitData];
    }
    return self;
}


#pragma mark - 初始化UI
- (void)mInitUI {
    [[NSBundle mainBundle] loadNibNamed:@"EKFirstLaunchGradeView" owner:self options:nil];
    [self addSubview:self.vContentView];
    self.vContentView.frame = self.bounds;
    _vTopImageViewTopMargin.constant = NAV_BAR_HEIGHT - 14;
}


#pragma mark - 初始化数据
- (void)mInitData {
    [self mRequestDataWithLoadingText:@"正在加載..."];
}


/**
 请求网络数据,外界传入加载时显示的文字

 @param loadingText 加载时显示的文字
 */
- (void)mRequestDataWithLoadingText:(NSString *)loadingText {
    [self showHUDActivityView:loadingText shade:NO];
    [EKFirstLaunchListModel mRequestFirstLaunchDataWithCallBack:^(NSArray<EKFirstLaunchListModel *> *data, NSString *netErr) {
        [self mRemoveLoadFailView];
        [self removeHUDActivity];
        if (netErr) {
            //显示加载失败视图
            @WEAKSELF(self);
            [self mShowLoadFailViewWithRetryDidClickCallBack:^{
                [selfWeak mRequestDataWithLoadingText:@"正在重新請求網絡中..."];
            }];
        } else {
            _vListModelDataSource = data;
            [_vPickerView reloadAllComponents];
            //在pickerView加载完后台返回的数据之后,默认选中最中间的年级
            [_vPickerView selectRow:(_vListModelDataSource.count / 2) inComponent:0 animated:NO];
        }
    }];
}


#pragma mark - UIPickerViewDataSource
//返回列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


//返回行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _vListModelDataSource.count;
}


#pragma mark - UIPickerViewDelegate
//返回视图
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    CGRect frame = CGRectMake(0, 0, 235, 100);
    EKFirstLaunchGradePickerLabel *label = [[EKFirstLaunchGradePickerLabel alloc] initWithFrame:frame];
    label.text = _vListModelDataSource[row].name;
    return label;
}


//返回高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 70;
}


#pragma mark - 按钮监听事件
//点击"下一步"按钮
- (IBAction)mClickNextStepButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mClickGradeNextStepButtonWithFirstLaunchListModel:)]) {
        //获取到pickerView当前选中的行的序号
        NSInteger selectedRow = [_vPickerView selectedRowInComponent:0];
        DLog(@"点击了'下一步'按钮,当前选中的行为:%zd  对应的model为:%@",selectedRow,_vListModelDataSource[selectedRow]);
        [self.delegate mClickGradeNextStepButtonWithFirstLaunchListModel:_vListModelDataSource[selectedRow]];
    }
}




@end
