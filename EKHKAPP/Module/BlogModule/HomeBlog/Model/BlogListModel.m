/**
 -  BlogListModel.h
 -  EKHKAPP
 -  Created by HY on 2017/9/7.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：某一个分类下的，日志列表模型
 */

#import "BlogListModel.h"

static CGFloat BLOG_CELL_HEIGHT = 65; //日志列表，除了动态变化的message高度，剩余的cell固定高度

@implementation BlogListModel

#pragma mark - 拦截到message字段，做特殊处理
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *timestamp = dic[@"message"];
    if ([timestamp isKindOfClass:[NSString class]]) {
        CGRect rect = [timestamp boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 74 , 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
        self.vHeight = rect.size.height + BLOG_CELL_HEIGHT;
    }
    return YES;
    
}

#pragma mark - “最新日志/推荐日志” 列表
+ (void)mRequestBlogListWithId:(NSString *)catid order:(NSString *)order page:(NSInteger)page block:(void(^) (NSArray *data , NSString *netErr))block {
 
    NSMutableDictionary *dicParameter = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParameter setValue:TOKEN forKey:@"token"];
    [dicParameter setValue:catid forKey:@"catid"];
    [dicParameter setValue:order forKey:@"order"];
    [dicParameter setValue:@(page) forKey:@"page"];
    
    [EKHttpUtil mHttpWithUrl:kBlogListURL parameter:dicParameter response:^(BKNetworkModel *model, NSString *netErr) {
        if ( netErr ) {
            block (nil, netErr);
        } else {
            if (model.status == 1) {
                NSMutableArray <BlogListModel *> *tempArray = [NSMutableArray array];
                for (NSDictionary *dictionary in model.data[@"lists"]) {
                    [tempArray addObject:[BlogListModel yy_modelWithDictionary:dictionary]];
                }
                block (tempArray, nil);
            } else if (model.status == 0){
                block (nil, NOT_DATA_MESSAGE);
            } else {
                block (nil, netErr);
            }
        }
    }];
}


#pragma mark - 我的日誌列表
+ (void)mRequestMyBlogListWithPage:(NSInteger)page block:(void(^) (NSArray *data , NSString *netErr))block {
    
    NSMutableDictionary *dicParameter = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParameter setValue:TOKEN forKey:@"token"];
    [dicParameter setValue:USERID forKey:@"uid"];
    [dicParameter setValue:@(page) forKey:@"page"];
    
    [EKHttpUtil mHttpWithUrl:kBlogMyURL parameter:dicParameter response:^(BKNetworkModel *model, NSString *netErr) {
        if ( netErr ) {
            block (nil, netErr);
        } else {
            if (model.status == 1) {
                NSMutableArray <BlogListModel *> *tempArray = [NSMutableArray array];
                for (NSDictionary *dictionary in model.data[@"lists"]) {
                    [tempArray addObject:[BlogListModel yy_modelWithDictionary:dictionary]];
                }
                block (tempArray, nil);
            } else {
                block (nil, model.message);
            }
        }
    }];
}

@end
