/**
 -  UISegmentedControl.m
 -  BKHKAPP
 -  Created by HY on 2017/8/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "UISegmentedControl+BKTool.h"

@implementation UISegmentedControl (BKTool)

- (UISegmentedControl *)initWithSize:(CGSize)size items:(NSArray *)items addTarget:(id)target action:(SEL)action {
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
//    segmentedControl.size = size;
    segmentedControl.tintColor = [UIColor whiteColor];
    segmentedControl.selectedSegmentIndex = 0;
    
    NSDictionary *textFontDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15],NSFontAttributeName, nil];
    [segmentedControl setTitleTextAttributes:textFontDic forState:UIControlStateNormal];
    [segmentedControl addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    return segmentedControl;
}

@end
