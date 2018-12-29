//
//  MessageInputView.h
//  BKMobile
//
//  Created by 薇 颜 on 15/6/24.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageTextView.h"

@protocol MessageInputViewDelegate <NSObject>

@required

/**
 *  输入框刚好开始编辑
 *
 *  @param messageInputTextView 输入框对象
 */
- (void)inputTextViewDidBeginEditing:(ChatMessageTextView *)messageInputTextView;

/**
 *  输入框将要开始编辑
 *
 *  @param messageInputTextView 输入框对象
 */
- (void)inputTextViewWillBeginEditing:(ChatMessageTextView *)messageInputTextView;

@optional

/**
 *  发送文本消
 *
 *  @param text 目标文本消息
 */
- (void)didSendTextAction:(NSString *)text;

/**
 *  发送第三方表情
 *
 *  @param sendFace 目标表情的本地路径
 */
- (void)didSendFaceAction:(BOOL)sendFace;


/**
 选择相册或者拍照
 */
- (void)didSendImageAction;

@end

@interface MessageInputView : UIView


@property (nonatomic, weak) id <MessageInputViewDelegate> delegate;

/**
 *  用于输入文本消息的输入框
 */
@property (nonatomic, strong) ChatMessageTextView *inputTextView;
/**
 *  动态改变高度
 *
 *  @param changeInHeight 目标变化的高度
 */
- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight;


/**
 *  获取最大行数
 *
 *  @return 返回最大行数
 */
+ (CGFloat)maxLines;

/**
 *  获取根据最大行数和每行高度计算出来的最大显示高度
 *
 *  @return 返回最大显示高度
 */
+ (CGFloat)maxHeight;
@end
