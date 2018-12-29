/**
 -  BKReportViewController.m
 -  BKHKAPP
 -  Created by ligb on 2017/9/6.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BKReportViewController.h"
#import "BKCustomPickerView.h"
#import "BKSendThemePhotos.h"

@interface BKReportViewController ()
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) BKCustomPickerView *vPickerView;
@end

@implementation BKReportViewController

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:@"BKBaseSendThemeViewController" bundle:nibBundleOrNil]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor EKColorBackground];
//    self.title = @"举报帖子";
    
    if ([self.dict[@"title"] hasPrefix:@"舉報"]) {
         self.title = self.dict[@"title"];
        [self.vRightBarButton setTitle:@"舉報" forState:UIControlStateNormal];
        //举报帖子
        self.vTypeView = BKSendReportView;
        self.vIndicatorImg.hidden = NO;
        self.vReportButton.hidden = NO;
        self.vTextFieldLabel.hidden = NO;
        self.vTextFieldNumber.hidden = YES;
        self.vFooterView.hidden = YES;
        self.vPhotoBtn.hidden = YES;
        self.vTextViewNumber.text = @"200";
    } else {
        //引用回复
        self.vTypeView = BKSendRevertView;
        [self.vRightBarButton setTitle:@"發佈" forState:UIControlStateNormal];
        self.vTextFieldLabel.hidden = NO;
        self.vTextFieldLabel.textAlignment = NSTextAlignmentLeft;
        self.vTextFieldNumber.hidden = YES;
        NSArray *titles = [self.dict[@"title"] componentsSeparatedByString:@","];
        self.vTextFieldLabel.text = titles.firstObject;
        self.title = titles.lastObject;
    }
   

}

- (void)setParames:(NSDictionary *)parames {
    self.dict = [parames copy];
}

- (void)mInitData {
    [super mInitData];
    
}

//举报理由
- (void)mSelectReport {
    [self.view endEditing:true];
    if (self.reportArray.count) {
        if (_vPickerView) {
            [_vPickerView hiddenPickerView];
            _vPickerView = nil;
        }
        
        _vPickerView = [BKCustomPickerView showPickerViewHeaderColor:[UIColor EKColorNavigation] title:@"選擇舉報理由" displayCount:1 datas:self.reportArray forKey1:nil forKey2:nil defineSelect:0 doneBlock:^(NSInteger selectedIndex, id selectedValue) {
            self.vTextViewLabel.hidden = YES;
            self.vTextView.text = selectedValue;
        } cancelBlock:^{
            
        } supView:self.view];
    } else {
        [self.view showError:@"數據出錯"];
    }
}

- (void)mInitUI {
    [super mInitUI];
    
    self.vTextField.hidden = YES;
}

- (BOOL)isEqualEdit {
    if (self.vTypeView == BKSendReportView) {
        if ( [BKTool isStringBlank:self.vTextView.text] ) {
            [self.view showHUDTitleView:@"請選擇違規內容" image:nil];
            return NO;
        }
        if (self.vTextView.text.length >200) {
            [self.view showHUDTitleView:@"舉報說明字數超出上限" image:nil];
            return NO;
        }
    } else if (self.vTypeView == BKSendRevertView) {
        if ([BKTool isStringBlank:self.vTextView.text]){
            [self.view showHUDTitleView:@"請輸入內容" image:nil];
            return NO;
        }
        if (self.vTextView.text.length >800) {
            [self.view showHUDTitleView:@"帖子內容字數超出上限" image:nil];
            return NO;
        }
    }
    self.vRightBarButton.enabled = NO;
    return YES;
}

- (void)mTouchRightBarButton {
    if (self.vTypeView == BKSendReportView) {
        //發佈舉報
        if ([self isEqualEdit]) {
            NSDictionary *params = @{@"token":TOKEN,
                                     @"rid":self.dict[@"repid"],
                                     @"rtype":@"post",
                                     @"message":self.vTextView.text};
            [self.view showHUDActivityView:@"正在發佈..." shade:NO];
            [self.vPresenter mSendReport:params handler:^(NSString *message, BOOL status) {
                [self.view showHUDTitleView:message image:nil];
                if (status) {
                    [self performBlock:^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    } afterDelay:1];
                }
                self.vRightBarButton.enabled = YES;
                [self.view removeHUDActivity];
            }];
        }
    } else {
        //回復引用跟帖
        if ([self isEqualEdit]) {
            NSDictionary *dicInfo = nil;
            //回复主题主题
            if ( [self.dict[@"title"] hasSuffix:@"樓主："] ) {//普通回贴
                dicInfo = @{@"token":TOKEN,
                            @"fid":self.dict[@"fid"] ,
                            @"tid":self.dict[@"tid"] ,
                            @"subject":self.dict[@"title"],//@"回覆樓主",
                            @"message":self.vTextView.text,
                            @"pw":self.dict[@"password"]
                            };
            }else{//回复某个楼层或者是引用回复跟帖
                dicInfo = @{@"token":TOKEN,
                            @"fid":self.dict[@"fid"],
                            @"tid":self.dict[@"tid"] ,
                            @"repquote":self.dict[@"repid"],//@(_repid),
                            @"message":self.vTextView.text,
                            @"pw":self.dict[@"password"] };
            }
            
            NSArray *files = @[];
            MBProgressHUD *progressHUD =  [self showActivityView:@"0%"];
            if (self.vAssets.count) {
                files = [BKSendThemePhotos uploadingImageFiles:self.vAssets];
            }
            [self.vPresenter mSendThemeTypeURL:kPostReleaseURL param:dicInfo files:files precent:^(float precent) {
                NSString *progressStr = [NSString stringWithFormat:@"%.1f", precent * 100];
                progressStr = [progressStr stringByAppendingString:@"%"];
                if (progressHUD) progressHUD.labelText = progressStr;
                DLog(@"progressStr = %@",progressStr);
            } handler:^(NSString *message, BOOL status) {
                if (progressHUD) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [progressHUD removeFromSuperview];
                    });
                }
                self.vRightBarButton.enabled = YES;
                [self.view showHUDTitleView:message image:nil];
                if (self.vAssets.count) [self.vPresenter mRemovePhotoFid:self.vFid tid:self.vTid];
                // 更新詳情数据
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdataRevertNotification object:nil];

                [self performBlock:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                } afterDelay:1];
            }];
            
        }
        
    }
}


- (void)performBlock:(void(^)(void))block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (MBProgressHUD *)showActivityView:(NSString *)message {
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = message;
    hud.tag = 0xffff;
    hud.alpha = .6;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙层效果
    hud.dimBackground = YES;
    return hud;
}

@end
