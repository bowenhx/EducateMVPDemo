//
//  CommentViewController.m
//  BKMobile
//
//  Created by Guibin on 15/8/7.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentViewCell.h"
#import "InvitationDataModel.h"


@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate,CommentModelDelegate>
{
    
    __weak IBOutlet UITableView *_tableView;
    
    
}
@property (nonatomic , strong) NSMutableArray *dataSource;
@end

@implementation CommentViewController
- (void)dealloc{
    [_dataSource enumerateObjectsUsingBlock:^(CommentModel *model, NSUInteger idx, BOOL *stop) {
        model.delegate = nil;
    }];
    [_dataSource removeAllObjects];
    _dataSource = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initViewFrame];
    
//    [self loadData];
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}
- (void)initViewFrame{
    
    self.title = @"查看點評";
    self.view.backgroundColor = [UIColor EKColorBackground];
    _tableView.backgroundColor = [UIColor EKColorBackground];
    
    [_tableView registerNib:[UINib nibWithNibName:@"CommentViewCell" bundle:nil] forCellReuseIdentifier:@"commentViewCell"];
    _tableView.tableFooterView = [[UIView alloc] init];

    if (_dataArr.count) {
        [self loadDataComent:_dataArr];
        [BKSaveData writeArrayToFile:_dataArr fileName:@"dataInfo"];
    }else{
        NSArray *arrData= [BKSaveData readArrayByFile:@"dataInfo"];
        if (arrData.count) {
            [self loadDataComent:arrData];
        }
    }
    
}
- (void)tapBackBtn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载 ，在WWDC视频也忽视这一点。
    if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
    {
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
}
- (void)loadData{
    //DLog(@"tid = %lu, pid = %lu",(unsigned long)_tid, (unsigned long)_pid);
    [EKHttpUtil mHttpWithUrl:kThemeCommentListURL parameter:@{@"token":TOKEN,
                                                              @"tid":@(_tid),
                                                              @"pid":@(_pid),
                                                              @"page":@(1)} response:^(BKNetworkModel *model, NSString *netErr) {
                                                    if (netErr) {
                                                        [self.view showHUDTitleView:netErr image:nil];
                                                    }else if (model.status == 1) {
                                                        [self loadDataComent:model.data];
                                                    }else{
                                                        [self.view showHUDTitleView:model.message image:nil];
                                                    }

                                                }];
    
    
}
- (void)loadDataComent:(NSArray *)arrData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [arrData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            CommentModel *model = [[CommentModel alloc] init];
            model.delegate = self;
            model.tag = idx;
            if ([obj isKindOfClass:[NSDictionary class]]) {
                [model setValuesForKeysWithDictionary:obj];
            }
            [self.dataSource addObject:model];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });

    });
}

#pragma updata Cell
- (void)updataTextComent:(NSDictionary *)dict
{
    NSUInteger row = [dict[@"tag"] integerValue];
    CommentModel *model = [_dataSource objectAtIndex:row];
    model.attString = dict[@"attString"];
    model.viewHeight = [dict[@"height"] floatValue];
    
    NSIndexPath *iPath = [NSIndexPath indexPathForRow:row inSection:0];
    [_tableView reloadRowsAtIndexPaths:@[iPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentViewCell"];
    cell.item = [_dataSource objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel *model = [_dataSource objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[CommentModel class]]) {
         return model.viewHeight + 40;
    }else{
        return 60;
    }
   
}

+ (void)pushCommentVC:(NSUInteger)tid pid:(NSUInteger)pid dataArr:(NSArray *)dataArr vc:(UIViewController *)vc{
    CommentViewController *commentVC = [[CommentViewController alloc] initWithNibName:@"CommentViewController" bundle:nil];
    commentVC.tid = tid;
    commentVC.pid = pid;
    commentVC.dataArr = dataArr;
    [vc.navigationController pushViewController:commentVC animated:YES];
}


@end
