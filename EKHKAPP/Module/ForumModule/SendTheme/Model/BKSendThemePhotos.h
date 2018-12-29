/**
 -  BKSendThemePhotos.h
 -  BKHKAPP
 -  Created by ligb on 2017/9/6.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：
 */

#import <Foundation/Foundation.h>

@interface BKSendThemePhotos : NSObject

@property (nonatomic , copy)void(^photosAssets)(NSArray <ZLPhotoPickerBrowserPhoto *>*photo);

//处理本地保存草稿时的缓存返回block
- (void)photosAssets:(NSArray *)images;
- (void)photosAssets:(NSArray *)images block:(void(^)(NSArray *photos))block;
//处理重新编辑帖子时拿到网络url返回block
- (void)loadImage:(NSArray *)urls;
- (void)editLoadImage:(NSArray *)urls block:(void (^)(NSArray *photos))block;

+ (NSArray *)uploadingImageFiles:(NSArray *)files;
@end
