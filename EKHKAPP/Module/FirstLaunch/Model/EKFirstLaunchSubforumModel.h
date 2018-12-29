/**
 -  EKFirstLaunchSubforumModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/13.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:"首次启动"界面listModel的subforum字段数组的model
 */

#import <Foundation/Foundation.h>

@interface EKFirstLaunchSubforumModel : NSObject
@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isSelected;

//本地字段,用来记录cell里面的button是否需要隐藏
@property (nonatomic, assign) BOOL isHidden;
@end
