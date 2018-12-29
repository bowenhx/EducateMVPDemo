//
//  CoursesSearchResultViewController.h
//  EduKingdom
//
//  Created by HY on 16/7/6.
//  Copyright © 2016年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKBaseViewController.h"

@interface CoursesSearchResultViewController : EKBaseViewController {
    NSMutableArray *vResultListArray; //搜索结果列表数据源
}

@property (nonatomic,strong)NSDictionary *vSourceParameter; //请求数据需要的参数
@property (nonatomic,copy)NSString *vNavTitle; //标题
@property (nonatomic, strong) IBOutlet UITableView *vTableView;
@property (nonatomic, assign) NSInteger page;
@end
