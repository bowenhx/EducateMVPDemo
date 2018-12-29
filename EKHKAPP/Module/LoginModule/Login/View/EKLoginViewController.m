//
//  EKLoginViewController.m
//  EKHKAPP
//
//  Created by ligb on 2017/10/13.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "EKLoginViewController.h"
#import "EKNavigationViewController.h"
#import "EKLoginPresenter.h"
#import "FacebookVerifyModel.h"
#import "EKForgetPasswordViewController.h"
#import "RegisterViewController.h"
#import "FBConfirmViewController.h"
#import "FBEditInfoViewController.h"
#import "FBStartViewController.h"

@interface EKLoginViewController () <EKLoginViewProtocol, FBSDKLoginButtonDelegate, UITextFieldDelegate>

@property (strong, nonatomic) EKLoginPresenter *presenter;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *facebookBtn;
@property (weak, nonatomic) IBOutlet UIView *loginBgView;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAccount;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic, copy) NSString *facebookEditUserName;
@property (nonatomic, copy) NSString *tempToken; //主要记录facebook token，也当做第一次注册完善资料的临时token
@property (nonatomic, copy) NSDictionary *facebookInfo;


@property (nonatomic, copy) NSString *from;
@end

@implementation EKLoginViewController

+ (BOOL)showLoginVC:(UIViewController * _Nonnull )viewController from:(NSString * _Nonnull)from {
    if (LOGINSTATUS) {
        return NO;
    }
    
    EKLoginViewController *loginVC = [[EKLoginViewController alloc] initWithNibName:@"EKLoginViewController" bundle:nil];
    loginVC.from = from;
    loginVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    EKNavigationViewController *nav = [[EKNavigationViewController alloc] initWithRootViewController:loginVC];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
    [viewController presentViewController:nav animated:YES completion:nil];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登錄";
    
    //广告请求
    [self mRequestInterstitialView];
    [self mRequestPopupView:0];
    
    [self updataUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self outFacebookLogin];
}

- (void)updataUI {
    self.view.backgroundColor = [UIColor EKColorBackground];
    _loginBgView.backgroundColor = [UIColor EKColorBackground];
    [self vBackBarButton];
    
    
    [_loginButton updataBtnBackground];
    _facebookBtn.readPermissions = @[@"public_profile", @"email"];//@"user_friends"
    _facebookBtn.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFinishIntoHomeAction) name:kLoginSuccessNotification object:nil];
}



- (IBAction)facebookLoginAction:(FBSDKButton *)sender {

}

- (IBAction)loginAction:(UIButton *)sender {
    [self mResignFirstResponder];
    [self.presenter mLoginWithWithUserName:_textFieldAccount.text password:_textFieldPassword.text];
}

- (IBAction)forgetPasswordAction:(id)sender {
    //跳转到忘记密码界面
    EKForgetPasswordViewController *vc = [[EKForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)registAction:(id)sender {
    //跳转到注册界面
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
    //注册完成后需要去完善资料页面
    registerVC.pushHomePageVC = ^(NSDictionary *info){
        _facebookEditUserName = info[@"username"];
        _tempToken = info[@"tempToken"];
        //跳转到完善用户信息页面，注意： 这里不是再次登陆，而是去完善用户信息，实际上完善后还是未登录状态，需要用户自己去激活邮箱才可以
        [self pushFBConfirmAccountViewController:2];
    };
}

- (void)mTouchBackBarButton {
//    [self removePopupAdView];
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginFinishIntoHomeAction{
    if (_from.length) {
        if ([_from isEqualToString:@"inPage"]) {
            [self mTouchBackBarButton];
        }else if ([_from isEqualToString:@"msgIndex"]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForTabbarChangeSelectIndex object:@3];
            [self mTouchBackBarButton];
        }
    }else{
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

#pragma mark - 点击登录后，实现协议方法
- (void)mLoginResultWithSuccess:(BOOL)isSuccess message:(NSString *)message {
    [self.view showHUDTitleView:message image:nil];
    //登录成功
    if (isSuccess) {
        [self loginFinishIntoHomeAction];
    }
}

#pragma mark - 网络请求前后，显示或隐藏加载框
- (void)mShowHUDActivity {
    [self.view showHUDActivityView:@"正在登錄..." shade:YES];
}

- (void)mHiddenHUDActivity {
    [self.view removeHUDActivity];
}

#pragma mark facebook
- (void)outFacebookLogin {
    FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
    if (token) {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
    }
}

- (NSString *)mobileToken {
    return [BKSaveData getString:kDeviceTokenKey];
}

//这是facebook 登陆逻辑
//1.使用facebook 登陆，拿到fbtoken,去绑定用户资料
//2.根据返回状态来判断具体操作：status = 1 时，model.data有数据是登陆,无数据需要去绑定facebook账号信息
//stats = 2时，需要用户启动账户（即授权），开启后需要再次执行该方法，去做以上对应的操作
- (void)verifyFacebookStatus:(NSDictionary *)reqParameter start:(BOOL)isStrt{
    [self.view showHUDActivityView:@"正在登錄..." shade:YES];
    [FacebookVerifyModel verifyUserInfo:reqParameter back:^(BKNetworkModel *fbmodel, NSString *error) {
        [self.view removeHUDActivity];
        if (error) {
            [self.view showHUDTitleView:error image:nil];
        } else {
            NSDictionary *dict = fbmodel.data;
            if (fbmodel.status == 1) {
                if ([dict isKindOfClass:[NSDictionary class]] && dict.allKeys.count) {
                    if (isStrt) {
                        [self.presenter mSaveUserInfo:dict password:_textFieldPassword.text isHome:NO];
                        //去绑定facebook 账号信息展示会员资料页面
                        [self pushFBConfirmAccountViewController:1];
                    } else {
                        [self.presenter mSaveUserInfo:dict password:_textFieldPassword.text isHome:YES];
                    }
                } else {
                    //去绑定facebook 账号信息展示会员资料页面
                    [self pushFBConfirmAccountViewController:0];
                }
            } else if (fbmodel.status == 2){
                //跳转到启动账户页面
                FBStartViewController *fbStartVC = [[FBStartViewController alloc] initWithNibName:@"FBStartViewController" bundle:nil];
                fbStartVC.infoData = @{@"fbtoken":self.tempToken,@"fbInfo":self.facebookInfo};
                [self.navigationController pushViewController:fbStartVC animated:YES];

                __weak typeof(self)selfWeak = self;
                fbStartVC.pushHomePageVC = ^(NSString *userName) {
                    selfWeak.facebookEditUserName = userName;
                    NSDictionary *parameter = @{
                                                @"fbtoken":self.tempToken,
                                                @"binding":@1,
                                                @"deviceID":[self mobileToken]};
                    [selfWeak verifyFacebookStatus:parameter start:YES];
                };
            } else {
                [self.view showHUDTitleView:fbmodel.message image:nil];
            }
        }
    }];
}


//account:0 需要连接用户，不为0 是完善用户资料
//这里包括facebook 完善资料和普通用户注册后完善资料，普通用户完善资料不需要有电话。其他逻辑正常
- (void)pushFBConfirmAccountViewController:(NSInteger)account{
    //去绑定facebuserDIYook
    FBConfirmViewController *fbConfirmVC = [[FBConfirmViewController alloc] initWithNibName:@"FBConfirmViewController" bundle:nil];
    fbConfirmVC.pageType = account ? FB_UserInfo : FB_Link_Account;
    fbConfirmVC.info = self.facebookInfo;
    fbConfirmVC.name = self.facebookEditUserName;
    [self.navigationController pushViewController:fbConfirmVC animated:YES];
    
    __weak typeof(self)weakSelf = self;
    fbConfirmVC.pushHomePageVC = ^(NSInteger index){
        if (account) {
            if (index) {
                //進入完善資料頁面
                FBEditInfoViewController *fbeditInfoVC = [[FBEditInfoViewController alloc] init];
                fbeditInfoVC.dictCommit[@"token"] = weakSelf.tempToken;
                //这里更具account来判断是否facebook 中的完善需要，普通注册。
                //普通注册不需要需要电话号码
                fbeditInfoVC.pageType = account == 1 ? PageTypeWithFacebookRegister : PageTypeWithRegister;
                [weakSelf.navigationController pushViewController:fbeditInfoVC animated:YES];
            } else {
                //不需要完善資料，就直接進入登錄頁面
                [weakSelf loginFinishIntoHomeAction];
            }

        } else {
            //绑定用户信息
            NSDictionary *parameter = @{
                                        @"fbtoken":weakSelf.tempToken,
                                        @"binding":@1,
                                        @"deviceID":[weakSelf mobileToken]};
            [weakSelf verifyFacebookStatus:parameter start:NO];
        }
    };
    
}

- (void)getFaceBookUserInfo
{
    [self.view showHUDActivityView:@"正在登錄..." shade:YES];
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                       parameters:@{@"fields": @"picture, email, name, gender"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         [self.view removeHUDActivity];
         if ( error ) {
             //登錄失败提示
             DLog(@"login error : %@", [error localizedDescription]);
         }else{
             if ( [BKTool isStringBlank:result[@"email"]] ) {
                 [self.view removeHUDActivity];
                 [[[UIAlertView alloc] initWithTitle:nil message:@"請同意及提供facebook電郵資料" delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil, nil] show ];
                 [self outFacebookLogin];
             }else{
                 self.facebookInfo = result;
                 [self verifyFacebookStatus:@{@"fbtoken":self.tempToken,
                                              @"deviceID":[self mobileToken]} start:NO];
             }
         }
     }];
    
    
}

#pragma mark - FBSDKLoginButtonDelegate
- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error {
    if(!error && !result.isCancelled){
        //这里会返回一个FB token
        self.tempToken = result.token.tokenString;
        NSLog(@"self.tempToken = %@", self.tempToken);
        if (self.tempToken != nil) {
            [self getFaceBookUserInfo];
        }
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
}

#pragma mark - TextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (SCREEN_HEIGHT <1500 && self.view.frame.origin.y ==0) {
        [UIView animateWithDuration:.3f animations:^{
            CGRect rect = self.view.frame;
            rect.origin.y -= 120;
            self.view.frame = rect;
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _textFieldAccount) {
        [_textFieldPassword becomeFirstResponder];
    }else{
        [self changeFrame];
        [textField resignFirstResponder];
        [self loginAction:nil];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self mResignFirstResponder];
}

- (void)mResignFirstResponder {
    if ([_textFieldAccount isFirstResponder]) {
        [_textFieldAccount resignFirstResponder];
    }else if ([_textFieldPassword isFirstResponder]){
        [_textFieldPassword resignFirstResponder];
    }
    [self changeFrame];
}

- (void)changeFrame{
    if (self.view.frame.origin.y !=0) {
        [UIView animateWithDuration:.3f animations:^{
            self.view.y = 0;
        }];
    }
    
}
- (EKLoginPresenter *)presenter {
    if (!_presenter) {
        _presenter = [[EKLoginPresenter alloc] init];
        _presenter.vLoginViewProtocol = self;
    }
    return _presenter;
}

- (void)dismissLoginViewWithCompletion:(void (^)(void))completion{
    [self dismissViewControllerAnimated:YES completion:completion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
