/**
 -  BKSelectPageView.m
 -  BKHKAPP
 -  Created by HY on 2017/8/30.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BKSelectPageView.h"

@interface BKSelectPageView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomSpace;

//记录键盘高
@property (nonatomic, assign) NSInteger  vKeyboardHeight;

//记录最大页码
@property (nonatomic, assign) NSInteger  vMaxPageNum;

//选择页数输入框
@property (nonatomic, weak) IBOutlet UITextField *pageTextField;

//选择页数view上的label，显示当前第几页
@property (nonatomic, weak) IBOutlet UILabel *currentPageLabel;


@end

@implementation BKSelectPageView

+(BKSelectPageView *)mGetInstance{
    
    BKSelectPageView *view = [[[NSBundle mainBundle] loadNibNamed:@"BKSelectPageView" owner:nil options:nil] firstObject];
    
    if (view) {
        [view mInitView];
    }
    return view;
}

//初始化frame
- (void)mInitView {
    
    //让该view的frame适配屏幕
    CGRect rect = self.frame;
    rect.size.height = [UIScreen  mainScreen].bounds.size.height;
    rect.size.width = [UIScreen mainScreen].bounds.size.width;
    [self setFrame:rect];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

//显示选择页数view
- (void)mShowViewWithCurrentPage:(NSInteger)currentPage totalPage:(NSInteger)totalPage{

    self.vMaxPageNum = totalPage;
    self.currentPageLabel.text = [NSString stringWithFormat:@"當前%ld/%ld頁",(long)currentPage,(long)totalPage];
    
    _pageTextField.keyboardType = UIKeyboardTypePhonePad;
    [_pageTextField becomeFirstResponder];
    
    [self layoutIfNeeded];  //必须要加
    [UIView animateWithDuration:0.3 animations:^{
        self.viewBottomSpace.constant = self.vKeyboardHeight;
        [self layoutIfNeeded];
    }];
}

//点击灰色蒙版层view，页面消失
- (IBAction)mTouchBgView:(id)sender {
    [self  removeFromSuperview];
}

#pragma mark - 选择页数view，取消按钮点击事件
- (IBAction)didSelectCancelAction:(UIButton *)sender {
    [self  removeFromSuperview];
}

#pragma mark - 选择页数view，确定按钮点击事件
- (IBAction)didSelectFinishAction:(UIButton *)sender {
    [self  removeFromSuperview];
    
    NSString *error;
    NSInteger selectPage = [self.pageTextField.text intValue]; //记录数字
    
    //判断输入的页码是否合法
    if ([self.pageTextField.text isEqualToString:@""] ) {
        error = kThemeModule_pageNumberErrorText;
    } else {
        
        if ([BKTool isPureInt:self.pageTextField.text]) {
            if (selectPage > 0  && selectPage <= self.vMaxPageNum) {
                error = nil; //页码合法，可以回调给外部页面，进行页面刷新
            } else{
                error = kThemeModule_pageNumberErrorText;
            }
        }else{
           error = kThemeModule_pageNumberErrorText;
        }
    }
   
    if (self.delegate && [self.delegate respondsToSelector:@selector(mTouchFinishBtnOfSelectPageViewWithError:page:)] ) {
        [self.delegate mTouchFinishBtnOfSelectPageViewWithError:error page:selectPage];
    }
}

#pragma mark - 键盘 增加监听，键盘高度
- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    _vKeyboardHeight = height;
}


@end
