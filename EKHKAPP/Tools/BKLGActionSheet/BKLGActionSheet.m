//
//  BKLGActionSheet.m
//  BKMobile
//
//  Created by bowen on 16/3/28.
//  Copyright © 2016年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "BKLGActionSheet.h"
#import "BKSettingModel.h"

@interface BKLGActionSheet ()<LGActionSheetDelegate>

@end

@implementation BKLGActionSheet


+ (void)showActionSheet:(id)controller type:(LGActionSeetType)type defSize:(NSInteger)size
{
    //弹出字条选择器UIActionSheet
    LGActionSheet *actionSheet = [[LGActionSheet alloc] initWithTitle:nil
                                                         buttonTitles:@[@"大號",@"中號",@"小號"]
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                        actionHandler:nil
                                                        cancelHandler:nil
                                                   destructiveHandler:nil];
    
    actionSheet.tag = 100;
    actionSheet.delegate        = controller;
    UIFont *font17              = [UIFont systemFontOfSize:17];
    UIFont *font20              = [UIFont systemFontOfSize:20];
    UIFont *font25              = [UIFont systemFontOfSize:25];
    actionSheet.buttonsFonts    = @[font25,
                                    font20,
                                    font17];
    
    UIColor *colorNor                             = [BKTool colorWithHexString:@"959595"];
    actionSheet.tintColor                         = colorNor;
    actionSheet.buttonsTitleColorHighlighted      = [UIColor EKColorNavigation];
    actionSheet.cancelButtonTitleColorHighlighted = [UIColor EKColorNavigation];
    if (type == InvitationDetailType) {
        if (size == 2) {
            //大号
            actionSheet.buttonsTitleColors = @[[UIColor EKColorNavigation],
                                               colorNor,
                                               colorNor];
        } else if (size == 0) {
            //中号
            actionSheet.buttonsTitleColors = @[colorNor,
                                               [UIColor EKColorNavigation],
                                               colorNor];
        } else {
            //小号
            actionSheet.buttonsTitleColors = @[colorNor,
                                               colorNor,
                                               [UIColor EKColorNavigation]];
        }
        
    } else {
        if ([BKSettingModel sharedInstance].motifFont == MotifSize_Max ) {
            actionSheet.buttonsTitleColors = @[[UIColor EKColorNavigation],
                                               colorNor,
                                               colorNor];
        } else if ([BKSettingModel sharedInstance].motifFont == MotifSize_Middle ){
            actionSheet.buttonsTitleColors = @[colorNor,
                                               [UIColor EKColorNavigation],
                                               colorNor];
        } else {
            actionSheet.buttonsTitleColors = @[colorNor,
                                               colorNor,
                                               [UIColor EKColorNavigation]];
        }
    }
    
    actionSheet.tintColor                         = colorNor;
    actionSheet.buttonsTitleColorHighlighted      = [UIColor EKColorNavigation];
    actionSheet.cancelButtonTitleColorHighlighted = [UIColor EKColorNavigation];
    
    [actionSheet showAnimated:YES completionHandler:nil];
    
    
}

+ (NSInteger)getDetailSizeFont {
    return [BKSaveData getInteger:kTopicDetailFontSizeKey];
}
+ (NSInteger)getDetailTaxis {
    return [BKSaveData getInteger:kTopicDetailOrderKey];
}

@end
