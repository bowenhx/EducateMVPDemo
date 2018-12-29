/**
 -  BKBaseSendThemeViewController.h
 -  BKHKAPP
 -  Created by ligb on 2017/8/22.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：发布帖子页面
 */

#import "EKBaseViewController.h"
#import "BKBaseSendThemeViewController.h"
#import "BKSendThemePresenter.h"
#import "BKFooterFacerView.h"
#import "BKFaceManage.h"
#import "EmojiTextAttachment.h"
#import "BKFaceView.h"

typedef NS_ENUM(NSUInteger, BKSendThemeViewType) {
    BKSendThemeView,        //发帖
    BKSendRevertView,       //回复/ 跟帖/ 引用
    BKSendReportView        //举报
};



@interface BKBaseSendThemeViewController : EKBaseViewController <UITextFieldDelegate>
@property (nonatomic) BKSendThemeViewType vTypeView;

@property (nonatomic, strong) BKSendThemePresenter      *vPresenter;        //presenter 对象
@property (weak, nonatomic) IBOutlet UIScrollView       *vScrollView;
@property (weak, nonatomic) IBOutlet UIButton           *vSortButton;       //分类
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vSortViewHeight;   //控制分类高度
@property (weak, nonatomic) IBOutlet UITextField        *vTextField;
@property (weak, nonatomic) IBOutlet UIImageView        *vIndicatorImg;     //举报后面箭头标识
@property (weak, nonatomic) IBOutlet UITextView         *vTextView;
@property (weak, nonatomic) IBOutlet UILabel            *vTextFieldLabel;
@property (weak, nonatomic) IBOutlet UILabel            *vTextViewLabel;
@property (weak, nonatomic) IBOutlet UILabel            *vTextFieldNumber;
@property (weak, nonatomic) IBOutlet UILabel            *vTextViewNumber;
@property (weak, nonatomic) IBOutlet UIButton           *vReportButton;
@property (weak, nonatomic) IBOutlet UIView             *vPhotoView;
@property (nonatomic, strong) BKFooterFacerView         *vFooterView;//表情view
@property (nonatomic, strong) UIButton                  *vPhotoBtn; //添加照片btn
@property (nonatomic, strong) NSMutableArray            *vAssets;//照片数据源


@property (nonatomic, copy) NSString *vTitle;  //标题
@property (nonatomic, copy) NSString *vPassword;
@property (nonatomic, copy) NSString *vTid;    //主题id
@property (nonatomic, copy) NSString *vFid;
@property (nonatomic, copy) NSString *vRepid; // 回复楼层id
@property (nonatomic, copy) NSArray  *vThreadtypes; //有分类主题
@property (nonatomic, copy) NSArray  *reportArray; //就举报理由
@property (nonatomic, assign) BOOL   vIsquote; //判断是回复还是引用回复

//选择分类
- (void)mSelectThemeSort;
//选择举报理由
- (void)mSelectReport;
//添加图片
- (void)mAddPhotosImage;

//textView 显示表情处理
- (void)smileyUpdataUrl:(NSString *)face img:(UIImage *)img rang:(NSRange)rang insert:(BOOL)isInsert;
@end
