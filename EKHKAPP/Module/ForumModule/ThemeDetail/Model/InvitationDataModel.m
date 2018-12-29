//
//  InvitationDataModel.m
//  BKMobile
//
//  Created by Guibin on 15/8/3.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "InvitationDataModel.h"
#import "BTextKit.h"
#import "BADBannerView.h"
#import "EKADViewController.h"

#define INVITATION_TEXT_WIDTH  (SCREEN_WIDTH - 8 * 2)
#define COMMENT_TEXT_WIDTH  ((SCREEN_WIDTH - 8 * 3) - 40)


@implementation InvitationDataModel
- (void)dealloc{
//   _delegate = nil;
}
+ (id)uniteData:(NSArray *)dataSource adViews:(NSArray *)adViews delegate:(id)delegate {
    
    NSMutableArray *arrData = [NSMutableArray arrayWithCapacity:0];

    __block NSInteger i = 0;
    //add floor && insert ads
    [dataSource enumerateObjectsUsingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL *stop) {
        //add post
        InvitationDataModel *message = [[InvitationDataModel alloc] init];
        message.delegate = delegate;
        message.tag = idx;
        [message setValuesForKeysWithDictionary:obj];
        //标记主题背景色
        if (idx % 2 == 0) {
            message.cellColor = 0;
        }else{
            message.cellColor = 1;
        }
        [arrData addObject:message];
        
        if ( idx && idx % kADSpace == 0 ) {
            if ( adViews.count > i ) {//判断广告view 大于要取的 row
                InvitationDataModel *adMeg = [[InvitationDataModel alloc] init];
                BADBannerView *bannerView = (BADBannerView *)adViews[i];
                adMeg.typeView = bannerView;
                adMeg.viewHeight = bannerView.vBannerHeight;
                adMeg.tag = TAG_VIEW;
                [arrData addObject:adMeg];
                i ++;
            }
        }
        
        if (i == adViews.count) i = 0;
        
    }];
    return arrData;
}



- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    
    self.lzWidth = 200;
    
    if (self.first == 1) {
        self.lzWidth = [self autoSizeWidth:self.author];

        [BModelData sharedInstance].lzWidth = self.lzWidth;
        [BModelData sharedInstance].author = self.author;
    }
    
    if ([key isEqualToString:@"message_tag"]) {
        self.message_tag = [self stringByOfString:value];
        [self textImageManage:self];
    }
    
    if ([key isEqualToString:@"avatar"]) {
        self.avatar = [NSString stringWithFormat:@"%@&random=%d",value,arc4random_uniform(1000)];
    }
    
    if (self.commentcount == 0) {
        self.restHeight = 80;
    }else{
        //设置除了帖子内容高度外，其他view 所占的高度值
        self.restHeight = 105;
    }
    
    if (self.authortitle && self.credits) {
        self.uniteAutor = [NSString stringWithFormat:@"生產值：%zd    %@",self.credits, self.authortitle];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}
- (NSMutableArray *)imgUrls{
    if (!_imgUrls) {
        _imgUrls = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _imgUrls;
}
- (NSMutableArray *)linkImgs {
    if (!_linkImgs) {
        _linkImgs = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _linkImgs;
}

- (NSString *)stringByOfString:(NSString *)message{
    
    NSRange ranggLink = [message rangeOfString:@"[img][iosimglink]"];
    if ( ranggLink.location != NSNotFound ) {
        //以[img][link]为间隔获取点击图片跳链接的数组
        NSArray *imageURLs = [message componentsSeparatedByString:@"[img][iosimglink]"];
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:imageURLs.count];
        
        NSMutableArray *currArray = [NSMutableArray arrayWithArray:imageURLs];
        
        //先截取出前面可能是空的或者文字之类的，然后，截取出link放入到数组中，然后截取出图片，放入数组中，把剩下的链接再次循环
        
        for (int i = 0; i < imageURLs.count; i ++) {
            
            NSString *str = [currArray objectAtIndex:i];
            
            if ([str hasPrefix:@"http"]) {
                
                //分割字符串，分为两个元素
                NSArray *tempLink = [str componentsSeparatedByString:@"[/iosimglink]"];
                
                //1:截取出图片点击的链接
                NSString *imageTouchLink = tempLink.firstObject;
                
                //2:截取出图片的地址
                NSString *tempStr = tempLink.lastObject;
                //截取后，前面是图片地址，后面可能还跟着文字之类的内容
                NSArray *tempImage = [tempStr componentsSeparatedByString:@"[/img]"];
                NSString *imageUrl = tempImage.firstObject;
                
                //3:把链接和图片放入到数组中
                [self.linkImgs addObject:@[imageTouchLink,imageUrl]];
                
                //4:在这里，要把当前str去掉点击图片链接后，把图片地址和剩下的文字都放入到items中去
                [items addObject:[tempLink objectAtIndex:1]];

            }else{
                [items addObject:str];
            }
            
        }
        message = [items componentsJoinedByString:@"[img]"];
    }
    
    if ([BKTool isStringBlank:message]) return @"";
    if ([message hasSuffix:@"\n"]) {
        return message;
    }else{
        message = [message stringByAppendingString:@"\n"];
        return message;
    }
   
}

//计算帖子作者的名字宽度
- (CGFloat)autoSizeWidth:(NSString *)string
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(150, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    return rect.size.width+2;
}

- (void)textImageManage:(InvitationDataModel *)model
{
    float font = [BModelData sharedInstance].font;
    BTextKit *textKit = [[BTextKit alloc] initWithString:model.message_tag shouldWidth:INVITATION_TEXT_WIDTH fontSize:font];
    CGSize tSize = textKit.usedSize;
    textKit.tag = model.tag;
   
    [model addMutableAttributedData:@{@"attString" : textKit.mAString,
                                        @"imgUrls" : textKit.imageInfo,
                                        @"smileys" : textKit.smileyInfo,
                                          @"width" : @(tSize.width),
                                         @"height" : @(tSize.height)}];
    
    __weak typeof(self) bself = self;
    [textKit downloadImages:^(NSAttributedString *attString, CGSize currentSize, NSArray *smileyInf, NSUInteger tag) {
        if (bself.delegate && [bself.delegate respondsToSelector:@selector(updataTextViewData:)]) {
            [bself.delegate updataTextViewData:@{@"attString" : attString,
                                                     @"width" : @(currentSize.width),
                                                    @"height" : @(currentSize.height),
                                                       @"tag" : @(tag)}];
        }
    }];
    
  
    
}

- (void)addMutableAttributedData:(NSDictionary *)dict
{
    self.attString  = dict[@"attString"];
    self.smileyInf  = dict[@"smileys"];
    self.viewHeight = [dict[@"height"] floatValue];
    self.viewWidth  = [dict[@"width"] floatValue];
    
    NSArray *images = dict[@"imgUrls"];
    [images enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        [self.imgUrls addObject:obj[@"value"]];
    }];
}


@end

@implementation CommentModel
- (void)dealloc{
    _delegate = nil;
}
- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"comment"]) {
        self.comment = [self stringByOfString:value];
        [self textSmileysDataModel:self];
    }
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (NSString *)stringByOfString:(NSString *)message{
    if ([BKTool isStringBlank:message]) return @"";
    if ([message hasSuffix:@"\n"]) {
        return message;
    }else{
        return [message stringByAppendingString:@" \n"];
    }
}

- (void)textSmileysDataModel:(CommentModel *)model
{
    BTextKit *textKit = [[BTextKit alloc] initWithString:model.comment shouldWidth:COMMENT_TEXT_WIDTH fontSize:17.f];

    CGSize tSize = textKit.usedSize;
    textKit.tag      = model.tag;
    
    [model addMutableAttributedData:@{@"attString" : textKit.mAString,
                                        @"smileys" : textKit.smileyInfo,
                                         @"height" : @(tSize.height)}];
    
    
    [textKit downloadImages:^(NSAttributedString *attString, CGSize currentSize, NSArray *smileyInf, NSUInteger tag) {
        if (_delegate) {
            [_delegate updataTextComent:@{@"attString" : attString,
                                             @"height" : @(currentSize.height),
                                                @"tag" : @(tag)
                                            }];
        }
    }];

}
- (void)addMutableAttributedData:(NSDictionary *)dict
{
    self.attString  = dict[@"attString"];
    self.smileyInf  = dict[@"smileys"];
    self.viewHeight = [dict[@"height"] floatValue];
}
@end

@implementation BModelData

+ (BModelData *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    self = [super init];
    if (self) {
        //设置默认字号
        _font = DetailSize_Middle;
        _motifFont = MotifSize_Max;
    }
    return self;
}
@end
