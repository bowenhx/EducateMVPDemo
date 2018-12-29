//
//  EKLoginViewController.h
//  EKHKAPP
//
//  Created by ligb on 2017/10/13.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import "EKBaseViewController.h"
#import "EKADViewController.h"

@interface EKLoginViewController : EKADViewController

+ (BOOL)showLoginVC:(UIViewController * _Nonnull )viewController from:(NSString * _Nonnull)from;

- (void)dismissLoginViewWithCompletion:(void (^ __nullable)(void))completion;

@end
