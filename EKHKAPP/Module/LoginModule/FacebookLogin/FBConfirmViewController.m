//
//  FBConfirmViewController.m
//  BKMobile
//
//  Created by ligb on 2017/7/24.
//  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "FBConfirmViewController.h"
#import "FBEditUserInfoPersenter.h"
@interface FBConfirmViewController ()<UIAlertViewDelegate>
{
    __weak IBOutlet UIImageView *_imageHeadView;
    __weak IBOutlet UILabel  *_userName;
    __weak IBOutlet UILabel  *_emailLab;
    
    __weak IBOutlet UILabel *_detailLab;
    __weak IBOutlet UILabel *_detail2Lab;
    
    __weak IBOutlet UIButton *_confirmBtn;
    __weak IBOutlet UIButton *_cancelBtn;
    
}


@end

@implementation FBConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_confirmBtn updataBtnBackground];
    
    [_cancelBtn setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(204, 204, 204)] forState:UIControlStateNormal];
    _cancelBtn.layer.masksToBounds = YES;
    _cancelBtn.layer.cornerRadius = 4;

    if (IPHONE5) {
        UILabel *labTextDetail = [self.view viewWithTag:10];
        labTextDetail.font = [UIFont systemFontOfSize:14];
        UILabel *labTextDetailEnd = [self.view viewWithTag:11];
        labTextDetailEnd.font = [UIFont systemFontOfSize:14];
    }
    
    [self loadNewView];
}

- (void)loadNewView{
    if (self.pageType == FB_Link_Account) {
         self.navigationItem.title = @"連結帳戶";
        _emailLab.text = [NSString stringWithFormat:@"電郵地址：%@",_info[@"email"]];
    } else {
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.title = @"會員資料";
        _emailLab.text = @"恭喜！您已成功啟動教育王國帳戶";
        _emailLab.textColor = [UIColor redColor];
        
        _detailLab.text = @"請繼續填寫資料";
        _detail2Lab.text = @"親子王國KMall將為你送上貼心小心意";
        [_confirmBtn setTitle:@"繼續填寫資料" forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"暫時不需要" forState:UIControlStateNormal];
    }
    
    NSURL *imgURL = [NSURL URLWithString:_info[@"picture"][@"data"][@"url"]];
    [_imageHeadView sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"mrtx_pic"]];
    _userName.text = self.name.length ? self.name : _info[@"name"];
}

- (void)setInfo:(NSDictionary *)info{
    _info = info;
}

- (IBAction)selectActionType:(UIButton *)sender {
    if (self.pageType == FB_Link_Account) {
        if ([sender.titleLabel.text isEqualToString:@"取消"]) {
            [[[UIAlertView alloc] initWithTitle:nil message:@"不連接Facebook將不能完成登錄" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定不連接", nil] show];
            return;
        } else {
            [self.navigationController popViewControllerAnimated:YES];
            if (_pushHomePageVC) {
                _pushHomePageVC(1);
            }
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        if ([sender.titleLabel.text hasSuffix:@"不需要"]) {
            if (_pushHomePageVC) {
                [self.view showHUDActivityView:nil shade:YES];
                FBEditUserInfoPersenter *persenter = [[FBEditUserInfoPersenter alloc] init];
                [persenter commitFBEditInfo:nil block:^(BKNetworkModel *model, NSString *message) {
                    [self.view removeHUDActivity];
                    if (message) {
                        [self.view showHUDTitleView:message image:nil];
                    } else{
                        if (model.status ==1) {
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
                        } else {
                            [self.view showHUDTitleView:model.message image:nil];
                        }
                    }
                }];
            }
        } else {
            //進入完善資料頁面
            if (_pushHomePageVC) {
                _pushHomePageVC(1);
            }
        }
    }
    
}

- (void)mTouchBackBarButton{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        [self mTouchBackBarButton];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
