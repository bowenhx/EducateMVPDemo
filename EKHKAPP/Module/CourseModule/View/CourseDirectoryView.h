//
//  CourseDirectoryView.h
//  EduKingdom
//
//  Created by HY on 16/7/7.
//  Copyright © 2016年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CourseDirectoryViewDelegate <NSObject>
-(void)mSelectDirectoryRowClick:(NSDictionary *)parameter title:(NSString *)title; //点击课程目录子分类，跳转到课程列表
@end

@interface CourseDirectoryView : UIView<UITableViewDelegate,UITableViewDataSource>{
    NSArray *vSourceArray; //列表数据源

    __weak IBOutlet UITableView *vLeftTable;
    __weak IBOutlet UITableView *vRightTable;
     NSInteger               _selectIndex;                       //表示左边Tab指向位置

}
@property (assign, nonatomic)id <CourseDirectoryViewDelegate> vDelegate;
+(CourseDirectoryView *)mGetInstance;
@end
