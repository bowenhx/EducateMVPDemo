//
//  BKSendThemeProtocol.h
//  BKHKAPP
//
//  Created by ligb on 2017/8/24.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKReportModel.h"

@protocol BKSendThemeProtocol <NSObject>

- (void)mGetReportMessage:(NSArray<BKReportModel *> *)array;

- (void)mRemovePhotoItem:(NSInteger)index;

- (void)mAddAssetsImage:(ZLPhotoPickerBrowserPhoto *)image;

//- (void)mPrecentNum:(float)precent;
//
//- (void)mSendThemeStatus:(NSInteger)status message:(NSString *)message;

@end
