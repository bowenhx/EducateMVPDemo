//
//  CustomAlertController.m
//  BKCustomAlertDemo
//
//  Created by ligb on 2017/11/15.
//  Copyright © 2017年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import "CustomAlertController.h"
@interface AlertViewParams: NSObject
@property (nonatomic, strong) UIViewController *controller;

@property (nonatomic, assign) UIAlertControllerStyle alertStyle;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) NSString *confirmTitle;

@property (nonatomic, copy) NSString *cancelTitle;

@property (nonatomic, copy) NSArray <NSString *> *tfPlaceholders;

@property (nonatomic, copy) NSArray <NSString *> *actions;

@property (nonatomic, assign) CGRect sourceRect;

@property (nonatomic, strong) UIView *sourceView;

@end

@interface CustomAlertController ()
@property (nonatomic, strong) AlertViewParams *params;
@end

@implementation CustomAlertController

- (CustomAlertController *)init {
    if (self = [super init]) {
        _params = [AlertViewParams new];
    }
    return self;
}


- (CustomAlertController *(^)(NSString *))title {
    return ^(NSString *str) {
        self.params.title = str;
        return self;
    };
}


- (CustomAlertController *(^)(NSString *))message {
    return ^(NSString *str) {
        self.params.message = str;
        return self;
    };
}


- (CustomAlertController *(^)(NSString *))cancelTitle {
    return ^(NSString *str) {
        self.params.cancelTitle = str;
        return self;
    };
}


- (CustomAlertController *(^)(NSString *))confirmTitle {
    return ^(NSString *str) {
        self.params.confirmTitle = str;
        return self;
    };
}


- (CustomAlertController *(^)(NSArray <NSString *>*))actions {
    return ^(NSArray <NSString *> *actions) {
        self.params.actions = actions;
        return self;
    };
}


- (CustomAlertController *(^)(NSArray <NSString *>*))tfPlaceholders {
    return ^(NSArray <NSString *> *placeholders) {
        self.params.tfPlaceholders = placeholders;
        return self;
    };
}


- (CustomAlertController *(^)(UIViewController *))controller {
    return ^(UIViewController *ctr) {
        self.params.controller = ctr;
        return self;
    };
}


- (CustomAlertController *(^)(AlertStyle))alertStyle {
    return ^(AlertStyle style) {
        if (style == alert) {
            self.params.alertStyle = UIAlertControllerStyleAlert;
        } else {
            self.params.alertStyle = UIAlertControllerStyleActionSheet;
        }
        return self;
    };
}


- (CustomAlertController *(^)(CGRect))sourceRect {
    return ^(CGRect rect) {
        self.params.sourceRect = rect;
        return self;
    };
}


- (CustomAlertController *(^)(UIView *))sourceView {
    return ^(UIView *sourceView) {
        self.params.sourceView = sourceView;
        return self;
    };
}


- (CustomAlertController *)show:(void (^)(UIAlertAction *action, NSInteger index))defaultAction
                  confirmAction:(void (^)(UIAlertAction *action))confirmAction
                   cancelAction:(void (^)(UIAlertAction *action))cancelAction {
    return [self addAlertControllerAction:defaultAction textField:nil confirmAction:^(UIAlertAction *action, NSArray<UITextField *> *textFields) {
        if (confirmAction) {
            confirmAction(action);
        }
    } cancelAction:^(UIAlertAction *action, NSArray<UITextField *> *textFields) {
        if (cancelAction) {
            cancelAction(action);
        }
    }];
}


- (CustomAlertController *)showTextField:(void (^)(UITextField *))textFieldHandler
                           confirmAction:(void (^)(UIAlertAction *, NSArray<UITextField *> *))confirmAction
                            cancelAction:(void (^)(UIAlertAction *, NSArray<UITextField *> *))cancelAction {
    return [self addAlertControllerAction:nil textField:textFieldHandler confirmAction:confirmAction cancelAction:cancelAction];
}


- (CustomAlertController *)addAlertControllerAction:(void (^)(UIAlertAction *action, NSInteger index))defaultAction
                       textField:(void (^)(UITextField *textField))textFieldHandler
                   confirmAction:(void(^)(UIAlertAction *action, NSArray<UITextField *> *textFields))confirmAction
                    cancelAction:(void(^)(UIAlertAction *action, NSArray<UITextField *> *textFields))cancelAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.params.title message:self.params.message preferredStyle:self.params.alertStyle];
    
    if (self.params.actions) {
        [self.params.actions enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (defaultAction) {
                    defaultAction(action, idx);
                }
            }];
            [alert addAction:action];
        }];
    }
    
    if (self.params.tfPlaceholders) {
        if (self.params.alertStyle == UIAlertControllerStyleAlert) {
            [self.params.tfPlaceholders enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = obj;
                    textField.tag = idx;
                    if (textFieldHandler) {
                        textFieldHandler(textField);
                    }
                }];
            }];
        } else {
            NSLog(@"'Text fields can only be added to an alert controller of style UIAlertControllerStyleAlert'");
        }
    }
    
    if (self.params.confirmTitle) {
        [alert addAction:[UIAlertAction actionWithTitle:self.params.confirmTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (confirmAction) {
                confirmAction(action, alert.textFields);
            }
        }]];
    }
    
    if (self.params.cancelTitle) {
        [alert addAction:[UIAlertAction actionWithTitle:self.params.cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelAction) {
                 cancelAction(action, alert.textFields);
            }
        }]];
    }
    
    if (self.params.sourceView) {
        alert.popoverPresentationController.sourceView = self.params.sourceView;
        alert.popoverPresentationController.sourceRect = self.params.sourceRect;
    }
    
    if (self.params.controller) {
        [self.params.controller presentViewController:alert animated:true completion:nil];
    } else {
        //经测试如果不传当前控制器很有可能不会弹出 alertController
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window.rootViewController presentViewController:alert animated:true completion:nil];
    }
    
    return self;
}


@end

@implementation AlertViewParams
@end


