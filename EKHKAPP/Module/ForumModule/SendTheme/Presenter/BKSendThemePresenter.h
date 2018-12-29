//
//  BKSendThemePresenter.h
//  BKHKAPP
//
//  Created by ligb on 2017/8/24.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//  说明：管理发帖的present 类，
//       充分处理发帖类的各种数据操作逻辑，为发帖减轻代码复杂度，及达到逻辑与业务解耦合的目的

#import <Foundation/Foundation.h>
#import <BKSDK/BKSDK.h>
#import "BKSendThemeProtocol.h"

static const NSInteger kSendThemeTextFieldNumberMaxLength       = 40;
static const NSInteger kSendThemeTextViewNumberMaxLength        = 800;
static const NSInteger kSendThemeTextViewNumberMinLength        = 200;
static const NSInteger kSendThemeSelectPhotosCount              = 9;

typedef NS_ENUM(NSUInteger, BKSendThemeDataType) {
    BKSendSubThemeData, //发布帖子
    BKSendThemeData,    //发布主题
    BKSendReleaseData,  //跟帖 / 回复 / 引用
    BKSendReportData    //举报帖子
};

@interface BKSendThemePresenter : NSObject

@property (nonatomic, weak) id<BKSendThemeProtocol> vProtocol;




/**
 发布主题

 @param params 携带的参数
 @param files 发布的图片文件
 @param precentBlock 进度回调
 @param handler 完成回调
 */
- (void)mSendThemeTypeURL:(NSString *)url param:(NSDictionary *)params
             files:(NSArray *)files
           precent:(void(^)(float precent))precentBlock
           handler:(void(^)(NSString *message, BOOL status))handler ;


/**
 获取举报理由数据
 */
- (void)getReportMessage;


/**
 發佈舉報理由

 @param params 參數數據
 @param handler 回調
 */
- (void)mSendReport:(NSDictionary *)params
            handler:(void(^)(NSString *message, BOOL status))handler;

/**
 编辑主题标题字数变化处理

 @param textField textFiled 标题
 @param labNum 字数label
 */
- (void)mChangeTextFieldString:(UITextField *)textField
                     actionNum:(UILabel *)labNum;


/**
 编辑内容字数变化处理

 @param textView textView 内容
 @param type 发布类型
 @param placeLab 默认显示文字
 @param labNum 字数label
 */
- (void)mCHangeTextViewString:(UITextView *)textView
                     viewType:(BKSendThemeDataType)type
                     placehol:(UILabel *)placeLab
                    actionNum:(UILabel *)labNum;


/**
 照片放大查看编辑等

 @param controller 当前控制器
 @param photos 照片数组 包含有相机拍照对象<ZLCamera>, 照片库选择对象<ZLPhotoAssets>，两种类型
 @param index 当前选中的照片index
 */
- (void)mScanPhotoPickerView:(UIViewController *)controller
                      photos:(NSArray *)photos
                       index:(NSInteger)index;
/**
 选择相册

 @param controller 当前控制器
 @param photos 传入已经选中的相片数据，可以标记哪些是已经选中的
 @param assets 返回选中的照片数组 包含有相机拍照对象<ZLCamera>, 照片库选择对象<ZLPhotoAssets>，两种类型
 */
- (void)mSelectZLPhotoPickerView:(UIViewController *)controller
                          photos:(NSArray *)photos
                          assets:(void(^)(NSArray *photos))assets;


/**
 选择相机拍照

 @param controller 当前控制器
 */
- (void)mSelectImagePickerView:(UIViewController *)controller;




/**
 删除不需要保存帖子信息

 @param fid 主题fid
 @param tid 帖子tid
 */
- (void)mRemovePhotoFid:(NSString *)fid tid:(NSString *)tid;



/**
 保存编辑帖子草稿信息

 @param fid 主题fid
 @param tid 帖子tid
 @param assets 图片模型数据
 @param textField 标题field
 @param textView 内容view
 */
- (void)mSaveSendThemeData:(NSString *)fid
                       tid:(NSString *)tid
                     photo:(NSArray *)assets
                 textField:(UITextField *)textField
                  textView:(UITextView *)textView;

@end
