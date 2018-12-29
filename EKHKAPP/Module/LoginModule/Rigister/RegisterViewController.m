/**
 - BKMobile
 - RegisterViewController.h
 - Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
 - Created by Guibin on 15/10/21.
 - 说明：注册页面
 */
#import "RegisterViewController.h"
#import "RegisterTextField.h"
#import "TreatyViewController.h"
#import "FBConfirmViewController.h"
#import "FBEditInfoViewController.h"

@interface RegisterViewController () <
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate,
UIPickerViewDataSource,
UIPickerViewDelegate,
UIAlertViewDelegate>
{
    IBOutlet UIView        *_pickerViewBg;
    IBOutlet UIView        *_datePickerBg;
    IBOutlet UIView        *_footView;
    __weak IBOutlet UITableView   *_tableView;
    __weak IBOutlet UIPickerView  *_pickerView;
    __weak IBOutlet UIDatePicker  *_datePicker;
    __weak IBOutlet UIButton      *_commitButton;
    RegisterTextField             *_regTextField;
    NSArray         *_textArray;
    NSMutableArray  *_pickerData;
    NSIndexPath     *_indexPath;
    NSString        *_pickTitle;
    NSInteger       _pickRow;
    NSInteger       _cityIndex;
}
//保存填写的数据
@property (nonatomic , strong) NSMutableDictionary *dicData;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//初始化UI
- (void)mInitUI {
    self.title = @"註冊";
    self.view.backgroundColor = [UIColor EKColorBackground];
    _tableView.backgroundColor = [UIColor EKColorBackground];
    _footView.backgroundColor = [UIColor EKColorBackground];
    [_commitButton updataBtnBackground];
}

//初始化数据
- (void)mInitData {
    _pickerData = [[NSMutableArray alloc] initWithCapacity:0];
    _pickRow = 0;
    _textArray = @[@"用戶名*",@"郵箱*",@"流動電話*",@"密碼*",@"確認密碼*",@"性別",@"懷孕狀況",@"預產期/已有最小寶寶出生日",@"請選擇小孩級別*",@"居住地區",@"家庭收入"];
    [self setTabView];
    [self setPickerViewFrame];
    [self setDatePickerData];
}

#pragma mark - UITablieViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _textArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *defineCell = @"registerCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:defineCell forIndexPath:indexPath];
    [self reloadViewCell:cell cellForRowAtIndexPath:indexPath];
    return cell;
}

- (void)reloadViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    UILabel *typeLab = (UILabel *)[cell.contentView viewWithTag:5];
    typeLab.text = _textArray[indexPath.row];
    
    RegisterTextField *textF = (RegisterTextField *)[cell.contentView viewWithTag:120];
    textF.uTag = indexPath.row;
    textF.delegate = self;
    
    if (indexPath.row > 4) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        textF.enabled = NO;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        textF.enabled = YES;
        if (indexPath.row > 2) {
            textF.secureTextEntry = YES;
        }
    }

    switch (indexPath.row) {
        case 0: {
            textF.text = self.dicData[@"username"];
            break;
        }
        case 1: {
            textF.text = self.dicData[@"email"];
            textF.placeholder = @"請填寫真實的郵箱以便驗證";
            break;
        }
        case 2: {
            textF.text = self.dicData[@"mobile"];
            textF.placeholder = @"請填寫真實的電話以便驗證";
            break;
        }
        case 3: {
            textF.text = self.dicData[@"password"];
            break;
        }
        case 4: {
            textF.text = self.dicData[@"password2"];
            break;
        }
        case 5: {
            if ([self.dicData[@"gender"] integerValue] == 1 ) {
                textF.text = @"男";
            }else if ([self.dicData[@"gender"] integerValue] == 2){
                textF.text =  @"女";
            }
            break;
        }
        case 6: {
            textF.text = self.dicData[@"pregnancy"];
            break;
        }
        case 7: {
            textF.text = self.dicData[@"prebabydata"];
            break;
        }
        case 8: {
            textF.text = self.dicData[@"childlevel"];
            break;
        }
        case 9: {
            textF.text = self.dicData[@"livearea"];
            break;
        }
        case 10: {
            textF.text = self.dicData[@"income"];
            break;
        }
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_regTextField isFirstResponder]) {
        [_regTextField resignFirstResponder];
    }
    [self hiddenPickerView];
    NSInteger row = indexPath.row;
    row -= 1;
    if (row > 3) {
        NSArray *arrData = nil;
        _cityIndex = 1;
        
        switch (row) {
            case 4: {
                arrData = @[@"男",@"女"];
                break;
            }
            case 5: {
                arrData = @[@"無懷孕打算",@"準備懷孕",@"懷孕中",@"已有寶寶1位",@"已有寶寶2位或以上"];
                break;
            }
            case 6: {
                if ([self.dicData[@"pregnancy"] isEqualToString:@"無懷孕打算"]) {
                    //如果怀孕状况选择的是无怀孕打算，那么生日日期不可以已点击
                }else{
                    _datePickerBg.tag = 0xffff;
                    [self showDatePickerView];
                }
                break;
            }
            case 7: {
                arrData = @[@"3-5 幼稚園", @"6-8 初小", @"9-12 高小", @"12-15 初中", @"16-18高中", @"18+ 大學", @"國際學校"];
                break;
            }
            case 8: {
                _cityIndex = 2;
                //區域
                arrData = @[
                            @{@"title":@"香港島",
                              @"data":@[@"中西區",@"灣仔區",@"東區",@"南區"]
                              },
                            @{@"title":@"九龍",
                              @"data":@[@"油尖旺區",@"深水埗區",@"九龍城區",@"黃大仙區"]
                              },
                            @{@"title":@"新界及離島",
                              @"data":@[@"屯門區",@"元朗區",@"大埔區",@"西貢區",@"沙田區",@"離島區",@"北區",@"荃灣區",@"葵青區"]
                              },
                            @{@"title":@"其他",
                              @"data":@[@"其他"]
                              }
                            ];
                break;
            }
            case 9: {
                arrData = @[@"少於HK$20,000",@"HK$20,001-HK$40,000",@"多於HK$400,001"];
                break;
            }
            default:
                break;
        }
        
        if (arrData.count) {
            [_pickerData setArray:arrData];
            [self showPickView];
            [_pickerView reloadAllComponents];
            
            if (_cityIndex == 2) {
                //[_pickerView selectRow:0 inComponent:0 animated:YES];
                [_pickerView selectRow:0 inComponent:1 animated:YES];
                _pickTitle = _pickerData[0][@"data"][0];
            }else{
                 [_pickerView selectRow:0 inComponent:0 animated:YES];
                _pickTitle = _pickerData[0];
            }
           
            [_pickerView setTintColor:[UIColor redColor]];
            _datePickerBg.tag = 999;
            _pickerViewBg.tag = indexPath.row;
        }
    }
}

#pragma mark - 提交注册
- (IBAction)selectFinishAction:(UIButton *)sender {
    if ([self isEditUserInfo]) {
        [self.view showHUDActivityView:@"正在提交..." shade:NO];
        [EKHttpUtil mHttpWithUrl:kRegisterURL parameter:_dicData response:^(BKNetworkModel *model, NSString *netErr) {
            [self.view removeHUDActivity];
            if (netErr) {
                [self.view showHUDTitleView:netErr image:nil];
            } else {
                [self.view showHUDTitleView:model.message image:nil];
                if (model.status == 1) {
                    
                    //注意：这里注册成功，会返回token，用该token去调资料完善，是临时token
                    NSString *tokenStr = model.data;
                    _dicData[@"tempToken"] = tokenStr;
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    if (_pushHomePageVC) {
                        _pushHomePageVC(_dicData);
                    }
                } else {
                    
                }
            }
        }];
    }
}

#pragma mark - 是否同意服务条款
- (IBAction)selectAgreeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.dicData[@"agreebbrule"] = @(sender.selected);
}

#pragma mark - 查看服务条款
- (IBAction)selectSeeClauseAction:(UIButton *)sender {
    [EKWebViewController showWebViewWithTitle:@"隱私條例" forURL:kUserPrivacyURL from:self];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(RegisterTextField *)textField {
    _regTextField = textField;
    [self hiddenPickerView];
}

- (void)textFieldDidEndEditing:(RegisterTextField *)textField {
    NSInteger tag = textField.uTag;
    switch (tag) {
        case 0:  self.dicData[@"username"]  = textField.text;  break;
        case 1:  self.dicData[@"email"]     = textField.text;  break;
        case 2:  self.dicData[@"mobile"]    = textField.text;  break;
        case 3:  self.dicData[@"password"]  = textField.text;  break;
        case 4:  self.dicData[@"password2"] = textField.text;  break;
        default: break;
    }
}

- (BOOL)textFieldShouldReturn:(RegisterTextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 日期选择器
- (IBAction)didSelectDatePickerAction:(UIDatePicker *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [formatter stringFromDate:sender.date];
    self.dicData[@"prebabydata"] = strDate;
    self.dicData[@"birthday"] = strDate;// 预产期\宝宝生日(birthday) 区别香港字段变化
}

#pragma mark - 普通的PickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _cityIndex;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_cityIndex == 2) {
        if (component == 0) {
            return _pickerData.count;
        }
        return [[self selectPickRow] count];
    }
    return _pickerData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_cityIndex == 2) {
        if (component == 0) {
            return _pickerData[row][@"title"];
        }
        return [self selectPickRow][row];
    }
    return [NSString stringWithFormat:@"%@",_pickerData[row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_cityIndex == 2) {
        if (component == 0) {
            _pickRow = row;
            [pickerView reloadComponent:1];
            _pickTitle = _pickerData[row][@"data"][0];
        }else{
            _pickTitle = _pickerData[_pickRow][@"data"][row];
        }
        return;
    }
    _pickTitle = _pickerData[row];
}

#pragma mark - Picker按钮：取消
- (IBAction)didSelectCancelAction:(UIButton *)sender {
    if (_datePickerBg.tag == 0xffff) {
        [self didHiddenDatePickerView];
    }else{
        [self didHiddenPickerView];
    }
}

#pragma mark - Picker按钮：完成并保存
- (IBAction)didSelectFinishAction:(UIButton *)sender {
    if (_datePickerBg.tag == 0xffff) {
        [self didSelectDatePickerAction:_datePicker];
         [self didHiddenDatePickerView];
    } else {
        if ([_pickTitle isEqualToString:@"男"]) {
            _pickTitle = @"1";
        }else if ([_pickTitle isEqualToString:@"女"]){
            _pickTitle = @"2";
        }
        NSInteger tag = _pickerViewBg.tag;
        tag -= 1;
        switch (tag) {
            case 4:  self.dicData[@"gender"]      = _pickTitle;  break;
            case 5:  self.dicData[@"pregnancy"]   = _pickTitle;  break;
            case 6:  self.dicData[@"prebabydata"] = _pickTitle;  break;
            case 7:  self.dicData[@"childlevel"]  = _pickTitle;  break;
            case 8:  self.dicData[@"livearea"]    = _pickTitle;  break;
            case 9:  self.dicData[@"income"]      = _pickTitle;  break;
            default:
                break;
        }
        
        if ([self.dicData[@"pregnancy"] isEqualToString:@"無懷孕打算"]) {
            //如果怀孕状况选择的是无怀孕打算，设置生日为空
            self.dicData[@"prebabydata"] = @"";
            self.dicData[@"birthday"] = @"";
        }
        
        [self didHiddenPickerView];
    }
    [_tableView reloadData];
}

#pragma mark - 初始化设置
- (NSMutableDictionary *)dicData {
    if (!_dicData) {
        _dicData = [NSMutableDictionary dictionary];
    }
    return _dicData;
}

//设置pickView
- (void)setPickerViewFrame {
    
    //设置普通的pickView
    CGRect rect = _pickerViewBg.frame;
    rect.size.width = SCREEN_WIDTH;
    _pickerViewBg.frame = rect;
    UIView *pickerView = (UIView *)[_pickerViewBg viewWithTag:10];
    for (UIView *label in pickerView.subviews) {
        label.backgroundColor = [UIColor EKColorNavigation];
    }
    
    //设置datePicker
    rect = _datePickerBg.frame;
    rect.size.width = SCREEN_WIDTH;
    _datePickerBg.frame = rect;
    UIView *datePickView = (UIView *)[_datePickerBg viewWithTag:20];
    for (UIView *label in datePickView.subviews) {
        label.backgroundColor = [UIColor EKColorNavigation];
    }
}

- (void)setDatePickerData {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *minDate = [formatter dateFromString:@"1997-01-01"];
    
    //多算一年，因为有个预产期的时间
    NSString *maxStr = [formatter stringFromDate:[NSDate date]];
    NSInteger maxIndex = [[maxStr substringToIndex:4] integerValue];
    maxStr = [maxStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%ld",(long)maxIndex] withString:[NSString stringWithFormat:@"%ld",(long)(maxIndex +1)]];
    
    NSDate *maxDate = [formatter dateFromString:maxStr];
    _datePicker.minimumDate = minDate;
    _datePicker.maximumDate = maxDate;
    _datePicker.datePickerMode = UIDatePickerModeDate;
}

- (void)setTabView {
    UINib *cell = [UINib nibWithNibName:@"RegisterViewCell" bundle:nil];
    [_tableView registerNib:cell forCellReuseIdentifier:@"registerCell"];
    
    UIButton *btnClause = (UIButton *)[_footView viewWithTag:10];
    [btnClause setTitleColor:[UIColor EKColorNavigation] forState:UIControlStateNormal];
    
    UIButton *btnRegist = (UIButton *)[_footView viewWithTag:20];
    UIImage *image = [[UIImage imageNamed:@"def_iv_My_bj"] stretchableImageWithLeftCapWidth:2 topCapHeight:4];
    [btnRegist setBackgroundImage:image forState:UIControlStateNormal];
    
    _tableView.tableFooterView = _footView;
    
    UILabel *labLine = (UILabel *)[_footView viewWithTag:66];
    labLine.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_table_line"]];
    
}

#pragma mark - 其他逻辑处理
- (NSArray *)selectPickRow {
    return _pickerData[_pickRow][@"data"];
}

- (BOOL)isEditUserInfo {
    if ([_regTextField isFirstResponder]) {
        [_regTextField resignFirstResponder];
    }
    UIButton *btnSel = (UIButton *)[_footView viewWithTag:521];
    
    if ([BKTool isStringBlank:self.dicData[@"username"]]) {
        [self.view showHUDTitleView:@"請填寫用戶名" image:nil];
        return NO;
    } else if ([BKTool isStringBlank:self.dicData[@"email"]]) {
        [self.view showHUDTitleView:@"請填寫您的郵箱" image:nil];
        return NO;
    } else if ([BKTool isStringBlank:self.dicData[@"password"]]) {
        [self.view showHUDTitleView:@"請設置您的密碼" image:nil];
        return NO;
    } else if (![self.dicData[@"password"] isEqualToString:self.dicData[@"password2"]]) {
        [self.view showHUDTitleView:@"您兩次輸入的密碼不一致，請重新輸入" image:nil];
        return NO;
    } else if ([BKTool isStringBlank:self.dicData[@"childlevel"]]) {
        [self.view showHUDTitleView:@"請選擇小孩級別" image:nil];
        return NO;
    } else if (!btnSel.isSelected) {
        [self.view showHUDTitleView:@"請先同意條款" image:nil];
        return NO;
    }

    if ([BKTool isStringBlank:self.dicData[@"mobile"]]) {
        [self.view showHUDTitleView:@"請填寫您的電話" image:nil];
        return NO;
    }
    return YES;
}

- (void)showPickView {
    CGRect rect = _pickerViewBg.frame;
    rect.origin.x = 0;
    rect.origin.y = SCREEN_HEIGHT;
    _pickerViewBg.frame = rect;
    if (!_pickerViewBg.superview) {
        [self.view addSubview:_pickerViewBg];
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _pickerViewBg.frame;
        frame.origin.y = SCREEN_HEIGHT - _pickerViewBg.frame.size.height;
        _pickerViewBg.frame = frame;
    }];
}

- (void)didHiddenPickerView {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _pickerViewBg.frame;
        rect.origin.y = SCREEN_HEIGHT;
        _pickerViewBg.frame = rect;
    } completion:^(BOOL finished) {
        [_pickerViewBg removeFromSuperview];
    }];
}

- (void)showDatePickerView {
    CGRect rect = _datePickerBg.frame;
    rect.origin.x = 0;
    rect.origin.y = SCREEN_HEIGHT;
    _datePickerBg.frame = rect;
    if (!_datePickerBg.superview) {
        [self.view addSubview:_datePickerBg];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _datePickerBg.frame;
        frame.origin.y = SCREEN_HEIGHT - _datePickerBg.frame.size.height;
        _datePickerBg.frame = frame;
    }];
}

- (void)didHiddenDatePickerView {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _datePickerBg.frame;
        rect.origin.y = SCREEN_HEIGHT;
        _datePickerBg.frame = rect;
    } completion:^(BOOL finished) {
        [_datePickerBg removeFromSuperview];
    }];
}

- (void)hiddenPickerView {
    if (_datePickerBg.superview) {
        [_datePickerBg removeFromSuperview];
    } else if (_pickerViewBg.superview) {
        [_pickerViewBg removeFromSuperview];
    }
}

@end
