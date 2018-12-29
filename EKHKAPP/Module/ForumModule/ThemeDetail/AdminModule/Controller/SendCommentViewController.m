//
//  SendCommentViewController.m
//  BKMobile
//
//  Created by bowen on 16/4/1.
//  Copyright © 2016年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "SendCommentViewController.h"


@interface SendCommentViewController ()<UITextViewDelegate>
{
    __weak IBOutlet UITextView *_textView;
    
    __weak IBOutlet UILabel *_textLabel;
}
@end

@implementation SendCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"發佈點評";
    
    //添加导航右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(sendCommentAction)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = RGBCOLOR(242, 241, 243).CGColor;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length || text.length) {
        _textLabel.hidden = YES;
    }else{
        _textLabel.hidden = NO;
    }
    return YES;
}
- (void)sendCommentAction{
    if ([BKTool isStringBlank:_textView.text]) {
        [self.view showHUDTitleView:@"請輸入點評內容后提交" image:nil];
        return;
    }
    
    [self.view showHUDActivityView:@"正在發送..." shade:NO];
    
    @WEAKSELF(self)
    [EKHttpUtil mHttpWithUrl:kPostCommentURL parameter:@{@"token":TOKEN,@"tid":_dicInfo[@"tid"],@"pid":_dicInfo[@"pid"],@"message":_textView.text,@"pw":_dicInfo[@"paw"]} response:^(BKNetworkModel *model, NSString *netErr) {
        [self.view removeHUDActivity];
        if (netErr) {
            [selfWeak.view showHUDTitleView:netErr image:nil];
        }else if (model.status == 1) {
            DLog(@"message = %@",model.message);
            [selfWeak.view showSuccess:model.message];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdataRevertNotification object:_dicInfo[@"pid"]];
                });
                
                [selfWeak.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [selfWeak.view showHUDTitleView:model.message image:nil];
        }
    }];
}

+ (void)push:(UIViewController *)vc detailModel:(ThreadsDetailModel *)detailModel dataModel:(InvitationDataModel *)dataModel pwd:(NSInteger)pwd{
    @WEAKSELF(vc)
    SendCommentViewController *sendCommentVC = [[SendCommentViewController alloc] initWithNibName:@"SendCommentViewController" bundle:nil];
    sendCommentVC.dicInfo = @{@"tid": @(detailModel.tid),
                              @"pid": @(dataModel.pid),
                              @"paw":@(pwd)};
    [vcWeak.navigationController pushViewController:sendCommentVC animated:YES];
}

@end
