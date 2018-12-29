//
//  MessageInputView.m
//  BKMobile
//
//  Created by 薇 颜 on 15/6/24.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
//

#import "MessageInputView.h"
#import "NSString+MessageInputView.h"

@interface MessageInputView () <UITextViewDelegate>
/**
 *  表情按鈕
 */
@property (nonatomic, strong) UIButton *faceButton;

/**
 图片 button
 */
@property (nonatomic, strong) UIButton *imageButton;

/**
 *  發送按鈕
 */
@property (nonatomic, strong) UIButton *sendButton;


@end

@implementation MessageInputView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMessageInputViewBar];
    }
    return self;
}
#pragma mark - layout subViews UI

- (void)setupMessageInputViewBar{
    
    // 配置输入工具条的样式和布局
    {
        //表情按钮
        _faceButton= [UIButton buttonWithType:UIButtonTypeCustom];
        [_faceButton setImage:[UIImage imageNamed:@"chat_face_unpressed"] forState:UIControlStateNormal];
        [_faceButton setImage:[UIImage imageNamed:@"chat_face_pressed"] forState:UIControlStateSelected];
        [_faceButton addTarget:self action:@selector(messageStyleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _faceButton.tag = 1;
        [self addSubview:_faceButton];
        
        CGFloat faceButtonWidth = 50;
        [_faceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.centerY.equalTo(self);
            make.width.height.mas_equalTo(faceButtonWidth);
        }];
        
    }
    
    {/*
        //选择图片按钮
        _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imageButton setImage:[UIImage imageNamed:@"Chat_iv_img_unpressed"] forState:UIControlStateNormal];
        [_imageButton setImage:[UIImage imageNamed:@"Chat_iv_img_pressed"] forState:UIControlStateHighlighted];
        [_imageButton addTarget:self action:@selector(messageStyleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_imageButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        _imageButton.tag = 3;
        [self addSubview:_imageButton];
      */
    }
    
    {
        //发送按钮
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setBackgroundColor:[UIColor EKColorNavigation]];
        [_sendButton setTitle:@"發 送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(messageStyleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendButton setTag:2];
        [self addSubview:_sendButton];
        
        CGFloat sendButtonRightMargin = -11;
        CGFloat sendButtonWidth = 63;
        CGFloat sendButtonHeight = 33;
        [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(sendButtonRightMargin);
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(sendButtonWidth);
            make.height.mas_equalTo(sendButtonHeight);
        }];
        
        _sendButton.layer.cornerRadius = sendButtonHeight / 2;
        _sendButton.layer.masksToBounds = YES;
    }
    
    //﹣﹣﹣﹣輸入框﹣﹣﹣﹣﹣﹣
    // 初始化输入框
    {
        _inputTextView = [[ChatMessageTextView  alloc] initWithFrame:CGRectZero];
        _inputTextView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
        _inputTextView.delegate = self;
        [self addSubview:_inputTextView];
        
        _inputTextView.backgroundColor = [UIColor whiteColor];
        _inputTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
        _inputTextView.layer.borderWidth = 0.65f;
        _inputTextView.layer.cornerRadius = 6.0f;
        
        CGFloat inputTextViewTopMargin = 10;
        CGFloat inputTextViewRightMargin = -8;
        [_inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_faceButton.mas_right);
            make.right.equalTo(_sendButton.mas_left).offset(inputTextViewRightMargin);
            make.top.equalTo(self).offset(inputTextViewTopMargin);
            make.bottom.equalTo(self).offset(-inputTextViewTopMargin);
        }];
         _inputTextView.placeHolder = @"發送私訊";
    }

}

- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight {
    // 动态改变自身的高度和输入框的高度
//    NSUInteger numLines = MAX([self.inputTextView numberOfLinesOfText],
//                              [self.inputTextView.text numberOfLines]);
    
    [_inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(_inputTextView.h + changeInHeight);
    }];
    
    
//    self.inputTextView.contentInset = UIEdgeInsetsMake((numLines >= 6 ? 4.0f : 0.0f),
//                                                       0.0f,
//                                                       (numLines >= 6 ? 4.0f : 0.0f),
//                                                       0.0f);
//    
//
//    if (numLines >= 6) {
//        CGPoint bottomOffset = CGPointMake(0.0f, self.inputTextView.contentSize.height - self.inputTextView.h);
//        [self.inputTextView setContentOffset:bottomOffset animated:YES];
//        [self.inputTextView scrollRangeToVisible:NSMakeRange(self.inputTextView.text.length - 2, 1)];
//    }
}
#pragma mark - Action
- (IBAction)messageStyleButtonClicked:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
        {
            sender.selected = !sender.selected;
            if (sender.selected) {
                [self.inputTextView resignFirstResponder];
            } else {
                [self.inputTextView becomeFirstResponder];
            }
            if ([self.delegate respondsToSelector:@selector(didSendFaceAction:)]) {
                [self.delegate didSendFaceAction:sender.selected];
            }
            break;
        }
        case 2:
        {
            if ([self.delegate respondsToSelector:@selector(didSendTextAction:)]) {
                [self.delegate didSendTextAction:_inputTextView.text];
            }
            break;
        }
        default:{
            //选择图片
            if ([self.delegate respondsToSelector:@selector(didSendImageAction)]) {
                [self.delegate didSendImageAction];
            }
        }
            break;
    }
}
+ (CGFloat)textViewLineHeight {
    return 36.0f; // for fontSize 16.0f
}

+ (CGFloat)maxLines {
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 3.0f : 8.0f;
}

+ (CGFloat)maxHeight {
    return ([MessageInputView maxLines] + 1.0f) * [MessageInputView textViewLineHeight];
}
#pragma mark - Text view delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
        [self.delegate inputTextViewWillBeginEditing:self.inputTextView];
    }
    _faceButton.selected = NO;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView becomeFirstResponder];
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:self.inputTextView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if ([text isEqualToString:@"\n"]) {
//        if ([self.delegate respondsToSelector:@selector(didSendTextAction:)]) {
//            [self.delegate didSendTextAction:textView.text];
//        }
//        return NO;
//    }
    return YES;
}

@end
