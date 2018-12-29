/**
 -  FBStartViewController.m
 -  BKMobile
 -  Created by ligb on 2017/8/8.
 -  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
 */

#import "FBStartViewController.h"
#import "FacebookVerifyModel.h"
#import "FBConfirmViewController.h"
#import "TreatyViewController.h"


@interface FBStartViewController ()<UITextFieldDelegate>
{
    UITextField     *_vTempFiled;
}
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *vStartButton;

@property (weak, nonatomic) IBOutlet UIButton *vStateButton;
@property (weak, nonatomic) IBOutlet UIButton *vStateButton2;
@property (weak, nonatomic) IBOutlet UIButton *vStateButton3;

@property (nonatomic, strong) NSMutableDictionary *vDicData;
@end

@implementation FBStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self backBtn];
    
    self.navigationItem.title = @"啟動帳戶";
}

- (void)mInitData{
     [self.dataSource setArray:@[@"用戶名",@"電郵地址",@"密碼",@"確認密碼"]];

    NSDictionary *tempDic = self.infoData[@"fbInfo"];
    self.vDicData[@"username"] = tempDic[@"name"];
    self.vDicData[@"email"] = tempDic[@"email"];
    self.vDicData[@"fbtoken"] = self.infoData[@"fbtoken"];
    self.vDicData[@"agreebbrule"] = @YES;
    self.vDicData[@"newsletter"]  = @YES;
    self.vDicData[@"abbott"]      = @YES;
    
    [self.tableView reloadData];
}


- (void)mInitUI{
    _footerView.backgroundColor = [UIColor EKColorBackground];
    [_vStartButton updataBtnBackground];
    self.tableView.tableFooterView = _footerView;
    self.tableView.scrollEnabled = NO;
    
}

- (BOOL)isEditUserInfoData{
    if ([BKTool isStringBlank:self.vDicData[@"username"]]) {
        [self.view showHUDTitleView:@"請填寫用戶名" image:nil];
        return NO;
    }else if (!self.vStateButton.isSelected) {
        [self.view showHUDTitleView:@"請選擇同意協議" image:nil];
        return NO;
    } else if (![self.vDicData[@"password"] isEqualToString:self.vDicData[@"password2"]]) {
        [self.view showHUDTitleView:@"您兩次輸入的密碼不一致，請重新輸入" image:nil];
        return NO;
    }
    return YES;
}

//选择启动
- (IBAction)startFacebookAction:(UIButton *)sender {
    [_vTempFiled resignFirstResponder];
    [self.view showHUDActivityView:@"正在加載..." shade:NO];
    if ([self isEditUserInfoData]) {
        [FacebookVerifyModel facebookRegister:self.vDicData back:^(BKNetworkModel *fbmodel, NSString *error) {
            [self.view removeHUDActivity];
            if (error) {
                [self.view showHUDTitleView:error image:nil];
            } else {
                if (fbmodel.status == 1) {
                    [self mTouchBackBarButton];
                    
                    //返回登錄頁面，并完善資料
                    if (_pushHomePageVC) {
                        _pushHomePageVC(self.vDicData[@"username"]);
                    }
                } else {
                    [self.view showHUDTitleView:fbmodel.message image:nil];
                }
            }
        }];
    }
    
}

//查看协议
- (IBAction)protocolAction:(UIButton *)sender {
    NSLog(@"sender.tag = %zd",sender.tag);
   
    if (sender.tag == 10) {
        [EKWebViewController showWebViewWithTitle:@"服務條款" forURL:kUserPrivacyURL from:self];
        return;
    }
    
    TreatyViewController *treatyVC = [[TreatyViewController alloc] initWithNibName:@"TreatyViewController" bundle:nil];
    if (sender.tag == 11){
        treatyVC.navigationItem.title = @"教育王國資訊協議條款";
        treatyVC.vTreatyText = @"       本人明白及同意教育王國及其合作伙伴可因提供最新資訊、服務與宣傳活動的相關消息，而使用本人在紀錄中的個人資料，姓 名、 電郵地址及/或電話號碼。教育王國將以電子郵件、發送短訊/多媒體 短訊/WAP/APP Push、直接郵 寄，及/或至電本人之手機或固網電話聯絡本人。教育王國將可能提供以 下，或不只限於以下各類產品、設施或服務：消費品及服務、娛樂／康樂、金融、銀行及信用卡、網上拍賣、生活資訊、團購、購物、交易及付款平台、零售、電訊、運輸及旅遊";
    } else{
        treatyVC.navigationItem.title = @"協議條款";
        treatyVC.vTreatyText = @"       本人願意經由申請帳戶時提交之電郵及電話號碼，收取由「達能紐迪希亞生命早期營養品(香港)有限公司」的直接促銷資訊(即有關懷孕及育兒的資訊、產品及服務、會員活動及市場調查)。";
    }
    
    [self.navigationController pushViewController:treatyVC animated:YES];
}

//选择同意
- (IBAction)selectAgreeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.tag == 521) {
        self.vDicData[@"agreebbrule"] = @(sender.isSelected);
    } else if (sender.tag == 522) {
        self.vDicData[@"newsletter"]  = @(sender.isSelected);
    } else {
        self.vDicData[@"abbott"]      = @(sender.isSelected);
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellDefine = @"cellDefile";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellDefine];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellDefine];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITextField *textField  = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 250, 0, 240, 44)];
        textField.delegate = self;
        textField.tag = indexPath.row;
        textField.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:textField];
        
        switch (indexPath.row) {
            case 0:{
                textField.text = self.vDicData[@"username"];
            }
                break;
            case 1:{
                textField.enabled = NO;
                textField.text = self.vDicData[@"email"];
            }
                break;
            case 2:{
                textField.secureTextEntry = YES;
                textField.text = self.vDicData[@"password"];
            }
                break;
            case 3:{
                textField.secureTextEntry = YES;
                textField.text = self.vDicData[@"password2"];
            }
                break;
                
            default:
                break;
        }
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [UIView new];
    headView.backgroundColor = [UIColor EKColorBackground];
    return headView;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _vTempFiled = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger tag = textField.tag;
    switch (tag) {
        case 0:  self.vDicData[@"username"]  = textField.text;  break;
        case 2:  self.vDicData[@"password"]  = textField.text;  break;
        case 3:  self.vDicData[@"password2"] = textField.text;  break;
        default:
            break;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableDictionary *)vDicData{
    if (!_vDicData) {
        _vDicData = [NSMutableDictionary dictionary];
    }
    return _vDicData;
}

@end
