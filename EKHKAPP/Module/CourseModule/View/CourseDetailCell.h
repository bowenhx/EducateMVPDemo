//
//  CourseDetailCell.h
//  EduKingdom
//
//  Created by HY on 16/7/11.
//  Copyright © 2016年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CourseDetailCell_height 70  //cell高度
#define CourseDetailCell_space  10  //詳細信息label，距離屏幕左右邊框距離為10

@interface CourseDetailCell : UITableViewCell

//名称
@property (weak, nonatomic) IBOutlet UILabel *vTitle;

//详细信息
@property (weak, nonatomic) IBOutlet UILabel *vDetail;

@end
