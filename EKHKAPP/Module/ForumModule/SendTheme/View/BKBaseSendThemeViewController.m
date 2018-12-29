/**
 -  BKSendThemeViewController.m
 -  BKHKAPP
 -  Created by ligb on 2017/8/22.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BKSendThemeViewController.h"


static CGFloat PHOTOS_WIDTH = 75; //照片图片的宽，高

@interface BKBaseSendThemeViewController () <UIActionSheetDelegate, BKSendThemeProtocol> {
    
    __weak IBOutlet UIView *_vSortSupView;
    __weak IBOutlet UILabel *_sortLine;
    __weak IBOutlet UIView *_vFieldSupView;
    //选择照片按钮背景色
    __weak IBOutlet NSLayoutConstraint *_vPhotoBackgroundTopConstraints;
    __weak IBOutlet NSLayoutConstraint *_scrollViewTop;
    //定义照片的间距
    CGFloat  _vSendThemeViewPhotoSpace;
}

@property (nonatomic, strong) NSMutableArray *vBannerList;  //banner 广告数据源
@property (nonatomic, strong) BKBannerAdView *vBannerView;

@end

@implementation BKBaseSendThemeViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //统计
    [EKGoogleStatistics mGoogleScreenAnalytics:kThemeReplyPageIndex];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _scrollViewTop.constant = NAV_BAR_HEIGHT;
}

- (void)mInitUI {
    
    //设置view 基本背景颜色
    [self mSetItemViewColor];
    
    //注册通知用来监听textField 和textView 文字字数改变
    [self mAddObserverNotification];
    
    //设置页面基本元素
    [self mSetViewItem];
    
    //添加表情view
    [self mAddFaceSubItemView];
    
    //添加选择照片button
    [self vPhotoBtn];
    
}

- (void)mInitData {
    //获取举报理由数据
    [self.vPresenter getReportMessage];
}

- (void)setParames:(NSDictionary *)parames {
    self.vFid = parames[@"fid"];
    self.vPassword = parames[@"password"];
    self.vTitle = parames[@"title"];
    self.vThreadtypes = parames[@"threadtypes"];
}

- (void)mTouchRightBarButton {
    NSLog(@"发布帖子action");
}

//导航返回action
- (void)mTouchBackBarButton {
    [self.view endEditing:true];
    if (_vTypeView == BKSendThemeView) {
        if (!([BKTool isStringBlank:_vTextView.text] && [BKTool isStringBlank:_vTextField.text] && !self.vAssets.count)) {
            //弹出提示，是否需要保持草稿
            [self mShowAlertView];
            return;
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


//选择分类
- (IBAction)mSelectSortThemeAction:(UIButton *)sender {
    [self mSelectThemeSort];
}

- (void)mSelectThemeSort {
}

//违规内容
- (IBAction)mSelectReportAction:(UIButton *)sender {
    [self mSelectReport];
}

- (void)mSelectReport {
}

//选择表情按钮
- (void)mSelectFooterFaceAction:(UIButton *)sender {

    //表情与键盘点击切换
    if ([_vTextView isFirstResponder]){
        [_vTextView resignFirstResponder];
        sender.selected = YES;
        if (IPHONEX) {
            _vFooterView.vScrollView.hidden = NO;
        }
        //键盘回收时显示表情，故在这里添加
        [UIView animateWithDuration:.3 animations:^{
            _vFooterView.transform = CGAffineTransformMakeTranslation(0, - HEIGHT(_vFooterView) + BOTTOM_TABBAR_HEIGHT);
        }];
    }else{
        [_vTextView becomeFirstResponder];
        sender.selected = NO;
    }
   
}




//选择表情
- (void)selectedSmiliesItem:(SmiliesButton *)smilieBtn{
    _vTextViewLabel.hidden = YES;
    [self smileyUpdataUrl:smilieBtn.search img:smilieBtn.imageView.image rang:_vTextView.selectedRange insert:YES];
    [self resetTextStyle];
}

- (void)resetTextStyle {
    //After changing text selection, should reset style.
    NSRange wholeRange = NSMakeRange(0, _vTextView.textStorage.length);
    [_vTextView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    [_vTextView.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:wholeRange];
    
    //计算表情个数并减少文字个数
    if (_vTypeView == BKSendRevertView) {
        self.vTextViewNumber.text = [NSString stringWithFormat:@"%ld",(long)kSendThemeTextViewNumberMinLength - wholeRange.length];
    }else{
        self.vTextViewNumber.text = [NSString stringWithFormat:@"%ld",(long)kSendThemeTextViewNumberMaxLength - wholeRange.length];
    }
    
}


//textView 显示表情处理
- (void)smileyUpdataUrl:(NSString *)face img:(UIImage *)img rang:(NSRange)rang insert:(BOOL)isInsert {
    EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
    
    //Set tag and image
    emojiTextAttachment.emojiTag = face;
    emojiTextAttachment.image = img;
    //    emojiTextAttachment.bounds =  CGRectMake(20, 150.0f, 28.0f, 28.0f);
    
    //Set emoji size
    emojiTextAttachment.emojiSize = 30.0;
    
    NSAttributedString *attring = [NSAttributedString attributedStringWithAttachment:emojiTextAttachment];
    
    if (isInsert) {
        //Insert emoji image
        [self.vTextView.textStorage insertAttributedString:attring atIndex:rang.location];
        
        //Move selection location
        self.vTextView.selectedRange = NSMakeRange(rang.location + 1, rang.length);
        [self.vTextView.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:rang];
    }else{
        [self.vTextView.textStorage replaceCharactersInRange:rang withAttributedString:attring];
    }
    
    
}


#pragma mark textFied 监听字数改变
- (void)mTextFieldNotification:(UITextField *)sender {
    if(sender == _vTextField) {
        [self.vPresenter mChangeTextFieldString:_vTextField actionNum:_vTextFieldNumber];
    }
}

#pragma mark TextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _vFooterView.hidden = YES;
    //判断pickerView 是否隐藏，没有隐藏去隐藏
//    if (_pickViewBg.frame.origin.y != SCREEN_HEIGHT) {
//        [self didHiddenPickerView];
//    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - TextViewDelegate
- (void)mTextViewEditChanged:(NSNotification *)obj
{
    [self.vPresenter mCHangeTextViewString:obj.object viewType:_vTypeView == BKSendReportView ? BKSendReportData : BKSendSubThemeData placehol:_vTextViewLabel actionNum:_vTextViewNumber];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _vFooterView.hidden = NO;
//    if (_bannerView) {
//        //开始编辑的时候隐藏广告
//        [_bannerView setHidden:YES];
//    }
}


#pragma mark 键盘即将显示
- (void)mKeyBoardWillShow:(NSNotification *)note{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = -rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
       
        CGFloat space = IPHONEX ?  (ty+35) : ty;
        _vFooterView.transform = CGAffineTransformMakeTranslation(0, space);
    }];
    
    if (IPHONEX) {
         _vFooterView.vScrollView.hidden = NO;
    }
}

#pragma mark 键盘即将退出
- (void)mKeyBoardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        _vFooterView.transform = CGAffineTransformIdentity;
    }];
    if (IPHONEX) {
        _vFooterView.vScrollView.hidden = YES;
    }
}

- (void)mSetViewItem{
    //设置返回按钮图片
    [self.vBackBarButton setImage: [UIImage imageNamed:@"home_return_unpressed"] forState:UIControlStateNormal];
    
    //判断是否有分类数据来决定是否显示分类选项UI，默认显示分类数据
    if (!self.vThreadtypes.count) {
        _vSortSupView.hidden = YES;
        self.vSortViewHeight.constant = 0;
        _sortLine.hidden = YES;
    }
    
    if (!self.vTid) {
        self.vTid = @"0";
    }

}

- (void)mSetItemViewColor {
    _vScrollView.backgroundColor = [UIColor whiteColor];
    _vScrollView.contentSize = CGSizeMake(_vScrollView.w, _vScrollView.h-20);
    _vTextFieldNumber.textColor = @"cacaca".color;
    _vTextViewNumber.textColor = @"cacaca".color;
    
}

//删除图片view
- (void)mRemoveScrollViewSuperViewBtn {
    for (UIButton *buttonView in [_vPhotoView subviews]) {
        [buttonView removeFromSuperview];
    }
    [self mAddPhotosImage];
}

//退出键盘action
- (void)cancelResponder
{
    [self.view endEditing:true];
//    self.vFooterView.hidden = YES;
}

#pragma mark
#pragma mark 各种代理，block 回调

#pragma mark BKSendThemeProtocol
- (void)mGetReportMessage:(NSArray<BKReportModel *> *)array {
    NSMutableArray <NSString *> *reportData = [NSMutableArray arrayWithCapacity:array.count];
    [array enumerateObjectsUsingBlock:^(BKReportModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       //获取举报理由数据
        [reportData addObject:obj.str];
    }];
    self.reportArray = reportData;
}

- (void)mRemovePhotoItem:(NSInteger)index {
    if (self.vAssets.count > index) {
        [self.vAssets removeObjectAtIndex:index];
        [self mRemoveScrollViewSuperViewBtn];
    }
}

- (void)mAddAssetsImage:(ZLPhotoPickerBrowserPhoto *)image {
    [self.vAssets addObject:image];
    [self mRemoveScrollViewSuperViewBtn];
}


#pragma  mark ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //手机相册
        [self mLocalPhoto];
    } else if (buttonIndex == 1) {
        //拍照
        [self mTakePhoto];
    }
}


- (IBAction)mTouchesScrollerView:(UITapGestureRecognizer *)sender {
    [self cancelResponder];
    [UIView animateWithDuration:.3f animations:^{
        _vFooterView.transform = CGAffineTransformIdentity;
    }];
    if (IPHONEX) {
        _vFooterView.vScrollView.hidden = YES;
    }
}


//////////////////**********创建各种对象方法**********/////////////////////////////////
#pragma mark
#pragma mark 各种  <对象的创建>
- (void)mShowAlertView {
    //是否保存草稿
    CustomAlertController *customAlert = [[CustomAlertController alloc] init];
 customAlert.message(kForumModule_SendThemeText).cancelTitle(kAlertSelectNoSaveText).confirmTitle(kAlertSelectSaveText).controller(self).alertStyle(alert);
     [customAlert show:nil confirmAction:^(UIAlertAction *action) {
        [self.vPresenter mSaveSendThemeData:self.vFid tid:self.vTid photo:self.vAssets textField:self.vTextField textView:self.vTextView];
         [self dismissViewControllerAnimated:YES completion:nil];
    } cancelAction:^(UIAlertAction *action) {
        [self.vPresenter mRemovePhotoFid:self.vFid tid:self.vTid];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

}

#pragma mark 添加照片到view 中
- (void)mAddPhotosImage {
    // 加一是为了有个添加button
    NSInteger count = self.vAssets.count + 1;
    for (int i=0;i < count; i++) {
        float addBtnX = _vSendThemeViewPhotoSpace + (_vSendThemeViewPhotoSpace + PHOTOS_WIDTH) * (i%4);
        float addBtnY = 50 + (10 + PHOTOS_WIDTH) * (i/4);
        
        //多算一个frame确定添加按钮的坐标位置
        if (i == self.vAssets.count) {
            if (i>8) {
                self.vPhotoBtn.hidden = YES;
            }else{
                self.vPhotoBtn.hidden = NO;
                self.vPhotoBtn.frame = CGRectMake(addBtnX, addBtnY, PHOTOS_WIDTH, PHOTOS_WIDTH);
                [_vPhotoView addSubview:_vPhotoBtn];
            }
            break;
        }
        
        UIButton *btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
        btnImage.frame = CGRectMake(addBtnX, addBtnY, PHOTOS_WIDTH, PHOTOS_WIDTH);
        btnImage.tag = i;
        UIImage *image = [self.vAssets[i] thumbImage];
        [btnImage setBackgroundImage:image forState:UIControlStateNormal];
        [_vPhotoView addSubview:btnImage];
        [btnImage addTarget:self action:@selector(mDiddSelectPhotoImage:) forControlEvents:UIControlEventTouchUpInside];
        _vPhotoBackgroundTopConstraints.constant = btnImage.maxY + 20;
    }
    
    

}

#pragma mark 创建查看大图选择器
- (void)mDiddSelectPhotoImage:(UIButton *)btn {
    [self.vPresenter mScanPhotoPickerView:self photos:self.vAssets index:btn.tag];
}

#pragma mark 选择相册
- (void)mLocalPhoto{
    __weak typeof(self)weakSelf = self;
    [self.vPresenter mSelectZLPhotoPickerView:self photos:self.vAssets assets:^(NSArray *photos) {
        [weakSelf.vAssets setArray:photos];
        [weakSelf mRemoveScrollViewSuperViewBtn];
    }];
}

#pragma mark 选择拍照
- (void)mTakePhoto{
    [self.vPresenter mSelectImagePickerView:self];
}

#pragma mark 选择照片或者相机
- (void)mSelectPhotoAction:(UIButton *)btn {
    [self cancelResponder];
    [[[UIActionSheet alloc] initWithTitle:nil
                                  delegate:self
                         cancelButtonTitle:@"取消"
                    destructiveButtonTitle:nil
                         otherButtonTitles:@"手機相冊",@"系統拍照", nil] showInView: self.view];
}

#pragma mark 创建底部表情view
- (void)mAddFaceSubItemView {
    //add footer face view
    _vFooterView = [BKFooterFacerView getFooterFaceView];
    [self.view addSubview:_vFooterView];
    
    __weak typeof(self)weakSelf = self;
    _vFooterView.mSelectFooterBtn = ^(UIButton *btn) {
        [weakSelf mSelectFooterFaceAction:btn];
    };
    
    _vFooterView.mSelectFaceAction = ^(SmiliesButton *smilies) {
        [weakSelf selectedSmiliesItem:smilies];
    };
    
    if (IPHONEX) {
        _vFooterView.vScrollView.hidden = YES;
    }
}

#pragma mark 添加通知
- (void)mAddObserverNotification {
    //添加监听textField 字数变化事件
    [_vTextField addTarget:self action:@selector(mTextFieldNotification:) forControlEvents:UIControlEventEditingChanged];
    
    //添加监听TextView 字数变化事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mTextViewEditChanged:) name:UITextViewTextDidChangeNotification object:_vTextView];
    
    //监听键盘的出现与隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mKeyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mKeyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (NSMutableArray *)vBannerList{
    if (!_vBannerList) {
        _vBannerList = [NSMutableArray array];
    }
    return _vBannerList;
}

- (NSMutableArray *)vAssets{
    if (!_vAssets) {
        _vAssets = [NSMutableArray array];
    }
    return _vAssets;
}

- (UIButton *)vPhotoBtn{
    if (!_vPhotoBtn) {
        _vPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //照片间距
        _vSendThemeViewPhotoSpace = (SCREEN_WIDTH - PHOTOS_WIDTH * 4) / 5;
        _vPhotoBtn.frame = CGRectMake(_vSendThemeViewPhotoSpace, 50, PHOTOS_WIDTH, PHOTOS_WIDTH);
        [_vPhotoBtn setBackgroundImage:[UIImage imageNamed:@"Post_vi_Add"] forState:UIControlStateNormal];
        [_vPhotoBtn addTarget:self action:@selector(mSelectPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        [_vPhotoView addSubview:_vPhotoBtn];
        
        _vPhotoBackgroundTopConstraints.constant = _vPhotoBtn.maxY + 20;
        
    }
    return _vPhotoBtn;
}


- (BKSendThemePresenter *)vPresenter{
    if (!_vPresenter) {
        _vPresenter = [[BKSendThemePresenter alloc] init];
        _vPresenter.vProtocol = self;
    }
    return _vPresenter;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
