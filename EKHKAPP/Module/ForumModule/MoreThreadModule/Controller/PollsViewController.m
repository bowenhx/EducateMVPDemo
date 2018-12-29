//
//  PollsViewController.m
//  BKMobile
//
//  Created by 薇 颜 on 15/11/16.
//  Copyright © 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "PollsViewController.h"
#import "PollsCell.h"
@interface PollsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelSubject;/**<標題*/
@property (weak, nonatomic) IBOutlet UILabel *labelNumber;/**<參加人數*/
@property (weak, nonatomic) IBOutlet UILabel *labelLastTime;/**<剩餘時間*/
@property (weak, nonatomic) IBOutlet UILabel *labelSelectNumber;/**<可選項數*/
@property (weak, nonatomic) IBOutlet UITableView *tabelView;

@property (nonatomic, strong) NSDictionary *threadpolls;/**<投票贴传递过来的信息*/

@property (nonatomic, assign) BOOL isPolls;/**<是投票，否则是显示投票结果*/

@property (nonatomic, strong) NSArray *optionsList; /**<投票的選項*/

@property (nonatomic, strong) NSMutableArray *polloptionidList;/**<已經選擇了的選項ID列表*/
@end

@implementation PollsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"投票";
    _optionsList = [NSArray array];
    _polloptionidList = [NSMutableArray array];
    [self requestThreadData];
//    [_tabelView setSeparatorColor:[UIColor colorCellLineBg]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLayoutSubviews{
    if ([_tabelView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tabelView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([_tabelView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tabelView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}
#pragma mark - Private Method
- (IBAction)actionSubmit:(id)sender{
    DLog(@"ID list : %@", _polloptionidList);
    NSString *polloptionidStr = [_polloptionidList componentsJoinedByString:@","];
    NSDictionary *parmeters = @{@"token": TOKEN,
                                   @"tid": _tid,
                                   @"pollanswers": polloptionidStr};
    [self.view showHUDActivityView:@"正在處理..." shade:NO];
    [EKHttpUtil mHttpWithUrl:kVoteURL parameter:parmeters response:^(BKNetworkModel *model, NSString *netErr) {
        [self.view removeHUDActivity];
        if (netErr) {
            [self.view showHUDTitleView:netErr image:nil];
        }else{
            [self requestThreadData];
        }
    }];
}
- (void)requestThreadData{
    [self.view showHUDActivityView:@"正在加載..." shade:NO];
    
    NSDictionary *dicInfor = @{@"token":TOKEN,
                               @"tid":_tid,
                               @"page":@(1),
                               @"ordertype":@(2),
                               @"authorid":@(0),
                               @"pw":@(_password)};
    
    
    __weak typeof(self)weakSelf = self;
    [EKHttpUtil mHttpWithUrl:kThemeDetailURL parameter:dicInfor response:^(BKNetworkModel *model, NSString *netErr) {
        [self.view removeHUDActivity];
        if (netErr) {
            [self.view showHUDTitleView:netErr image:nil];
        }else  {
            if (model.status) {
                if ([model.data isKindOfClass:[NSDictionary class]]) {
                    //帖子信息
                    NSDictionary *threadsDic = model.data[@"threads"];
                    //帖子标题
                    _labelSubject.text = threadsDic[@"subject"];
                    
                    //帖子类型：0 普通帖子，1 投票帖子， 4 活动帖子
                    NSInteger threadtype = [threadsDic[@"threadtype"] integerValue];
                    if (threadtype == 1) {
                        //投票貼數據
                        [weakSelf reloadThreadPolls:model.data[@"threadpolls"]];
                        _pollsView.threadpolls = model.data[@"threadpolls"];
                    }
                }
                
            }else{
                [self.view showHUDTitleView:model.message image:nil];
            }
        }
    }];
    
   
}
- (void)reloadThreadPolls:(NSDictionary *)threadpolls{
    _threadpolls = threadpolls;
    
    //是否多選
    NSString *multiple = [_threadpolls[@"multiple"] intValue] ? @"多選" : @"單選";
    //可選項數
    NSInteger maxchoices = [_threadpolls[@"maxchoices"] integerValue];
    //投票人數
    NSInteger voterscount = [_threadpolls[@"voterscount"] integerValue];
    
    [_labelSelectNumber setTextColor:[UIColor EKColorNavigation]];
    _labelNumber.text = [NSString stringWithFormat:@"%li人參與", (long)voterscount];
    _labelSelectNumber.text = [NSString stringWithFormat:@"%@(%li項)", multiple, (long)maxchoices];
    //时间戳 当等于0是已经投票或者投票结束
    NSInteger expiration = [_threadpolls[@"expiration"] integerValue];
    //剩余时间
    NSString *overdatestr = _threadpolls[@"overdatestr"];
//    BOOL visible = [_threadpolls[@"visible"] boolValue];/**<投票结果可见*/
    NSInteger mystatus = [_threadpolls[@"mystatus"] integerValue];
    NSInteger myselect = [_threadpolls[@"myselect"] integerValue];
    NSInteger nowTime = [[NSDate date] timeIntervalSince1970];
    DLog(@"nowTime : %li", (long)nowTime);
    
    _isPolls = NO;
    if (mystatus == 1 && expiration != 0) {
        if (nowTime <= expiration) {
            //可以投票
            _isPolls = YES;
            [self.vRightBarButton setTitle:@"提交" forState:UIControlStateNormal];
            [self.vRightBarButton addTarget:self action:@selector(actionSubmit:) forControlEvents:UIControlEventTouchUpInside];
            
            _labelLastTime.text = [NSString stringWithFormat:@"剩餘：%@", overdatestr];
        }else{
            //已经结束
            [self.vRightBarButton setTitle:@"已結束" forState:UIControlStateNormal];
            [self.vRightBarButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            _labelLastTime.text = @"投票已結束";
            
        }
    }else if (mystatus == 0 && expiration == 0){
        
        if(myselect == 0){
            //已经结束
            [self.vRightBarButton setTitle:@"已結束" forState:UIControlStateNormal];
            [self.vRightBarButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _labelLastTime.text = @"投票已結束";
            
        }else if(myselect == 1){
           
            //已投票
            [self.vRightBarButton setTitle:@"已投票" forState:UIControlStateNormal];
            [self.vRightBarButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _labelLastTime.text = @"您已參與投票";
        }
        
        
    }else if (mystatus ==  0 && expiration != 0){
        //已投票
        if (nowTime <= expiration) {
            //未結束
            [self.vRightBarButton setTitle:@"已投票" forState:UIControlStateNormal];
            [self.vRightBarButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            _labelLastTime.text = [NSString stringWithFormat:@"剩餘：%@", overdatestr];
        }else{
            [self.vRightBarButton setTitle:@"已結束" forState:UIControlStateNormal];
            [self.vRightBarButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _labelLastTime.text = @"投票已結束";
        }
    }else if (mystatus == 1 && expiration == 0){
        //可以投票,不限時間
        _isPolls = YES;
        [self.vRightBarButton setTitle:@"提交" forState:UIControlStateNormal];
        [self.vRightBarButton addTarget:self action:@selector(actionSubmit:) forControlEvents:UIControlEventTouchUpInside];
        
        _labelLastTime.text = @"";
    }
    [self.vRightBarButton setEnabled:_isPolls];
    

    _optionsList = _threadpolls[@"options"];
    [_tabelView reloadData];
}
/**
 *  在當前的列表裡面刪除一個ID
 */
- (void)polloptionidRemoveID:(NSString *)polloptionid{
    [_polloptionidList enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:polloptionid]) {
            *stop = true;
            if (*stop == true) {
                [_polloptionidList removeObject:obj];
            }
        }
    }];
}
#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _optionsList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer = @"PollCellIdentifier";
    PollsCell *cell = [[PollsCell alloc] initWithPollCellStyle:_isPolls?PollsCellStyleTypeOfSelect:PollsCellStyleTypeOfShow
                                           withReuseIdentifier:cellIdentifer];
    
    NSDictionary *dict = _optionsList[indexPath.row];
    cell.option = dict;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PollsCell *cell = (PollsCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (_isPolls) {
        if (cell.isSelectStatus) {//如果已經選擇了則取消選擇
            cell.isSelectStatus = NO;
            [self polloptionidRemoveID:cell.option[@"polloptionid"]];
        }else{
            //可選項數
            NSInteger maxchoices = [_threadpolls[@"maxchoices"] integerValue];
            if (_polloptionidList.count < maxchoices) {
                [_polloptionidList addObject:cell.option[@"polloptionid"]];
                cell.isSelectStatus = YES;
            }
        }
    }
    
}
#pragma mark - TableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kPollsCellHeight;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
