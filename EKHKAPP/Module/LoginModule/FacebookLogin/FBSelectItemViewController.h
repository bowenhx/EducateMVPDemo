//
//  FBSelectItemViewController.h
//  BKMobile
//
//  Created by ligb on 2017/8/11.
//  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "EKBaseViewController.h"
#import "FBInfoDataModel.h"

@interface FBSelectItemViewController : EKBaseViewController

@property (nonatomic, copy) NSArray<FBItemModel*> * category;
@property (nonatomic, strong)NSMutableDictionary *dicCommit;

@end
