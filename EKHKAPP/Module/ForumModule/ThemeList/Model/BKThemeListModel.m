/**
 -  BKThemeListModel.m
 -  BKHKAPP
 -  Created by HY on 2017/8/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BKThemeListModel.h"
#import "BKThemeListDataModel.h"

@implementation BKThemeListModel

#pragma mark - 拦截到message字段，做特殊处理
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
   
    //label上添加图片，富文本判断
    NSString *timestamp = dic[@"subject"];
    if ([timestamp isKindOfClass:[NSString class]]) {

        self.subject = timestamp;
        
        NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
        NSString *imageStr;
        
        //Top：标示置顶的
        if (self.displayorder != 0) {
            imageStr = @"Top.png";
            [imageArray addObject:imageStr];
        }
        
        //Hot：标示火热的
        if (self.heats >= 200) {
            imageStr = @"Hot.png";
            [imageArray addObject:imageStr];
        }
        
        //Fine：标示精选的
        if (self.digest != 0) {
            imageStr = @"Fine.png";
            [imageArray addObject:imageStr];
        }
        
        //Fig：标示有图的
        if (self.attachment == 2) {
            imageStr = @"Fig.png";
            [imageArray addObject:imageStr];
        }
        
        //Lock：标示带锁的
        if (self.closed == 1) {
            imageStr = @"Lock.png";
            [imageArray addObject:imageStr];
        }
        
        //1:先赋值纯文字
        NSMutableAttributedString *subjectStr = [[NSMutableAttributedString alloc] initWithString:self.subject];

        //2：如果这个帖子标题含有富文本图片，则遍历，往label上添加图片
        if (imageArray.count > 0) {
            for (int i = 0; i < imageArray.count; i++) {
                UIImage *image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
                //1:创建NSTextAttachment的对象，用来装在图片
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                attch.image = image;
                attch.bounds = CGRectMake(0, -4, image.size.width, image.size.height);
                //2:用attributedStringWithAttachment:attch方法，将图片添加到富文本上
                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                
                [subjectStr insertAttributedString:string atIndex:i];
            }
        }
        
        //设置段落样式 使用NSMutableParagraphStyle类
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 4;  //行自定义行高度
        
        //给可变的属性字符串 添加段落格式
        [subjectStr addAttribute: NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.subject length])];
        
        self.attributeString = subjectStr;
    }
    return YES;
}


//网络请求，主题列表
- (void)mRequestThemeListWithPage:(NSInteger)page fid:(NSString *)fid order:(NSString *)order typeId:(NSInteger)typeId password:(NSString *)password callBack:(void (^)(NSInteger status, BKThemeListDataModel *dataModel, NSString *error))callBack {

    if (fid == nil) {
        fid = @"";
    }
    
    if (order == nil) {
        order = @"";
    }
    
    if (password == nil) {
        password = @"";
    }
    
    NSDictionary *parameter = @{
                           @"token" : TOKEN,
                           @"page"  : @(page),
                           @"fid"   : fid,
                           @"order" : order,
                           @"typeid": @(typeId),
                           @"pw" : password
                           };
    [EKHttpUtil mHttpWithUrl:kThemeListURL parameter:parameter response:^(BKNetworkModel *model, NSString *netErr) {
        if (netErr) {
            callBack(0, nil, netErr);
        } else {
            if (model.status == 1) {
                BKThemeListDataModel *dataModel = [BKThemeListDataModel yy_modelWithDictionary:model.data];
                    callBack(1, dataModel, nil);
            } else {
                callBack(model.status, nil, model.message);
            }
        }
    }];
}

@end
