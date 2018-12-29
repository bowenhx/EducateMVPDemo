//
//  NewCourseView.h
//  EduKingdom
//
//  Created by HY on 16/7/7.
//  Copyright © 2016年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseSearchModel.h"

@protocol NewCourseViewDelegate <NSObject>
-(void)mSelectRowClick:(CourseSearchModel *)model; //点击搜索按钮的代理方法
@end

@interface NewCourseView : UIView<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *vResultListArray; //列表数据源
    NSInteger _page; //刷新，加载数据的页码数
}

@property (assign, nonatomic)id <NewCourseViewDelegate> vDelegate;
@property (weak, nonatomic) IBOutlet UITableView *vTableView;


+(NewCourseView *)mGetInstance;
@end
