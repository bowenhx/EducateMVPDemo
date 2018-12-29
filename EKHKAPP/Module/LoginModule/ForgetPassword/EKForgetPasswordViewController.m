/**
 -  EKForgetPasswordViewController.m
 -  EKHKAPP
 -  Created by HY on 2017/10/16.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "EKForgetPasswordViewController.h"

@interface EKForgetPasswordViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vNameLabelTopMargin;

@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (weak, nonatomic) IBOutlet UITextField *textViewName;

@property (weak, nonatomic) IBOutlet UITextField *textViewPassword;

@end

@implementation EKForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘記密碼";
}

#pragma mark - 设置UI
- (void)mInitUI {
    [self vBackBarButton];
    self.view.backgroundColor = [UIColor EKColorBackground];
    [_commitButton updataBtnBackground];
    //适配ipX
    _vNameLabelTopMargin.constant = 21 + NAV_BAR_HEIGHT;
}

#pragma mark - 提交
- (IBAction)commitButtonAction:(UIButton *)sender {
    if ([self checkAccount]) {
        sender.enabled = NO;
        [self resignTextResponderAction];
        [self.view showHUDActivityView:@"正在提交..." shade:NO];
        [EKHttpUtil mHttpWithUrl:kFindPasswordURL parameter:@{@"username":_textViewName.text,@"email":_textViewPassword.text} response:^(BKNetworkModel *model, NSString *netErr) {
            [self.view removeHUDActivity];
            if (netErr) {
                [self.view showHUDTitleView:netErr image:nil];
            }else{
                if (model.status == 1) {
                    CustomAlertController *alertController = [[CustomAlertController alloc] init];
                    alertController.confirmTitle(@"確定").title(model.message).controller(self).alertStyle(alert);
                    [alertController show:nil confirmAction:^(UIAlertAction *action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    } cancelAction:nil];
                } else {
                    [self.view showHUDTitleView:model.message image:nil];
                }
            }
            sender.enabled = YES;
        }];
    }
}

#pragma mark - 检查填写是否为空
- (BOOL)checkAccount {
    if ([BKTool isStringBlank:_textViewName.text]) {
        [self.view showHUDTitleView:@"用戶名不能為空" image:nil];
        return NO;
    }
    //找回密码页面逻辑
    if ([BKTool isStringBlank:_textViewPassword.text]) {
        [self.view showHUDTitleView:@"郵箱不能為空" image:nil];
        return NO;
    }
    return YES;
}

#pragma mark - 其他逻辑
- (void)resignTextResponderAction {
    if ([_textViewName isFirstResponder]) {
        [_textViewName resignFirstResponder];
    }else if ([_textViewPassword isFirstResponder]){
        [_textViewPassword resignFirstResponder];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resignTextResponderAction];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
