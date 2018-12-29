//
//  WarningPostVC.m
//  BKMobile
//
//  Created by 颜 薇 on 15/12/18.
//  Copyright © 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "WarningPostVC.h"
#import "BKCustomPickerView.h"
@interface WarningPostVC ()<UITableViewDataSource, UITableViewDelegate>
{
    
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *reasonList;
@property (nonatomic, strong) SAMTextView *textView;
@property (nonatomic, strong) BKCustomPickerView *customPickerView;

@end


@implementation WarningPostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _isWarning ? @"解除警告" : @"警告該貼";
    [self layoutUI];
    [self requestReason];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
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
        [_tableView setTableFooterView:[UIView new]];//不显示cell为空的分界线
        [self.view addSubview:_tableView];
        
    }
    //寬度
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    //高度
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    
    //=== 添加右上角的忽略按鈕
    [self rightBarButtonItem];
}
/**
 *  右上角的提交按鈕
 */
- (void)rightBarButtonItem{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    [rightBtn setFrame:CGRectMake(0, 0, 40, 35)];
    [rightBtn addTarget:self action:@selector(actionSubmit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:leftBar];
}
/**
 *  請求API獲取操作原因列表
 */
- (void)requestReason{
    //理由
    [self.view showHUDActivityView:@"正在加載..." shade:NO];
    [EKHttpUtil mHttpWithUrl:kReportReasonURL parameter:nil response:^(BKNetworkModel *model, NSString *netErr) {
        [self.view removeHUDActivity];
        if (model.status) {
            _reasonList = model.data;
        }

    }];
}
#pragma mark - Action
/**
 * 提交操作
 */
- (IBAction)actionSubmit:(id)sender{
    NSDictionary *parameter = @{@"token": TOKEN,
                                @"fid": _dictPost[@"fid"],
                                @"tid": _dictPost[@"tid"],
                                @"pid": _dictPost[@"pid"],
                                @"warned": _isWarning ? @"0" : @"1",
                                @"reason": _textView.text,
                                @"sendreasonpm": @"1"};
    [self.view showHUDActivityView:@"正在提交..." shade:NO];
    [EKHttpUtil mHttpWithUrl:kManageWarnURL parameter:parameter response:^(BKNetworkModel *model, NSString *netErr) {
        [self.view removeHUDActivity];
        
        //彈出提示框
        [[[UIAlertView alloc] initWithTitle:nil message:model.message
                           cancelButtonItem:[RIButtonItem itemWithLabel:@"確定" action:^{
            
            if (model.status) {
                if (_isFromThread) {//如果是来自帖子内容页，返回之前刷新下帖子内容页的数据
                    
                    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(queue, ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdataRevertNotification object:nil];
                    });
                    
                    
                }
                //返回上頁
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }] otherButtonItems:nil, nil] show];

    }];
    
}
#pragma mark TableVeiwDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = _isWarning ? @"解除警告：" : @"將要警告";
            cell.detailTextLabel.text = _subject;
            
            
            break;
        }
        case 1:
        {
            cell.textLabel.text = @"操作原因：";
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            break;
        }
        case 2:
        {
            if (!_textView) {
                _textView = [[SAMTextView alloc] init];
                [_textView setTranslatesAutoresizingMaskIntoConstraints:NO];
                [_textView setFont:[UIFont systemFontOfSize:18.0f]];
                [_textView setPlaceholder:@"違規內容"];
                [cell.contentView addSubview:_textView];
                //寬度
                [cell.contentView addConstraints:[NSLayoutConstraint
                                                  constraintsWithVisualFormat:@"H:|-5-[_textView]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textView)]];
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
    if (indexPath.row == 2) {
        return 150.0f;
    }
    return 45.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:
        {
            [_textView resignFirstResponder];
            if (!_customPickerView) {
                NSMutableArray *strList = [NSMutableArray array];
                //拼装字符串列表
                [_reasonList enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                    [strList addObject:obj[@"str"]];
                }];
                
                if (_customPickerView) {
                    [_customPickerView hiddenPickerView];
                    _customPickerView = nil;
                }
                
                //创建pickerView
                _customPickerView = [BKCustomPickerView showPickerViewHeaderColor:[UIColor EKColorNavigation] title:@"" displayCount:1 datas:strList forKey1:nil forKey2:nil defineSelect:0 doneBlock:^(NSInteger selectedIndex, id selectedValue) {
                    _textView.text = selectedValue;
                } cancelBlock:^{
                    
                } supView:self.view];
                
            }
            break;
        }
        default:
            break;
    }
    
}

//从详情页面跳转到该页面
+(void)push:(UIViewController *)vc detailModel:(ThreadsDetailModel *)detailModel dataModel:(InvitationDataModel *)dataModel{
    WarningPostVC *warningPostVC = [[WarningPostVC alloc] init];
    warningPostVC.isFromThread = YES;
    warningPostVC.dictPost = @{@"fid": @(detailModel.fid),
                               @"tid": @(detailModel.tid),
                               @"pid": @(dataModel.pid)};
    warningPostVC.subject = detailModel.subject;
    warningPostVC.isWarning = (dataModel.status == 2 || dataModel.status == 3) ? YES : NO;
    [vc.navigationController pushViewController:warningPostVC animated:YES];
}

@end
