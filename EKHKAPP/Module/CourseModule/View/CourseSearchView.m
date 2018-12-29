//
//  CourseSearchView.m
//  EduKingdom
//
//  Created by HY on 16/7/7.
//  Copyright © 2016年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import "CourseSearchView.h"
#import "CourseTableViewCell.h"

@interface CourseSearchView ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic , strong) CourseOptionModel *courseTypeModel;
@property (nonatomic , strong) UIImageView *imageAdView;
@property (weak, nonatomic) IBOutlet UIView *vSearchTopView;
@end

@implementation CourseSearchView

+(CourseSearchView *)mGetInstance{
    CourseSearchView *view = [[[NSBundle mainBundle] loadNibNamed:@"CourseSearchView" owner:nil options:nil] firstObject];
    if (view) {
        [view mInit];
    }
    return view;
}

- (void)drawRect:(CGRect)rect{
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _vSearchTopView.maxH + _imageAdView.image.size.height);
    _imageAdView.frame = CGRectMake(0, _scrollView.contentSize.height-_imageAdView.image.size.height, SCREEN_WIDTH, _imageAdView.image.size.height);
}


//初始化
- (void)mInit {
    vSourceData = [NSMutableArray arrayWithCapacity:0];
    
    self.vSearchBtn.layer.cornerRadius  = 4;
    self.vPickerView.delegate           = self;
    self.vCoverNameTF.delegate          = self;
    self.vUnitTF.delegate               = self;
    
    //pickerView 隐藏
    [self mHiddenPickerView];
    [self mReloadData];
    
    //清除两个输入框的默认灰色边框效果
    CGFloat borderWidth = 2;
    CGFloat cornerRadius = 3;
    _vCoverNameTF.layer.borderColor = [UIColor whiteColor].CGColor;
    _vCoverNameTF.layer.borderWidth = borderWidth;
    _vCoverNameTF.layer.cornerRadius = cornerRadius;
    _vCoverNameTF.layer.masksToBounds = YES;
    _vUnitTF.layer.borderColor = [UIColor whiteColor].CGColor;
    _vUnitTF.layer.borderWidth = borderWidth;
    _vUnitTF.layer.cornerRadius = cornerRadius;
    _vUnitTF.layer.masksToBounds = YES;
    
   //底部放入一张图片
    UIImage *img = IS_IPAD ? [UIImage imageNamed:@"kmall_ipad"] : [UIImage imageNamed:@"kmall_"];
    _imageAdView = [[UIImageView alloc] initWithImage:img];
    [self.scrollView addSubview:_imageAdView];

}
//请求三个选项数据
-(void)mReloadData{
    [CourseOptionModel loadOptionResultData:^(CourseOptionModel *data, NSString *netErr) {
        if (data) {
            NSLog(@"data = %@",data);
            self.courseTypeModel = data;
        }
    }];
}

#pragma mark - 课程目录，课程限额，课程区域点击弹出选择框事件
- (IBAction)mTapClick:(UIButton *)sender {
    if (!self.courseTypeModel) {
        [self showHUDTitleView:@"數據出現錯誤，請稍後再試" image:nil];
        [self mReloadData];
        return;
    }
    
    //清空数据，重新赋值
    [vSourceData removeAllObjects];
    [self.vPickerView reloadAllComponents];
    self.selectType = ENUM_NULL;
    vSaveTempId = @"";
    vSaveTempValue = @"";
    [self.vCoverNameTF resignFirstResponder];
    [self.vUnitTF resignFirstResponder];

    switch (sender.tag) {
        case 100:
        {
            self.selectType = ENUM_CATEGORY;
            self.vPickerTitle.text = @"課程分類";
            [vSourceData setArray:_courseTypeModel.category];
        }
            break;
        case 200:
        {
            self.selectType = ENUM_DISTRICT;
            self.vPickerTitle.text = @"區域";
            [vSourceData setArray:_courseTypeModel.district];
            
        }
            break;
        case 300:
        {
            self.selectType = ENUM_AGE;
            self.vPickerTitle.text = @"年齡";
            [vSourceData setArray:_courseTypeModel.ages];
        }
            break;
        case 400:
        {
            self.selectType = ENUM_FEE;
            self.vPickerTitle.text = @"費用";
            [vSourceData setArray:_courseTypeModel.fee];
        }
            break;
        case 500:
        {
            self.selectType = ENUM_BUSINESS;
            self.vPickerTitle.text = @"公司商業登記";
            [vSourceData setArray:_courseTypeModel.business];
        }
            break;
       
        default:
            break;
    }
    
    if (vSourceData.count) {
        [self mShowPickerView]; //弹出pickerview
        [self.vPickerView reloadAllComponents]; //获取数据后，重新刷新
    }else{
        [self mReloadData];
    }
   
}

#pragma mark - picker上的确定和取消按钮
- (IBAction)mPickerBtnClick:(id)sender {
    UIButton *btn = sender;
    switch (btn.tag) {
        case 11: //取消
            break;
        case 12: //确定
        {
            //没有滚动picker，点击确认，默认取第一个数据
            if ([vSaveTempId isEqualToString:@""]) {
                if ( _selectType == ENUM_FEE ||
                    self.selectType == ENUM_AGE ||
                    self.selectType == ENUM_BUSINESS ) {
                    CourseRestListModel *model = [vSourceData objectAtIndex:0];
                    vSaveTempId = model.value.length ? model.value : @(model.vId).description;
                    vSaveTempValue = model.name;
                }else{
                    CourseCategoryModel *model = [vSourceData objectAtIndex:0];
                    NSArray *arr = model.cs;
                    vSaveTempId = [arr objectAtIndex:0][@"id"];
                    vSaveTempValue = [arr objectAtIndex:0][@"name"];
                }
            }
            if (_selectType == ENUM_CATEGORY) {
                vSaveCategory = vSaveTempId;
                [_vCategoryBtn setTitle:vSaveTempValue forState:UIControlStateNormal];
            }else if (_selectType == ENUM_DISTRICT){
                vSaveDistrict = vSaveTempId;
                [_vDistrictBtn setTitle:vSaveTempValue forState:UIControlStateNormal];
            }else if (_selectType == ENUM_FEE){
                vSaveFee = vSaveTempId;
                [_vFeeBtn setTitle:vSaveTempValue forState:UIControlStateNormal];
            }else if (_selectType == ENUM_AGE){
                vSaveAge = vSaveTempId;
                [_vAgeBtn setTitle:vSaveTempValue forState:UIControlStateNormal];
            }else if (_selectType == ENUM_BUSINESS){
                vSaveBusienss = vSaveTempId;
                [_vBusinessBtn setTitle:vSaveTempValue forState:UIControlStateNormal];
            }
        }
            break;
            
        default:
            break;
    }
    [self mHiddenPickerView];
}

#pragma mark - 点击蒙版层，view消失
- (IBAction)mCoverViewClick:(id)sender {
    [self mHiddenPickerView];
}

#pragma mark - 搜索按钮点击事件
- (IBAction)mSearchBtnClick:(id)sender {
    if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(mSearchResoultClick:)]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
       
        [dic setObject:self.vCoverNameTF.text.length ? self.vCoverNameTF.text : @""
                forKey:@"cname"];       //课程名称
        [dic setObject:self.vUnitTF.text.length ? self.vUnitTF.text : @""
                forKey:@"company"];     //主办单位
        [dic setObject:vSaveCategory.length ? vSaveCategory : @""
                forKey:@"categoryid"];  //课程目录
        [dic setObject:vSaveDistrict.length ? vSaveDistrict : @""
                forKey:@"districtid"];  //课程区域
        [dic setObject:vSaveFee.length ? vSaveFee : @""
                forKey:@"feeval"];      //课程限额
        [dic setObject:vSaveAge.length ? vSaveAge : @""
                forKey:@"ageid"];       //年龄
        [dic setObject:vSaveBusienss.length ? vSaveBusienss : @""
                forKey:@"busval"];      //商业等级
        [dic setObject:@"0"
                forKey:@"page"];        //分页
        
        [self.vDelegate mSearchResoultClick:dic];
        
    }
}

#pragma mark - UIPickerViewDelegate
//一共多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if ( self.selectType == ENUM_FEE ||
        self.selectType == ENUM_AGE ||
        self.selectType == ENUM_BUSINESS )
    {
        return 1;
    }else{
        return 2;
    }
    
}
//每列对应多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (vSourceData.count) {
        if ( self.selectType == ENUM_FEE ||
            self.selectType == ENUM_AGE ||
            self.selectType == ENUM_BUSINESS ) {
            return [vSourceData count];
        }else{
            if (component == 0 ) {
                return [vSourceData count];
            }else if(component == 1 ){
                NSInteger row = [pickerView selectedRowInComponent:0];
                CourseCategoryModel *model = [vSourceData objectAtIndex:row];
                return model.cs.count;
            }else{
                return 0;
            }
        }
    }
    return 0;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (vSourceData.count > 0) {
        if ( self.selectType == ENUM_FEE ||
            self.selectType == ENUM_AGE ||
            self.selectType == ENUM_BUSINESS ) {
            CourseRestListModel *model = [vSourceData objectAtIndex:row];
            return model.name;
        }else{
            if (component == 0) {
                CourseCategoryModel *model = [vSourceData objectAtIndex:row];
                return model.name;
            }else{
                CourseCategoryModel *model = [vSourceData objectAtIndex:[pickerView selectedRowInComponent:0]];
                NSArray *arr = model.cs;
                if (row < arr.count) {
                    return [arr objectAtIndex:row][@"name"];
                }
            }
        }
    }
    return nil;
}
//当用户选择某个row时,picker view调用此函数
-(void) pickerView: (UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component{
    if ( self.selectType == ENUM_FEE ||
        self.selectType == ENUM_AGE ||
        self.selectType == ENUM_BUSINESS ) {
        CourseRestListModel *model = [vSourceData objectAtIndex:row];
        vSaveTempId = model.value.length ? model.value : @(model.vId).description;
        vSaveTempValue = model.name;
    }else{
        
        switch (component) {
            case 0:
                //如果滚动一级列表，则需要刷新二级列表数据来对应显示
                [_vPickerView reloadComponent:1];
                [_vPickerView selectRow:0 inComponent:1 animated:NO];
                row = 0;
                break;
            default:
                break;
        }
        
        //选择的是课程目录或区域
        CourseCategoryModel *model = [vSourceData objectAtIndex:[pickerView selectedRowInComponent:0]];
        NSArray *arr = model.cs;
        if (self.selectType == ENUM_CATEGORY || self.selectType == ENUM_DISTRICT){
            vSaveTempId = [arr objectAtIndex:row][@"id"];
            vSaveTempValue = [arr objectAtIndex:row][@"name"];
        }

    }
}

//row高度
- (CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent: (NSInteger) component{
    return 30;
}

//显示PickerView
-(void)mShowPickerView{
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self.vPickerBg_bottom_space.constant = 0;
        self.vCoverView.hidden = NO;
        [self layoutIfNeeded];
    }];
    [self  clearSeparatorWithPicker:_vPickerView];
}

//隐藏PickerView
-(void)mHiddenPickerView{
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self.vPickerBg_bottom_space.constant = -Course_Picker_Height - 10;
        self.vCoverView.hidden = YES;
        [self layoutIfNeeded];
    }];
}

//清除pickerView上的分割线
- (void)clearSeparatorWithPicker:(UIView * )view{
    if(view.subviews != 0  ){
        if(view.bounds.size.height < 5){
            view.backgroundColor = [UIColor clearColor];
        }
        [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self clearSeparatorWithPicker:obj];
        }];
    }
}

#pragma mark - TextField
//点击return按钮,键盘隐藏
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
