//
//  PollsCell.h
//  BKMobile
//
//  Created by 颜 薇 on 15/11/18.
//  Copyright © 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//
/**
 *  投票页面的Cell布局
 */
typedef enum {
    PollsCellStyleTypeOfSelect = 0,
    PollsCellStyleTypeOfShow = 1
}PollsCellStyleType;

#define kPollsCellHeight 50
#import <UIKit/UIKit.h>

@interface PollsCell : UITableViewCell


@property(nonatomic, assign)BOOL isSelectStatus;/**<选择状态*/
@property (nonatomic, strong) NSDictionary *option;/**<選項的數據字典*/
- (instancetype)initWithPollCellStyle:(PollsCellStyleType)pollCellStyle withReuseIdentifier:(NSString *)resureIdentifer;
@end
