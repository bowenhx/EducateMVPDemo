/**
 - BKMobile
 - BTextKit.h
 - Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
 - Created by Kevin Tung on 15/7/22.
 - 说明：该类是coreText 模型类；主要处理帖子详情中图文混排显示等；还涉及到编辑帖子中的图文混排的处理
 */



/**
 存储图片路劲
 @param NSDocumentDirectory 系统document
 @param NSUserDomainMask    
 @param YES

 @return 缓存路径
 */
#define BTKDoc NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject

//定义回复颜色背景值
#define BTKRevertColor  @"#f1f1f1"
//定义回复文字色值
#define BTKRevertTextColor @"#000000"


///拼接缓存路径
#define BTKCacheFolder [BTKDoc stringByAppendingPathComponent:@"BTextKitImgCache"]
#define BTKDiskCacheCountLimit 50
///缓存时间
#define BTKDiskCacheAgeLimit 3600*24*7


///缓存极限
#define BTKCacheCountLimit 20
#define BTKCacheCostLimit 0


//最大图片最大length
#define MAX_IMAGEDATA_LEN       60000.0

//default image
#define BTKLoading @"icon_loading"


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>


typedef void(^dImgBlock)(NSAttributedString *aString, CGSize size, NSArray *smileyArr, NSUInteger tag);


@interface BTextKit : NSObject <NSCacheDelegate>

@property (nonatomic) CGFloat fontSize;
@property (nonatomic) CGFloat width;
@property (nonatomic) NSUInteger tag;
@property (nonatomic, readonly, getter=usedSize) CGSize size;

@property (nonatomic, strong, setter=setString:) NSString *string;
@property (nonatomic, strong) NSMutableAttributedString *mAString;

@property (nonatomic, strong) NSMutableArray *imageInfo;
@property (nonatomic, strong) NSMutableArray *smileyInfo;



/*
 @warning Ensure the UITextView.textContainerInset = UIEdgeInsetsZero, scrollEnabled = NO,
 return instance
 @param setStr      html string
 @param shouldWith  textView width
 @param setFontSize fontOfSize
 */
- (instancetype)initWithString:(NSString *)setStr shouldWidth:(CGFloat)shouldWith fontSize:(CGFloat)setFontSize;


/**
 @append gif smiley to view(UITextview)
 @param  view: it's a uitextview or uilabel
 */
+ (void)appendGIF:(UIView *)view list:(NSArray *)gifList;


/*
 download remote images, and back with block, @2x support
 @param completion      block, maybe reset textview's textStorage and frame;
 */
- (void)downloadImages:(dImgBlock)completion;

//清理图片缓存
+ (BOOL)cleanImageData;

@end




@interface NSTextAttachment(BTKAttachment)

@property (nonatomic, strong) NSString *imageURL;

- (instancetype)initWithImageURL:(NSString *)url;

@end


