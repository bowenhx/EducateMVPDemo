/**
 -  BlogTypeModel.m
 -  EKHKAPP
 -  Created by HY on 2017/11/1.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：日志的所有小分类
 */

#import "BlogTypeModel.h"

@implementation BlogTypeModel


#pragma mark - 编码
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

#pragma mark - 解码
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}



+ (void)mRequestBlogTypeListBlock:(void(^) (NSArray *data , NSString *netErr))block {
    [EKHttpUtil mHttpWithUrl:kBlogTypeURL parameter:@{@"token" : TOKEN} response:^(BKNetworkModel *model, NSString *netErr) {
        if ( netErr ) {
            block (nil, netErr);
        } else {
            if (model.status == 1) {
                NSMutableArray <BlogTypeModel *> *tempArray = [NSMutableArray array];
                for (NSDictionary *dictionary in model.data) {
                    [tempArray addObject:[BlogTypeModel yy_modelWithDictionary:dictionary]];
                }
                block (tempArray, nil);
                
                NSData *objData = [NSKeyedArchiver archivedDataWithRootObject:tempArray];
                [BKSaveData writeDataToFile:objData fileName:SAVE_BLOG_TYPE];
                
//
//                //保存分类对象
//                NSData *objData = [NSKeyedArchiver archivedDataWithRootObject:tempArray];
//                //创建分类对象的路径
//                NSString *path = [BKTool getLibraryDirectoryPath:SAVE_BLOG_TYPE];
//                //把数据写入文件
//                if ([objData writeToFile:path atomically:YES]) {
//                    NSLog(@"Write File Cusseece");
//                }
                
                
            } else {
                block (nil, model.message);
            }
        }
    }];
}

@end
