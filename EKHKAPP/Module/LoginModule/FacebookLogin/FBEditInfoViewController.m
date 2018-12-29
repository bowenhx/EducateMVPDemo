/**
 -  FBEditInfoViewController.m
 -  BKMobile
 -  Created by ligb on 2017/8/4.
 -  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
 */

#import "FBEditInfoViewController.h"
#import "FBTextFieldTableViewCell.h"
#import "FBTowBtnTableViewCell.h"
#import "FBOneBtnTableViewCell.h"
#import "FBEditUserInfoPersenter.h"
#import "FBInfoDataModel.h"
#import "EXButton.h"
#import "FBSelectItemViewController.h"

@interface FBEditInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>{
    EXButton *_tempButton;
    
    UITextField     *_vTempTextField;
    
    NSString        *_pickTitle;
    NSInteger       _pickRow;
    NSInteger       _tempPickComponent;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *vNextBtn;

@property (strong, nonatomic) IBOutlet UIView *pickerViewBg;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;


@property (nonatomic , strong) NSMutableArray *pickerData;
@property (nonatomic, strong) NSMutableArray *datasource;

@property (nonatomic, strong) FBEditUserInfoPersenter *persenter;
@property (nonatomic, strong) FBInfoDataModel *fbDataModel;
@property (nonatomic, strong) FBItemModel     *tempFbItemModel;
@property (nonatomic, strong) NSMutableDictionary *dictEdit;


@end

@implementation FBEditInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"會員資料";
//    [self backBtn];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self loadNewView];
    
    [self loadNewData];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
    [self initColor];
}
- (void)initColor{
    self.navigationController.navigationBar.barTintColor = [UIColor EKColorNavigation];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)loadNewView{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor EKColorBackground];
    self.tableView.backgroundView = bgView;
    [_vNextBtn updataBtnBackground];
    
    self.footerView.backgroundColor = [UIColor EKColorBackground];
    self.tableView.tableFooterView = self.footerView;
    
    [self setPickerViewFrame];
    

    
}

- (void)loadNewData{
    [self.datasource setArray:[self getNormal]];
    
    _persenter = [[FBEditUserInfoPersenter alloc] init];
    __weak typeof(self)selfWeak = self;
    [_persenter getEditData:^(FBInfoDataModel *fbModel) {
        selfWeak.fbDataModel = fbModel;
    }];
    [self.tableView reloadData];
}

- (IBAction)didNextPageAction:(UIButton *)sender {
    if (!self.fbDataModel) {
        static NSInteger index = 0;
        [self.view showError:@"獲取分類數據出錯，請再試一次"];
        if (index > 0) {
            __weak typeof(self)selfWeak = self;
            [_persenter getEditData:^(FBInfoDataModel *fbModel) {
                selfWeak.fbDataModel = fbModel;
            }];
        }
        index ++;
        return;
    }
    
    NSInteger child = [self.dictCommit[@"child"] integerValue];
    for (int i=0; i < child; i++) {
        NSString *childKey = [NSString stringWithFormat:@"child%zd",i+1];
        NSString *valueYearMonth = [NSString stringWithFormat:@"child_year_month%zd",i+1];
        NSString *valueGender = [NSString stringWithFormat:@"child_gender%zd",i+1];
        NSString *valueSchool = [NSString stringWithFormat:@"school%zd",i+1];
        self.dictCommit[childKey] = [NSString stringWithFormat:@"%@-%@-%@",self.dictCommit[valueYearMonth],self.dictCommit[valueGender],self.dictCommit[valueSchool]];
    }
    
    NSLog(@"dictCommit = %@",self.dictCommit);
    
    FBSelectItemViewController *selectItemVC = [[FBSelectItemViewController alloc] initWithNibName:@"FBSelectItemViewController" bundle:nil];
    selectItemVC.dicCommit = self.dictCommit;
    selectItemVC.category = self.fbDataModel.category;
    [self.navigationController pushViewController:selectItemVC animated:YES];
    
}

- (void)mTouchBackBarButton {
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
}

- (void)didSelectFBItemAction:(EXButton *)btn{
    [_vTempTextField resignFirstResponder];
    _tempPickComponent = 0;
    _tempButton = btn;
    
    if ([btn.text isEqualToString:@"gender"]) {
        [self.pickerData setArray:self.fbDataModel.gender];
    } else if ([btn.text isEqualToString:@"age"]){
         [self.pickerData setArray:self.fbDataModel.age];
    } else if ([btn.text isEqualToString:@"family"]){
        [self.pickerData setArray:self.fbDataModel.family];
    } else if ([btn.text isEqualToString:@"pregnancy"]){
         [self.pickerData setArray:self.fbDataModel.pregnancy];
    } else if ([btn.text isEqualToString:@"birthday"]){
        [self.pickerData removeAllObjects];
        _tempPickComponent = 100;
    } else if ([btn.text isEqualToString:@"child"]){
        _tempPickComponent = 200;
        [self.pickerData setArray:self.fbDataModel.child];
    } else if ([btn.text hasPrefix:@"child_year_month"]){
        _tempPickComponent = 300;
        [self.pickerData removeAllObjects];
    } else if ([btn.text hasPrefix:@"child_gender"]) {
        [self.pickerData setArray:self.fbDataModel.childitem_gender];
    } else if ([btn.text hasPrefix:@"school"]) {
        [self.pickerData setArray:self.fbDataModel.childitem_school];
    } else if ([btn.text isEqualToString:@"income"]){
        [self.pickerData setArray:self.fbDataModel.income];
    }
    
    
    
    [_pickerView reloadAllComponents];
    [_pickerView selectRow:0 inComponent:0 animated:YES];
    
    [self showPickView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && _pageType == PageTypeWithFacebookRegister) {
        UINib *cellNib = [UINib nibWithNibName:@"FBTextFieldTableViewCell" bundle:nil];
        [_tableView registerNib:cellNib forCellReuseIdentifier:@"textCell"];
        FBTextFieldTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor EKColorBackground];
        cell.vTitleLabel.text = self.datasource[indexPath.row];
        _vTempTextField =  cell.vTextField;
        return cell;
    } else {
        NSInteger notesRow = _pageType == PageTypeWithFacebookRegister ? indexPath.row : indexPath.row + 1;
        NSInteger endCount = _pageType == PageTypeWithFacebookRegister ? _datasource.count : _datasource.count + 1;
        id object = self.datasource[indexPath.row];
        if ([object isKindOfClass:[NSArray class]]) {
            UINib *cellNib = [UINib nibWithNibName:@"FBTowBtnTableViewCell" bundle:nil];
            [_tableView registerNib:cellNib forCellReuseIdentifier:@"towBtnCell"];
            FBTowBtnTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"towBtnCell" forIndexPath:indexPath];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.selectBtn addTarget:self action:@selector(didSelectFBItemAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.selectBtn2 addTarget:self action:@selector(didSelectFBItemAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell loadTitleArray:self.datasource[indexPath.row] info:self.dictEdit row:notesRow];
            return cell;
        } else {
            UINib *cellNib = [UINib nibWithNibName:@"FBOneBtnTableViewCell" bundle:nil];
            [_tableView registerNib:cellNib forCellReuseIdentifier:@"oneBtnCell"];
            FBOneBtnTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"oneBtnCell" forIndexPath:indexPath];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.selectBtn addTarget:self action:@selector(didSelectFBItemAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell loadTitle:self.datasource[indexPath.row] info:self.dictEdit row:notesRow allCount:endCount];
            return cell;
        }
    }
    
}



#pragma  mark PickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_tempPickComponent == 100 || _tempPickComponent == 300) {
        return 2;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (_tempPickComponent == 100) {
        if (component == 0) {
            return self.fbDataModel.birthday_year.count;
        } else {
            return self.fbDataModel.birthday_month.count;
        }
    } else if (_tempPickComponent == 300) {
        if (component == 0) {
            return self.fbDataModel.childitem_year.count;
        } else {
            return self.fbDataModel.childitem_month.count;
        }
    }
    return _pickerData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_tempPickComponent == 100) {
        if (component == 0) {
            return self.fbDataModel.birthday_year[row].text;
        } else {
            return self.fbDataModel.birthday_month[row].text;
        }
    } else if (_tempPickComponent == 300){
        if (component == 0) {
            return self.fbDataModel.childitem_year[row].text;
        } else {
            return self.fbDataModel.childitem_month[row].text;
        }
    }
    FBItemModel *model = self.pickerData[row];
    return model.text;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_tempPickComponent == 100 || _tempPickComponent == 300) {
        if (component == 0) {
            _pickRow = row;
        } else {
            if (_tempPickComponent == 100) {
                _pickTitle = [NSString stringWithFormat:@"%@-%@",self.fbDataModel.birthday_year[_pickRow].value,self.fbDataModel.birthday_month[row].value];
            } else {
                _pickTitle = [NSString stringWithFormat:@"%@-%@",self.fbDataModel.childitem_year[_pickRow].value,self.fbDataModel.childitem_month[row].value];
            }
            
            [_tempButton setTitle:_pickTitle forState:UIControlStateNormal];
            
            NSLog(@"_pickTitle = %@",_pickTitle);
        }
        return;
    }
    _tempFbItemModel = self.pickerData[row];
    NSLog(@"model.text = %@,value = %@",_tempFbItemModel.text,_tempFbItemModel.value);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancelPickerView:(UIButton *)sender {
    [self didHiddenPickerView];
}

- (IBAction)selectFinishAction:(UIButton *)sender {
    [self didHiddenPickerView];
    
    if (_tempPickComponent == 100 || _tempPickComponent == 300) {
        //预产期年月/子女信息
        [_tempButton setTitle:_pickTitle forState:UIControlStateNormal];
        self.dictEdit[_tempButton.text] = _pickTitle;
        self.dictCommit[_tempButton.text] = _pickTitle;
        return;
    }
    
    [_tempButton setTitle:_tempFbItemModel.text forState:UIControlStateNormal];
    self.dictEdit[_tempButton.text] = _tempFbItemModel.text;
    self.dictCommit[_tempButton.text] = _tempFbItemModel.value;
    
    if (_tempPickComponent == 200) {
        [self addItemView:_tempFbItemModel.value.integerValue];
    }
    
}


- (void)showPickView{
    CGRect rect = self.pickerViewBg.frame;
    rect.origin.x = 0;
    rect.origin.y = SCREEN_HEIGHT;
    rect.size.width = SCREEN_WIDTH;
    self.pickerViewBg.frame = rect;
    if (!_pickerViewBg.superview) {
        [self.view addSubview:_pickerViewBg];
        [self.view bringSubviewToFront:_pickerViewBg];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.pickerViewBg.frame;
        frame.origin.y = SCREEN_HEIGHT - self.pickerViewBg.frame.size.height;
        self.pickerViewBg.frame = frame;
    }];
    
}

- (void)didHiddenPickerView
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.pickerViewBg.frame;
        rect.origin.y = SCREEN_HEIGHT;
        self.pickerViewBg.frame = rect;
        
        
    } completion:^(BOOL finished) {
        [self.pickerViewBg removeFromSuperview];
    }];
    
}


- (void)setPickerViewFrame
{
    if (_pickerView) {
        return;
    }
    /**
     *  设置pickViewBg 的frame适应屏幕尺寸
     */
    self.pickerViewBg.backgroundColor = [UIColor EKColorBackground];
    CGRect rect = self.pickerViewBg.frame;
    rect.size.width = SCREEN_WIDTH;
    self.pickerViewBg.frame = rect;
    
    UIView *pickerView = (UIView *)[self.pickerViewBg viewWithTag:10];
    for (UIView *label in pickerView.subviews) {
        label.backgroundColor = [UIColor EKColorNavigation];
    }

}


- (NSMutableArray *)pickerData{
    if (!_pickerData) {
        _pickerData = [NSMutableArray array];
    }
    return _pickerData;
}

- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (NSArray *)textIndex:(NSInteger)value{
    NSString *textValue = nil;
    switch (value) {
        case 1:
            textValue = @"第一子女出生月年";
            break;
        case 2:
            textValue = @"第二子女出生月年";
            break;
        case 3:
            textValue = @"第三子女出生月年";
            break;
        case 4:
            textValue = @"第四子女出生月年";
            break;
        default:
            break;
    }
    return @[textValue, @"性別"];
}


- (void)addItemView:(NSInteger)value{
    //重新设置数据源
    [self.datasource setArray:[self getNormal]];
    
    for (int i= 1 ;i <= value; i++) {
        if (i == 1) {
            [self.datasource removeLastObject];
        }
        
        [self.datasource addObject:[self textIndex:i]];
        [self.datasource addObject:@"上學地區 (如適用)"];
        
        if (i == value) {
            [self.datasource addObject:@"家庭每月總收入"];
        }
    }
    
    [self.tableView reloadData];
}


- (NSArray *)getNormal{
    //如果是普通注册页面过来，不显示手提电话选项
    if (_pageType == PageTypeWithRegister) {
        return @[@[@"稱謂",@"年齡"],
                 @"家庭身份",
                 @"懷孕狀況",
                 @"預產期 (如適用)",
                 @"已出生子女人數",
                 @"家庭每月總收入",
                 ];
    } else {
        return @[@"手提電話",
                 @[@"稱謂",@"年齡"],
                 @"家庭身份",
                 @"懷孕狀況",
                 @"預產期 (如適用)",
                 @"已出生子女人數",
                 @"家庭每月總收入",
                 ];
    }
}
- (NSMutableDictionary *)dictEdit{
    if (!_dictEdit) {
        _dictEdit = [NSMutableDictionary dictionary];
        [_dictEdit setDictionary:@{@"mobile":@"",
                                   @"gender":@"",
                                   @"age":@"",
                                   @"family":@"",
                                   @"pregnancy":@"",
                                   @"birthday":@"",
                                   @"child":@"",
                                   @"child1":@"",
                                   @"child2":@"",
                                   @"child3":@"",
                                   @"child4":@"",
                                   @"income":@"",
                                   @"category":@"",
                                   }];
    }
    return _dictEdit;
}
- (NSMutableDictionary *)dictCommit{
    if (!_dictCommit) {
         _dictCommit = [NSMutableDictionary dictionary];
    }
    return _dictCommit;
}
@end
