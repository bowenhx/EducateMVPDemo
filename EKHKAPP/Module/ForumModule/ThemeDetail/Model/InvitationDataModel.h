/**
 - BKMobile
 - InvitationDataModel.h
 - Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
 - Created by Guibin on 15/8/3.
 - 说明： 帖子详情model 类，这里主要处理详情数据和广告view，title view的重新组合，这里涉及到帖子详情cell 行高，图文混排中的图片高度代理方法等；
 */

#import "InvitationDataModel.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define TAG_VIEW   9999999

@protocol InvitationDataModelDelegate <NSObject>

- (void)updataTextViewData:(NSDictionary *)dic;

@end

@interface InvitationDataModel : NSObject

@property (nonatomic , weak) id <InvitationDataModelDelegate> delegate;

@property (nonatomic , copy) NSString *avatar;

@property (nonatomic , copy) NSString *author;

@property (nonatomic , copy) NSString *subject;

@property (nonatomic , copy) NSString *dateline;

@property (nonatomic , copy) NSString *message_tag;

@property (nonatomic , copy) NSString *authortitle;

@property (nonatomic , copy) NSString *appinfo;

@property (nonatomic , copy) NSArray *comments;

@property (nonatomic , strong) UIView *typeView;

@property (nonatomic , assign) NSInteger status;

@property (nonatomic , copy) NSString *number; //对应楼层

@property (nonatomic , assign) NSInteger credits;//生成值

@property (nonatomic , assign) NSInteger groupid; //判断会员id 默认会员id = 19

@property (nonatomic , assign) NSInteger isquote;    // 判断是否引用回复

@property (nonatomic , assign) NSInteger first;     //判断是否是楼主

@property (nonatomic , assign) NSInteger tid;  //帖子tid

@property (nonatomic , assign) NSInteger ismoderator;//判断是否是帖子管理员 该字段为后来所加，在data【@"forum"】里面

@property (nonatomic , assign) NSInteger warningnumber;//楼层警告次数

@property (nonatomic , assign) NSInteger iseditenable;//判断帖子编辑权限

@property (nonatomic , assign) NSInteger pid;    // 回复楼层id

@property (nonatomic , assign) NSInteger authorid;    // 用户id

@property (nonatomic , assign) NSInteger commentcount; // 帖子评论数

@property (nonatomic , assign) NSUInteger tag; //标记tag

@property (nonatomic, copy) NSString *useip; /**<用户IP*/

@property (nonatomic, copy) NSString *uniteAutor;//头衔和生产值合并

//定义一个二维数组，用来存放图片的点击链接地址和该图片的url，形式如： [[@"link",@"imgurl"]]
//verson: 3.5版本新增的点击图片可以跳转链接的需求
@property (nonatomic , strong) NSMutableArray *linkImgs;

//新的内容
@property (nonatomic , strong) NSMutableAttributedString *attString;

//图片数据
@property (nonatomic , strong) NSMutableArray *imgUrls;

//表情数据
@property (nonatomic , strong) NSArray *smileyInf;

//内容宽度
@property (nonatomic , assign) float viewWidth;

//内容高度
@property (nonatomic , assign) float viewHeight;

//标记楼层名字的宽度
@property (nonatomic , assign) float lzWidth;

//除textView内容高度外，其他view 的高度
@property (nonatomic , assign) float restHeight;

@property (nonatomic , assign) BOOL cellColor;

/**
 帖子详情数据的重新组合处理

 @param dataSource 详情数据data
 @param adViews 帖子中的广告 view
 @param delegate  delegate 方法
 @return model 数组对象
 */
+ (id)uniteData:(NSArray *)dataSource adViews:(NSArray *)adViews delegate:(id)delegate;

@end


@protocol CommentModelDelegate <NSObject>

- (void)updataTextComent:(NSDictionary *)dict;

@end


//评论Model 类
@interface CommentModel : NSObject

@property (nonatomic , weak)id <CommentModelDelegate> delegate;

@property (nonatomic , assign) NSUInteger tag; //标记tag

@property (nonatomic , copy) NSString *author;

@property (nonatomic , copy) NSString *dateline;

@property (nonatomic , copy) NSString *comment;

@property (nonatomic , copy) NSString *avatar;

//新的内容
@property (nonatomic , strong) NSMutableAttributedString *attString;

//表情数据
@property (nonatomic , strong) NSArray *smileyInf;

//内容高度
@property (nonatomic , assign) float viewHeight;


@end

//主题列表字号
#define MotifSize_Max     (IS_IPAD ? 25 : 19)
#define MotifSize_Middle  (IS_IPAD ? 20 : 17)
#define MotifSize_Small   (IS_IPAD ? 17 : 15)
//帖子详情页面字号
#define DetailSize_Max     (IS_IPAD ? 25 : 25)
#define DetailSize_Middle  (IS_IPAD ? 22 : 20)
#define DetailSize_Small   (IS_IPAD ? 18 : 17)

@interface BModelData : NSObject
+ (BModelData *)sharedInstance;

@property (nonatomic , copy)NSString *author;

@property (nonatomic , assign)float lzWidth;

@property (nonatomic , assign)float font; //帖子字号调整

@property (nonatomic , assign)float motifFont; //主题列表字号调整
@end

