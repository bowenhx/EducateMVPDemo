//
//  BKSendThemePresenter.m
//  BKHKAPP
//
//  Created by ligb on 2017/8/24.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import "BKSendThemePresenter.h"
#import "BKSendThemeModel.h"
#import "NSAttributedString+EmojiExtension.h"
#import "BKUserHelper.h"


@interface BKSendThemePresenter ()<ZLPhotoPickerBrowserViewControllerDelegate,
                                  UIImagePickerControllerDelegate,
                                  UINavigationControllerDelegate>

@property (nonatomic, strong) BKSendThemeModel *vSendModel;
@end

@implementation BKSendThemePresenter

- (instancetype)init {
    if (self = [super init]) {
        _vSendModel = [[BKSendThemeModel alloc] init];
    }
    return self;
}

- (void)mSendThemeTypeURL:(NSString *)url param:(NSDictionary *)params
                    files:(NSArray *)files
                  precent:(void(^)(float precent))precentBlock
                  handler:(void(^)(NSString *message, BOOL status))handler {
    [_vSendModel mSendThemeURL:url param:params files:files precent:^(float precent) {
        precentBlock(precent);
    } block:^(BKNetworkModel *model, NSString *netErr) {
        if (netErr) {
            handler(netErr, 0);
        } else {
            handler(model.message, model.status);
        }
    }];
    
//    NSString *themeURL = @"";
//    if (themeType == BKSendSubThemeData) {
//        themeURL = kPostEditURL;
//    }else if (themeType == BKSendThemeData) {
//        themeURL = kThemePostURL;
//    } else if (themeType == BKSendReleaseData) {
//        themeURL = kPostReleaseURL;
//    } else if (themeType == BKSendReportData) {
//        themeURL = kReportURL;
//        [_vSendModel mSendReportURL:themeURL params:params handler:^(NSString *message, BOOL status) {
//            handler(message, status);
//        }];
//        return;
//    }
    
  
    
}

- (void)mSendReport:(NSDictionary *)params handler:(void (^)(NSString *, BOOL))handler {
    [_vSendModel mSendReportURL:kReportURL params:params handler:^(NSString *message, BOOL status) {
        handler(message, status);
    }];
}


- (void)getReportMessage {
    [_vSendModel getReportMessage:^(NSArray<BKReportModel *> *array) {
        if (_vProtocol) {
            [_vProtocol mGetReportMessage:array];
        }
    }];
}





- (void)mChangeTextFieldString:(UITextField *)textField actionNum:(UILabel *)labNum{
    // 40位
    NSString *str = [[textField text] stringByReplacingOccurrencesOfString:@"?" withString:@""];
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        
        labNum.text = [NSString stringWithFormat:@"%ld",(long)kSendThemeTextFieldNumberMaxLength - str.length];
        
        if ( str.length > kSendThemeTextFieldNumberMaxLength ) {
            labNum.textColor = [UIColor redColor];
        }else{
            labNum.textColor = [UIColor blackColor];
        }
    }else{
        //DLog(@"输入的英文还没有转化为汉字的状态");
    }
}


- (void)mCHangeTextViewString:(UITextView *)textView
                     viewType:(BKSendThemeDataType)type
                     placehol:(UILabel *)placeLab
                    actionNum:(UILabel *)labNum{
    // 800位
    NSString *str = [[textView text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        //        DLog(@"汉字");
        NSInteger textNum = str.length;
        if (type == BKSendReportData) {
            //舉報內容限制
            NSInteger num = kSendThemeTextViewNumberMinLength - textNum;
            labNum.text = [NSString stringWithFormat:@"%ld",(long)num];
            
            if ( textNum > kSendThemeTextViewNumberMinLength ) {
                labNum.textColor = [UIColor redColor];
            }else{
                labNum.textColor = [UIColor blackColor];
            }
        } else {
            //發佈或回复主題限制
            NSInteger num = kSendThemeTextViewNumberMaxLength - textNum;
            labNum.text = [NSString stringWithFormat:@"%ld",(long)num];
            
            if ( textNum > kSendThemeTextViewNumberMaxLength) {
                labNum.textColor = [UIColor redColor];
            }else{
                labNum.textColor = [UIColor blackColor];
            }
        }
        
        if (!str.length) {
            placeLab.hidden = NO;
        }else{
            placeLab.hidden = YES;
        }
        
        
    }else{
        placeLab.hidden = YES;
        //DLog(@"输入的英文还没有转化为汉字的状态");
    }
}

- (void)mScanPhotoPickerView:(UIViewController *)controller
                      photos:(NSArray *)photos
                       index:(NSInteger)index {
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 淡入淡出效果
    // pickerBrowser.status = UIViewAnimationAnimationStatusFade;
    // 数据源/delegate
    pickerBrowser.delegate = self;
    pickerBrowser.editing = YES;
    pickerBrowser.photos = photos;
    // 当前选中的值
    pickerBrowser.currentIndex = index;
    // 展示控制器
    [pickerBrowser showPickerVc:controller];
}

- (void)mSelectZLPhotoPickerView:(UIViewController *)controller
                          photos:(NSArray *)photos
                          assets:(void(^)(NSArray *photos))assets {
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = kSendThemeSelectPhotosCount;
    pickerVc.selectPickers = photos;
    pickerVc.photoStatus = PickerPhotoStatusPhotos;
    
    // Desc Show Photos, And Suppor Camera
    pickerVc.topShowPhotoPicker = YES;
    
    // CallBack
    pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> *status){
        NSMutableArray *assetPhotos = [NSMutableArray arrayWithCapacity:status.count];
        for (ZLPhotoAssets *asset in status) {
            ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
            if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
                photo.asset = asset;
                //当asset 找不到图片时可以取photoImage/ photoURL
                photo.photoImage = asset.originImage;
                photo.photoURL = asset.assetURL;
            }else if ([asset isKindOfClass:[ZLCamera class]]){
                ZLCamera *camera = (ZLCamera *)asset;
                photo.photoImage = [camera photoImage];
            }
            [assetPhotos addObject:photo];
        }
        assets(assetPhotos);
    };
    
    if (IS_IPAD) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [controller presentViewController:pickerVc animated:YES completion:nil];
        }];
    }else{
        [controller presentViewController:pickerVc animated:YES completion:nil];
    }

}

- (void)mSelectImagePickerView:(UIViewController *)controller {
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        //    imagePicker.allowsEditing = YES;
        //拍照
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeIFrame960x540;

        if (IS_IPAD) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [controller presentViewController:imagePicker animated:YES completion:nil];
            }];
        } else {
            [controller presentViewController:imagePicker animated:YES completion:nil];
        }
        
    }else
    {
        DLog(@"模拟其中无法打开照相机,请在真机中使用");
    }

}


#pragma mark - <ZLPhotoPickerBrowserViewControllerDelegate>
- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index{
    if (_vProtocol) {
        [_vProtocol mRemovePhotoItem:index];
    }
}


#pragma  mark PickerViewDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
   
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    image = [image scalingImageByRatio];

    NSData *data = UIImageJPEGRepresentation(image, 0.6);
    image = [UIImage imageWithData:data];
    
    //把牌照图片存储到本地
    NSString *path = [BKUserHelper saveImagePath:image];
    ZLPhotoAssets *assets = [[ZLPhotoAssets alloc] init];
    assets.originImage = image;
    assets.assetURL = [NSURL URLWithString:path];

    ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
    photo.asset = assets;
    photo.photoImage = image;
    photo.thumbImage = image;
    photo.photoURL = [NSURL URLWithString:path];

    if (_vProtocol) {
        [_vProtocol mAddAssetsImage:photo];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (NSMutableArray *)removeData:(NSString *)fid tid:(NSString *)tid {
    NSMutableArray *arrInfo = [NSMutableArray arrayWithArray:[BKSaveData getArray:kCommentKey]];
    [arrInfo enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        //判断是否是同一个板块的同一个帖子，如果不是，就不用显示草稿
        if ([obj[@"fid"] integerValue] == fid.integerValue && [obj[@"tid"] integerValue] == tid.integerValue) {
            *stop = true;
            if (*stop == true) {
                [arrInfo removeObjectAtIndex:idx];
            }
            
        }
    }];
    return arrInfo;
}


- (void)mRemovePhotoFid:(NSString *)fid tid:(NSString *)tid
{
    NSArray *info = [self removeData:fid tid:tid];
    [BKSaveData setArray:info key:kCommentKey];
}


- (void)mSaveSendThemeData:(NSString *)fid
                       tid:(NSString *)tid
                     photo:(NSArray *)assets
                 textField:(UITextField *)textField
                  textView:(UITextView *)textView {
    //判断本地有没有缓存过该草稿
    NSMutableArray *oldSave = [self removeData:fid tid:tid];
    
    NSMutableArray *arrAssets = [NSMutableArray arrayWithCapacity:0];
    [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[ZLPhotoPickerBrowserPhoto class]]) {
            ZLPhotoPickerBrowserPhoto *photo = (ZLPhotoPickerBrowserPhoto *)obj;
            ZLPhotoAssets *asset = photo.asset;
            if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
                [arrAssets addObject:[asset assetURL]];
            }else {
                [arrAssets addObject:photo.photoURL];
            }
        }
    }];
    
    NSString *images = [arrAssets componentsJoinedByString:@"#"];
    
    //图片和文字处理
    textView.text =  [textView.textStorage getPlainString:nil];
    
    NSDictionary *infor = @{@"fid":fid,
                            @"tid":tid,
                            @"textField":textField.text.length >0 ? textField.text : @"",
                            @"textView":textView.text.length >0 ? textView.text : @"",
                            @"assets":images};
    // 保存草稿信息
    [arrAssets setArray:oldSave];
    [arrAssets addObject:infor];
    [BKSaveData setArray:arrAssets key:kCommentKey];

}



@end
