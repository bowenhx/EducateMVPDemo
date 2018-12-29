/**
 -  BKFaceManage.m
 -  BKHKAPP
 -  Created by ligb on 2017/8/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BKFaceManage.h"
#import "SmiliesModel.h"

NSString *const BKHKSmiley = @"EKSmiley";

@implementation BKFaceManage

+ (BKFaceManage *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

//根据表情代码，返回本地表情图片
- (UIImage *)mCoreImageRuleMate:(NSString *)str{
    __block UIImage *image;
    
    [self.vSmiliesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        SmiliesModel *model = (SmiliesModel *)obj;
        if ([str isEqualToString:model.search] || [model.replace hasSuffix:str]) {
            *stop = true;
            image = [UIImage imageWithContentsOfFile:model.replace];
            return ;
        }
        
    }];
    
    return image;
}
//根据表情代码，返回本地表情路径
- (NSString *)mCoreImagePath:(NSString *)str{
    __block NSString *path = @"";
    
    [self.vSmiliesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        SmiliesModel *model = (SmiliesModel *)obj;
        
        if ([str isEqualToString:model.search]) {
            *stop = true;
            
            path = model.replace;
            return ;
        }
        
    }];
    
    return path;
}
//把相对应的表情替换成本地路径地址
///////////////////////////////////default////////////////////////////////////////////////////////////////
- (NSString *)libraryDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

- (NSMutableArray *)vSmiliesArray{
    if ( !_vSmiliesArray ) {
        _vSmiliesArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        //获取表情本地文件（数组）
        NSArray *smiley = [BKSaveData readArrayByFile:kSmileyKey];
        [smiley enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *items = obj[@"items"];
            
            //文件夹名字
            NSString *fileName = obj[@"directory"];
            
            [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSString *replace = obj[@"replace"];
                NSRange range = [replace rangeOfString:[NSString stringWithFormat:@"%@/",fileName]];
                replace = [replace substringFromIndex:range.location];
                
                NSString *path = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] pathForResource:BKHKSmiley ofType:@"bundle"],replace];
                
                //封装成对象，便于获取
                SmiliesModel *model = [[SmiliesModel alloc] init];
                model.search = obj[@"search"];
                model.replace = path;
                [_vSmiliesArray addObject:model];
            }];
            
            
        }];
        
    }
    return _vSmiliesArray;
    
}

@end


