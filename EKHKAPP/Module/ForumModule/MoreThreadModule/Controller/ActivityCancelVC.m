//
//  ActivityCancelVC.m
//  BKMobile
//
//  Created by 薇 颜 on 15/11/13.
//  Copyright © 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "ActivityCancelVC.h"

@interface ActivityCancelVC ()

@property (weak, nonatomic) IBOutlet SAMTextView *textView;

@end

@implementation ActivityCancelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"取消報名";
    
    [_textView setPlaceholder:@"留言"];
    [self.vRightBarButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.vRightBarButton addTarget:self action:@selector(actionSubmit:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionSubmit:(id)sender{
    
    
    NSDictionary *parameter = @{@"token":TOKEN, @"tid":_tid, @"atype":@"cancel", @"message": _textView.text};
    [self.view showHUDActivityView:@"正在處理..." shade:NO];
    
    [EKHttpUtil mHttpWithUrl:kActivityURL parameter:parameter response:^(BKNetworkModel *model, NSString *netErr) {
        [self.view removeHUDActivity];
        
        if (netErr) {
            [self.view showHUDTitleView:netErr image:nil];
        }else {
            
            [self.view showHUDTitleView:model.message image:nil];
            if (model.status) {
                //取消成功后更改狀態
                dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdataRevertNotification object:nil];
                });
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
    }];

    
    
}

@end
