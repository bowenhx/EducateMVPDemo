/**
 -  BKSendThemePhotos.m
 -  BKHKAPP
 -  Created by ligb on 2017/9/6.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BKSendThemePhotos.h"
#import "BKUserHelper.h"

@interface BKSendThemePhotos ()
@property (nonatomic , strong) NSMutableArray *photos;
@property (nonatomic , strong) ALAssetsLibrary *assets;
@property (nonatomic , assign) NSInteger count;
@property (nonatomic , strong) dispatch_queue_t queue;
@property (nonatomic , strong) dispatch_group_t group;
@end

@implementation BKSendThemePhotos

- (ALAssetsLibrary *)assets{
    if (!_assets) {
        _assets = [[ALAssetsLibrary alloc] init];
    }
    return _assets;
}
- (NSMutableArray *)photos{
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}
- (dispatch_queue_t)queue{
    if (!_queue) {
        _queue = dispatch_queue_create("com.photos", NULL);
    }
    return _queue;
}
- (dispatch_group_t)group{
    if (!_group) {
        _group = dispatch_group_create();
    }
    return _group;
}
- (void)photosAssets:(NSArray *)images block:(void(^)(NSArray *photos))block{
    //    @WeakObj(self);
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *path = obj;
        if ([path hasPrefix:@"assets"]) {
            NSURL *url = [NSURL URLWithString:path];
            dispatch_group_async(self.group, self.queue, ^{
                //根据路径获取系统相册中的图片，并封装成对象
                [self.assets assetForURL:url resultBlock:^(ALAsset *asset) {
                    ZLPhotoAssets *photoAssets = [[ZLPhotoAssets alloc] init];
                    photoAssets.asset = asset;
                    photoAssets.thumbImage = [UIImage imageWithCGImage:[asset thumbnail]];
                    photoAssets.originImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                    photoAssets.assetURL = [[asset defaultRepresentation] url];
                    
                    ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
                    photo.asset = photoAssets;
                    [self.photos addObject:photo];
                } failureBlock:^(NSError *error) {
                    
                }];
            });
        }else {
            dispatch_group_async(self.group, self.queue, ^{
                ZLPhotoAssets *assets = [[ZLPhotoAssets alloc] init];
                NSString *imgUrl = [BKUserHelper getImagePath:path];
                UIImage *img = [UIImage imageWithContentsOfFile:imgUrl];
                assets.originImage = img;
                assets.assetURL = [NSURL URLWithString:path];
                ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
                photo.asset = assets;
                photo.photoImage = img;
                [self.photos addObject:photo];
            });
        }
    }];
    
    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^(){
        block (self.photos);
    });
    
}
- (void)photosAssets:(NSArray *)images{
    __weak typeof(self) bself = self;
    if (_count < images.count) {
        NSString *path = images[_count];
        if ([path hasPrefix:@"assets"]) {
            NSURL *url = [NSURL URLWithString:path];
            //根据路径获取系统相册中的图片，并封装成对象
            [bself.assets assetForURL:url resultBlock:^(ALAsset *asset) {
                ZLPhotoAssets *photoAssets = [[ZLPhotoAssets alloc] init];
                photoAssets.asset = asset;
                photoAssets.thumbImage = [UIImage imageWithCGImage:[asset thumbnail]];
                photoAssets.originImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                photoAssets.assetURL = [[asset defaultRepresentation] url];
                
                ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
                photo.asset = photoAssets;
                [bself.photos addObject:photo];
                _count ++;
                //这样写防止取出图片位置错乱
                [bself photosAssets:images];
            } failureBlock:^(NSError *error) {
                
            }];
        }else {
            ZLPhotoAssets *assets = [[ZLPhotoAssets alloc] init];
            NSString *imgUrl = [BKUserHelper getImagePath:path];
            UIImage *img = [UIImage imageWithContentsOfFile:imgUrl];
            assets.originImage = img;
            assets.assetURL = [NSURL URLWithString:path];
            ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
            photo.asset = assets;
            photo.photoImage = img;
            [bself.photos addObject:photo];
            _count ++;
            //这样写防止取出图片位置错乱
            [bself photosAssets:images];
        }
        
    }else{
        if (_photosAssets) {
            _photosAssets (_photos);
        }
    }
    
}
- (void)editLoadImage:(NSArray *)urls block:(void (^)(NSArray *photos))block{
    NSInteger count = urls.count;
    for (int i = 0; i< count ; i++) {
        dispatch_sync(self.queue, ^{
            NSURL *url = [NSURL URLWithString:urls[i]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    ZLPhotoAssets *assets = [[ZLPhotoAssets alloc] init];
                    assets.originImage = image;
                    //根据保存的路径获取拍照存储对象
                    ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
                    photo.asset = assets;
                    photo.photoImage = image;
                    [self.photos addObject:photo];
                }
            }] resume];
            
        });
        if (i == count - 1) {
            sleep(2);
        }
    }
    
    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^(){
        block (self.photos);
    });
    
}
- (void)loadImage:(NSArray *)urls{
    __weak typeof(self) bself = self;
    if (_count < urls.count) {
        NSURL *url = [NSURL URLWithString:urls[_count]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                ZLPhotoAssets *assets = [[ZLPhotoAssets alloc] init];
                assets.originImage = image;
                //根据保存的路径获取拍照存储对象
                ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
                photo.asset = assets;
                photo.photoImage = image;
                [bself.photos addObject:photo];
            }
            _count ++;
            //这样写防止取出图片位置错乱
            [bself loadImage:urls];
        }] resume];
    }else{
        if (_photosAssets) {
            _photosAssets (_photos);
        }
    }
}

+ (NSArray *)uploadingImageFiles:(NSArray *)files
{
    NSMutableArray *imageArr = [NSMutableArray arrayWithCapacity:files.count];
    
    [files enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *image = nil;
        if ([obj isKindOfClass:[ZLPhotoPickerBrowserPhoto class]]) {
            ZLPhotoPickerBrowserPhoto *photo = (ZLPhotoPickerBrowserPhoto *)obj;
            ZLPhotoAssets *asset = photo.asset;
            if (asset && [asset isKindOfClass:[ZLPhotoAssets class]]) {
                image = asset.originImage;
            }else {
                image = photo.photoImage;
            }
            
            if (image) {
                NSString *name = [NSString stringWithFormat:@"attach%lu",(unsigned long)++idx];
                [imageArr addObject:@[name , image]];
            }
        }
    }];
    return imageArr;
}

@end
