/**
 -  BKSendThemeViewController.m
 -  BKHKAPP
 -  Created by ligb on 2017/9/5.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BKSendThemeViewController.h"
#import "BKThemeMenuModel.h"
#import "BKCustomPickerView.h"
#import "BKSendThemePhotos.h"
#import "UITextView+String.h"
#import "NSAttributedString+EmojiExtension.h"

@interface BKSendThemeViewController ()
@property (nonatomic, copy)   NSMutableArray<NSString *> *vReportArray;
@property (nonatomic, strong) BKThemeMenuModel *vSelectThemeModel;
@property (nonatomic, strong) BKCustomPickerView *vPickerView;
@end

@implementation BKSendThemeViewController

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
    
    self.title = self.vTitle;
    
}

- (void)mInitUI {
    [super mInitUI];
    //发布帖子
    self.vTextField.placeholder = @"標題（必填）";
    [self.vRightBarButton setTitle:@"發佈" forState:UIControlStateNormal];
    
 
}

- (void)mInitData {
    NSArray *arrInfo = [BKSaveData getArray:kCommentKey];
   
    __weak typeof(self) bself = self;
    [arrInfo enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        //判断是否是同一个板块的同一个帖子，如果不是，就不用显示草稿
        if ([obj[@"fid"] integerValue] == self.vFid.integerValue && [obj[@"tid"] integerValue] == self.vTid.integerValue) {
            self.vTextField.text = obj[@"textField"];
            self.vTextView.text = obj[@"textView"];
            if (self.vTextView.text.length) self.vTextViewLabel.hidden = YES;
            [self textChangeLengthNum];
            
            //获取所有图片字符串
            NSString *string = obj[@"assets"];
            if ([BKTool isStringBlank:string]) {
                return;
            }
            NSArray *images = [string componentsSeparatedByString:@"#"];
            BKSendThemePhotos *photo = [[BKSendThemePhotos alloc] init];
            photo.photosAssets = ^(NSArray <ZLPhotoPickerBrowserPhoto *>* photo){
                [bself.vAssets addObjectsFromArray:photo];
                [bself mAddPhotosImage];
            };
            [photo photosAssets:images];
        }
        
    }];
    
    if (self.model) {
        self.vTextField.text = self.vTitle;
        self.vTextFieldLabel.hidden = YES;
        self.vTextViewLabel.hidden = YES;
        
        if (self.model.imgUrls.count) {
            BKSendThemePhotos *photo = [[BKSendThemePhotos alloc] init];
            [photo loadImage:self.model.imgUrls];
            @WEAKSELF(self);
            photo.photosAssets = ^(NSArray <ZLPhotoPickerBrowserPhoto *>* photo){
                [selfWeak.vAssets addObjectsFromArray:photo];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [selfWeak mAddPhotosImage];
                });
            };
            
        }
        
        //处理textView
        self.vTextView.text = [UITextView textMessage:self.model];
        
        for (NSDictionary *item in self.model.smileyInf) {
            NSRange rang = NSRangeFromString(item[@"range"]);
            UIImage *image = [[BKFaceManage sharedInstance] mCoreImageRuleMate:item[@"value"]];
            [self smileyUpdataUrl:item[@"value"] img:image rang:rang insert:YES];
        }
        
        //改变显示字数
        [self performSelector:@selector(textChangeLengthNum) withObject:nil afterDelay:.7f];
        
    }

}


- (void)setModel:(InvitationDataModel *)model {
    _model = model;
}


- (void)textChangeLengthNum {
    long temp1 = kSendThemeTextFieldNumberMaxLength - self.vTextField.text.length;
    self.vTextFieldNumber.text = [NSString stringWithFormat:@"%ld",(long)temp1];
    
    long temp2 = kSendThemeTextViewNumberMaxLength - self.vTextView.text.length;
    self.vTextViewNumber.text = [NSString stringWithFormat:@"%ld",(long)temp2];
}

//选择主题分类
- (void)mSelectThemeSort {
    [self.view endEditing:true];
    
    if (!self.vReportArray.count) {
        [self.vThreadtypes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BKThemeMenuModel *model = obj;
            [self.vReportArray addObject:model.name];
        }];
    }
   
    if (_vPickerView) {
        [_vPickerView hiddenPickerView];
        _vPickerView = nil;
    }
    
    _vPickerView = [BKCustomPickerView showPickerViewHeaderColor:[UIColor EKColorNavigation] title:@"選擇主題分類" displayCount:1 datas:self.vReportArray forKey1:nil forKey2:nil defineSelect:0 doneBlock:^(NSInteger selectedIndex, id selectedValue) {
        [self.vSortButton setTitle:selectedValue forState:UIControlStateNormal];
        _vSelectThemeModel = self.vThreadtypes[selectedIndex];
    } cancelBlock:^{
        
    } supView:self.view];
    
}

- (BOOL)isEqualEdit {
    if (!self.model) self.vTextView.text = [self.vTextView.textStorage getPlainString:nil];
    BOOL requireType = self.vThreadtypes.count;
    if (requireType) {
        if ([self.vSortButton.titleLabel.text isEqualToString:@"選擇主題分類"]) {
            [self.view showHUDTitleView:@"請選擇主題分類" image:nil];
            return NO;
        }
    }
    
    if ( !self.vTextField.hidden && [BKTool isStringBlank:self.vTextField.text] ) {
        [self.view showHUDTitleView:@"請輸入標題" image:nil];
        return NO;
    } else if ([BKTool isStringBlank:self.vTextField.text]){
        [self.view showHUDTitleView:@"請輸入內容" image:nil];
        return NO;
    }
    
    if (self.vTextField.text.length > kSendThemeTextFieldNumberMaxLength) {
        [self.view showHUDTitleView:@"標題字數超出上限" image:nil];
        return NO;
    } else if (self.vTextView.text.length > kSendThemeTextViewNumberMaxLength) {
        [self.view showHUDTitleView:@"帖子內容字數超出上限" image:nil];
        return NO;
    }
    self.vRightBarButton.enabled = NO;
    return YES;
}

#pragma mark 发布编辑帖子
- (void)sendEditMotifNews {
    NSMutableArray *smileyArr = [NSMutableArray array];
    [self.model.smileyInf enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj[@"value" ] isEqual:@"jinggaoicon"]) {
            [smileyArr addObject:obj];
        }
    }];
    //添加警告icon图标
    NSString *message = [self.vTextView.textStorage getPlainString:smileyArr];
    DLog(@"message = %@",message);
    
    NSInteger typeid = 0;
    if (_vSelectThemeModel) {
        typeid = _vSelectThemeModel.vid;
    }
    NSDictionary *dicInfo = @{@"token":TOKEN,
                              @"fid":self.vFid,
                              @"tid":@(self.model.tid),
                              @"pid":@(self.model.pid),
                              @"typeid":@(typeid),
                              @"subject":self.vTextView.text,
                              @"message":message,
                              @"pw":self.vPassword};
    
    NSArray *files = @[];
    MBProgressHUD *progressHUD = [self showActivityView:@"0%"];
    if (self.vAssets.count >0) {
        files = [BKSendThemePhotos uploadingImageFiles:self.vAssets];
    }
    [self.vPresenter mSendThemeTypeURL:kPostEditURL param:dicInfo files:files precent:^(float precent) {
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
        
        // 更新详情
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdataRevertNotification object:@(self.model.pid)];
        
        [self performBlock:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        } afterDelay:1];
    }];
    
    
}


#pragma mark 发布新帖
- (void)mTouchRightBarButton {
    [self.view endEditing:true];
    if ( ![self isEqualEdit] ) return;
    if (self.model) {
        CustomAlertController *customAlert = [[CustomAlertController alloc] init];
        //alert view
        customAlert.message(@"通過app編輯內容，所有內容格式都會消失，如果保留內容格式，請登入網頁版修改").cancelTitle(@"取消").confirmTitle(@"確定").controller(self).alertStyle(alert);
        [customAlert show:nil confirmAction:^(UIAlertAction *action) {
            //發送編輯帖子提交服務器
            [self sendEditMotifNews];
        } cancelAction:^(UIAlertAction *action) {
             self.vRightBarButton.enabled = YES;
        }];
        return;
    }
    
    NSInteger typeid = 0;
    if (_vSelectThemeModel) {
        typeid = _vSelectThemeModel.vid;
    }
    
    NSDictionary *dicInfo = @{@"token":TOKEN,
                              @"fid":self.vFid,
                              @"subject":self.vTextField.text,
                              @"message":self.vTextView.text,
                              @"typeid":@(typeid),
                              @"pw":self.vPassword ? self.vPassword : @(0)};
    NSArray *files = @[];
    MBProgressHUD *progressHUD = nil;
    if (self.vAssets.count) {
        files = [BKSendThemePhotos uploadingImageFiles:self.vAssets];
        progressHUD = [self showActivityView:@"0%"];
    }
    [self.vPresenter mSendThemeTypeURL:kThemeReleaseURL param:dicInfo files:files precent:^(float precent) {
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
        
        //更新主题列表数据
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshThemeListNotifation object:nil];
        });
        
        [self performBlock:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        } afterDelay:1];
    }];
}

- (void)performBlock:(void(^)(void))block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_vPickerView) {
        [_vPickerView removeFromSuperview];
        _vPickerView = nil;
    }
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


- (NSMutableArray<NSString *> *)vReportArray {
    if (!_vReportArray) {
        _vReportArray = [NSMutableArray array];
    }
    return _vReportArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//导航返回action
- (void)mTouchBackBarButton {
    if (self.model) {
        //判断当前是否是编辑帖子（修改帖子）状态，是的话就不保存草稿
        [self dismissViewControllerAnimated:true completion:nil];
    } else {
        [super mTouchBackBarButton];
    }
}

@end
