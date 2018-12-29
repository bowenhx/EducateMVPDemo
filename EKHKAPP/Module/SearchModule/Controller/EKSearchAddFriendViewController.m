/**
 -  EKSearchAddFriendViewController.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/28.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:"添加好友"界面
 */

#import "EKSearchAddFriendViewController.h"

@interface EKSearchAddFriendViewController () <UITextViewDelegate>
#pragma mark - 属性 - UI
//"添加XXX为好友"label
@property (weak, nonatomic) IBOutlet UILabel *vUserNameLabel;
//附言输入框
@property (weak, nonatomic) IBOutlet SAMTextView *vTextView;
//分组选择按钮
@property (weak, nonatomic) IBOutlet UIButton *vChooseGroupButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vUserNameLabelTopConstraint;
#pragma mark - 属性 - 数据源
//分组数组
@property (strong, nonatomic) NSArray <NSString *> *vGroupArray;
#pragma mark - 属性 - 记录
//记录当前用户选择的分组的id
@property (nonatomic, assign) NSInteger vCurrentGid;
@end

@implementation EKSearchAddFriendViewController
#pragma mark - 初始化UI
- (void)mInitUI {
    self.title = @"加為好友";
    
    //1.显示用户名称
    _vUserNameLabel.text = [NSString stringWithFormat:@"添加%@為好友",_vUserName];
    
    //2.设置输入文本框
    NSString *placeHolder = @"附言（選填）。該用戶會看到這條附言，限50個字";
    NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:17],
                                NSForegroundColorAttributeName : [UIColor EKColorTitleGray]};
    _vTextView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:attribute];
    _vTextView.delegate = self;
    
    //3.设置导航栏的"提交"按钮
    [self.vRightBarButton setTitle:@"提交" forState:UIControlStateNormal];
    
    //适配ipX
    _vUserNameLabelTopConstraint.constant = 10 + NAV_BAR_HEIGHT;
}


#pragma mark - 初始化数据
- (void)mInitData {
    _vGroupArray = @[@"其他",
                   @"通過本站認識",
                   @"通過活動認識",
                   @"通過朋友認識",
                   @"親人",
                   @"同事",
                   @"同學",
                   @"不認識"];
    //默认选中"通过本站认识",所以gid默认为1
    _vCurrentGid = 1;
}


#pragma mark - 按钮监听事件
//"通过本站认识"按钮监听事件
- (IBAction)mClickChooseGroupButton:(id)sender {
    [self.view endEditing:YES];
    //创建选择分组的弹窗控制器
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    //循环添加gid选择条
    for (NSString *groupTitle in _vGroupArray) {
        UIAlertActionStyle style = 0;
        if ([groupTitle isEqualToString:@"通過本站認識"]) {
            //"通過本站認識"这行文字效果为红色
            style = UIAlertActionStyleDestructive;
        } else {
            //其余为蓝色
            style = UIAlertActionStyleDefault;
        }
        UIAlertAction *action = [UIAlertAction actionWithTitle:groupTitle
                                                         style:style
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           //更改按钮显示的文字
                                                           [_vChooseGroupButton setTitle:action.title forState:UIControlStateNormal];
                                                           //记录当前选中的gid
                                                           _vCurrentGid = [_vGroupArray indexOfObject:action.title];
                                                       }];
        [alertController addAction:action];
    }
    //添加最后一行的取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    alertController.popoverPresentationController.sourceView = _vChooseGroupButton;
    alertController.popoverPresentationController.sourceRect = _vChooseGroupButton.bounds;
    [self presentViewController:alertController animated:YES completion:nil];
}


//"提交"按钮监听事件
- (void)mTouchRightBarButton {
    [self.view endEditing:YES];
    //如果超过50个字符,则显示提醒弹窗,不提交数据到服务器
    if (_vTextView.text.length > 50) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"附言不能超過50個字符"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"確定"
                                                                style:UIAlertActionStyleDefault
                                                              handler:nil];
        [alertController addAction:confirmAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    [self.view showHUDActivityView:nil shade:NO];
    //提交请求信息到服务器    
    [EKSearchUserModel mRequestAddFriendWithUid:_vUid
                                           note:_vTextView.text
                                            gid:_vCurrentGid
                                       callBack:^(NSString *netErr, NSString *message) {
                                           [self.view removeHUDActivity];
                                           if (netErr) {
                                               [self.view showError:netErr];
                                           } else {
                                               //信息提交成功后,弹出弹窗控制器,用户点击"确定"之后退回到上一个界面
                                               UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                                                        message:message
                                                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                                               UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"確定"
                                                                                                       style:UIAlertActionStyleDefault
                                                                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                                                                         [self.navigationController popViewControllerAnimated:YES];
                                                                                                     }];
                                               [alertController addAction:confirmAction];
                                               [self presentViewController:alertController animated:YES completion:nil];
                                           }
                                       }];
}


#pragma mark - UITextViewDelegate
//点击键盘回车,收起键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    } else {
        return YES;
    }
}


@end
