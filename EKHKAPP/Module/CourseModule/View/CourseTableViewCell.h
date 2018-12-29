//
//  CourseTableViewCell.h
//  EduKingdom
//
//  Created by HY on 16/7/6.
//  Copyright © 2016年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseSearchModel.h"

@interface CourseTableViewCell : UITableViewCell
//名稱
@property (weak, nonatomic) IBOutlet UILabel *vTitle;
//年齡對象
@property (weak, nonatomic) IBOutlet UILabel *vAge;
//地區
@property (weak, nonatomic) IBOutlet UILabel *vDistrict;
//學費
@property (weak, nonatomic) IBOutlet UILabel *vPrise;
//舉辦單位
@property (weak, nonatomic) IBOutlet UILabel *vLocal;

-(void)mRefreshCourseCell:(NSInteger)row data:(CourseSearchModel *)data;

@end
