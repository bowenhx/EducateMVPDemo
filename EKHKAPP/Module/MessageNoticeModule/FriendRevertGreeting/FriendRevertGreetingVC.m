//
//  FriendRevertGreetingVC.m
//  BKMobile
//
//  Created by 薇 颜 on 15/8/1.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "FriendRevertGreetingVC.h"
#import "BKCustomPickerView.h"

@interface FriendRevertGreetingVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SAMTextView *textView;
@property (nonatomic) NSInteger actionCode;
@property (nonatomic, strong) NSArray *actionList;
@property (nonatomic, strong) BKCustomPickerView *customPickerView;
@end

@implementation FriendRevertGreetingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"回打招呼";
    _actionCode = 0;

    [self layoutUI];
    [self requestGreetingList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 * UI控件初始化布局
 */
#pragma mark - UI
- (void)layoutUI{
    [self.view setBackgroundColor:[UIColor EKColorBackground]];
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setBackgroundView:nil];
        [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_tableView setScrollEnabled:NO];
        [_tableView setTableFooterView:[self footerButton]];
        [self.view addSubview:_tableView];
        
    }
    //寬度
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    //高度
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    
    //=== 添加右上角的忽略按鈕
    [self rightBarButtonItem];
}


- (UIView *)footerButton{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50.0f)];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setFrame:CGRectMake(20, 10, SCREEN_WIDTH-20*2, 35.0)];
    [submitBtn setTitle:@"發送" forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[UIColor EKColorNavigation]];
    submitBtn.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    submitBtn.layer.borderWidth = 0.65f;
    submitBtn.layer.cornerRadius = 6.0f;
    [submitBtn addTarget:self action:@selector(actionSubmitGreeting:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitBtn];
  
    return footerView;
}
/**
 *  右上角的忽略按鈕
 */
- (void)rightBarButtonItem{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"忽略" forState:UIControlStateNormal];
    [rightBtn setFrame:CGRectMake(0, 0, 40, 35)];
    [rightBtn addTarget:self action:@selector(actionIgnoreGreeting:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:leftBar];
}
#pragma mark - Private Method

/**
 *  提交招呼
 */
- (IBAction)actionSubmitGreeting:(id)sender{
    NSDictionary *parame = @{@"token":TOKEN,
                             @"op":@"reply",
                             @"iconid": @(_actionCode),
                             @"note": _textView.text,
                             @"uid":_vNoticeListModel.authorid};
    [self.view showHUDActivityView:kStartLoadingText shade:NO];
    [EKHttpUtil mHttpWithUrl:kFriendGreetURL parameter:parame response:^(BKNetworkModel *model, NSString *netErr) {
         [self.view removeHUDActivity];
        if (netErr) {
            [self.view showError:netErr];
        }else {
            if (model.status == 1) {
                if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(mFriendRevertGreetingVCDidFinish:)]) {
                    [self.vDelegate mFriendRevertGreetingVCDidFinish:self];
                }
                dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    //刷新列表
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"NotificationForUpdateNoticeList"
                                   object:nil];
                });

                //返回上頁
                [[[UIAlertView alloc] initWithTitle:nil
                                            message:model.message
                                   cancelButtonItem:[RIButtonItem itemWithLabel:@"確定" action:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }] otherButtonItems:nil, nil] show];
            }else{
                [self.view showHUDTitleView:model.message image:nil];
            }
  
        }
    }];
    
}

/**
 *  忽略招呼
 */
- (IBAction)actionIgnoreGreeting:(id)sender{
    
    [[[UIAlertView alloc] initWithTitle:nil message:@"確定忽略招呼嗎？"
                       cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
        DLog(@"取消");
    }] otherButtonItems:[RIButtonItem itemWithLabel:@"確定" action:^{
        
        [self.view showHUDActivityView:@"正在加載..." shade:NO];
        //提交忽略招呼到服務器
        NSDictionary *parame = @{@"token":TOKEN,
                                 @"op":@"ignore",
                                 @"uid":_vNoticeListModel.authorid};
        [EKHttpUtil mHttpWithUrl:kFriendGreetURL parameter:parame response:^(BKNetworkModel *model, NSString *netErr) {
            [self.view removeHUDActivity];
           
            if (model.status == 1) {
                
                if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(mFriendRevertGreetingVCDidFinish:)]) {
                    [self.vDelegate mFriendRevertGreetingVCDidFinish:self];
                }
                
                dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    //刷新提醒列表
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationForUpdateNoticeList"
                                      object:nil];
                });

                [[[UIAlertView alloc] initWithTitle:nil
                                            message:model.message
                                   cancelButtonItem:[RIButtonItem itemWithLabel:@"確定" action:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }] otherButtonItems:nil, nil] show];
                
                
            }else{
                //失败
                [self.view showHUDTitleView:model.message image:nil];
            }
        }];
        
    }], nil] show];
    
}
/**
 *  請求招呼列表
 */
- (void)requestGreetingList{
    
    NSDictionary *parame = @{@"token":TOKEN,
                             @"op":@"list"};
    
    [self.view showHUDActivityView:@"正在請求..." shade:NO];
    [EKHttpUtil mHttpWithUrl:kFriendGreetURL parameter:parame response:^(BKNetworkModel *model, NSString *netErr) {
        //成功
        [self.view removeHUDActivity];
        
        if (netErr) {
            [self.view showHUDTitleView:netErr image:nil];
        }else if (model.status == 1) {
            _actionList = model.data;
        }else{
            //失败
            [self.view showHUDTitleView:model.message image:nil];
        }
    }];
   
}
#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    switch (indexPath.row) {
        
        case 0:
        {
            cell.textLabel.text = @"請選動作：";
            cell.detailTextLabel.text = @"不用動作";
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            break;
        }
        case 1:
        {
            if (!_textView) {
                _textView = [[SAMTextView alloc] init];
                [_textView setTranslatesAutoresizingMaskIntoConstraints:NO];
                [_textView setFont:[UIFont systemFontOfSize:18.0f]];
                [_textView setPlaceholder:@"內容選填，並且會覆蓋之前的招呼動作選擇，最多150個字符"];
   
//                _textView.placeHolder = @"內容選填，並且會覆蓋之前的招呼動作選擇，最多150個字符";
//                _textView.placeHolderTextColor = [UIColor lightGrayColor];
                [cell.contentView addSubview:_textView];
                //寬度
                [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_textView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textView)]];
                //高度
                [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_textView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textView)]];
            }
            break;
        }
        default:
            break;
    }
    return cell;
}
#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return 150.0f;
    }
    return 45.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [_textView resignFirstResponder];
        if (!_customPickerView) {            
            NSMutableArray *strList = [NSMutableArray array];
            //拼装字符串列表
            [_actionList enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                [strList addObject:obj[@"strval"]];
            }];
            
            if (_customPickerView) {
                [_customPickerView hiddenPickerView];
                _customPickerView = nil;
            }
            
            //创建pickerView
            _customPickerView = [BKCustomPickerView showPickerViewHeaderColor:[UIColor EKColorNavigation] title:@"請選擇動作" displayCount:1 datas:strList forKey1:nil forKey2:nil defineSelect:0 doneBlock:^(NSInteger selectedIndex, id selectedValue) {
                _actionCode = selectedIndex;
                UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                cell.detailTextLabel.text = selectedValue;
            } cancelBlock:^{
                
            } supView:self.view];
            
        }
        
        
    }
}
#pragma mark - FriendGreetingListDelegate
- (void)friendGreetingListSelect:(NSDictionary *)greetingDict{
    
    _actionCode = [greetingDict[@"id"] integerValue];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.detailTextLabel.text = greetingDict[@"strval"];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
