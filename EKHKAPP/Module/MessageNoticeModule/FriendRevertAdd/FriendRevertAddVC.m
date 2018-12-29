//
//  FriendRevertAddVC.m
//  BKMobile
//
//  Created by 薇 颜 on 15/7/31.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "FriendRevertAddVC.h"

@interface FriendRevertAddVC ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic) NSInteger groupCode;
@property (nonatomic, strong) NSArray *groupList;
@end

@implementation FriendRevertAddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友請求";
    
    _groupList = @[@"其他",
                   @"通過本站認識",
                   @"通過活動認識",
                   @"通過朋友認識",
                   @"親人",
                   @"同事",
                   @"同學",
                   @"不認識"];
    _groupCode = 1;
    [self layoutUI];
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
        [_tableView setSeparatorColor:[UIColor clearColor]];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
    [submitBtn setTitle:@"批准請求" forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[UIColor EKColorNavigation]];
    submitBtn.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    submitBtn.layer.borderWidth = 0.65f;
    submitBtn.layer.cornerRadius = 6.0f;
    [submitBtn addTarget:self action:@selector(actionApprove:) forControlEvents:UIControlEventTouchUpInside];
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
    [rightBtn addTarget:self action:@selector(actionIgnore:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:leftBar];
}

#pragma mark - private method
/**
 *  批准好友請求
 */
- (IBAction)actionApprove:(id)sender{
    [self.view showHUDActivityView:kStartLoadingText shade:NO];
    [EKHttpUtil mHttpWithUrl:kFriendAddOrAgreeURL parameter:@{@"token":TOKEN, @"uid":_vNoticeListModel.authorid, @"note": @"", @"gid": @(_groupCode), @"isgree": @(1)} response:^(BKNetworkModel *model, NSString *netErr) {
        [self.view removeHUDActivity];
        
        if (netErr) {
            [self.view showHUDTitleView:netErr image:nil];
        }else {
            if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(mFriendRevertAddVCDidFinish:)]) {
                [self.vDelegate mFriendRevertAddVCDidFinish:self];
            }
            
            //返回上頁
            [[[UIAlertView alloc] initWithTitle:nil message:model.message
                               cancelButtonItem:[RIButtonItem itemWithLabel:@"確定" action:^{
                
                [self.navigationController popViewControllerAnimated:YES];
            }]  otherButtonItems:nil, nil] show];
            
        }

    }];
    
}
/**
 *  忽略好友請求
 */
- (IBAction)actionIgnore:(id)sender{
    
    [[[UIAlertView alloc] initWithTitle:nil message:@"確定忽略好友關係嗎？"
                      cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
        DLog(@"取消");
    }] otherButtonItems:[RIButtonItem itemWithLabel:@"確定" action:^{
        
        [self.view showHUDActivityView:@"正在加載..." shade:NO];
        //提交忽略信息到服務器
        [EKHttpUtil mHttpWithUrl:kFriendDeleteOrIgnoreURL parameter:@{@"token":TOKEN, @"uid":_vNoticeListModel.authorid} response:^(BKNetworkModel *model, NSString *netErr) {
            [self.view removeHUDActivity];
            
            if (netErr) {
                [self.view showHUDTitleView:netErr image:nil];
            }else {
                if (model.status) {
                    if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(mFriendRevertAddVCDidFinish:)]) {
                        [self.vDelegate mFriendRevertAddVCDidFinish:self];
                    }
                    
                    [[[UIAlertView alloc] initWithTitle:nil message:model.message
                                       cancelButtonItem:[RIButtonItem itemWithLabel:@"確定" action:^{
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }] otherButtonItems:nil, nil] show];
                }else{
                    [self.view showHUDTitleView:model.message image:nil];
                }
            }
        }];
        
        
    }], nil] show];
  
}
#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    switch (indexPath.section) {
        case 0:
        {
            if (!_textView) {
                _textView = [[UITextView alloc] init];
                [_textView setTranslatesAutoresizingMaskIntoConstraints:NO];
                [_textView setFont:[UIFont systemFontOfSize:18.0f]];
                [_textView setText:_vNoticeListModel.msg];
                [_textView setEditable:NO];
                [cell.contentView addSubview:_textView];
                //寬度
                [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_textView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textView)]];
                //高度
                [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_textView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textView)]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            break;
        }
        case 1:
        {
            cell.textLabel.text = _groupList[_groupCode];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            break;
        }
        default:
            break;
    }
    return cell;
}
#pragma mark - TableView Delegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title = @"";
    switch (section) {
        case 0:
        {
            title = [NSString stringWithFormat:@"%@請求加您為好友", _vNoticeListModel.author];
            break;
        }
        case 1:
        {
            title = @"批准並分組";
            break;
        }
        default:
            break;
    }
    return title;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 150.0f;
    }
    return 45.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {//選擇分組
        [_textView resignFirstResponder];
        NSMutableArray *titleList = [NSMutableArray arrayWithArray:_groupList];
        [titleList addObject:@"取消"];
        //彈出分組列表
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        [actionSheet setTag:178];
        actionSheet.delegate = self;
        
        for (NSString * title in titleList) {
            [actionSheet addButtonWithTitle:title];
        }
        actionSheet.destructiveButtonIndex = 1;
        actionSheet.cancelButtonIndex = titleList.count-1;
        [actionSheet showInView:self.view];
        
    }
}
#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 178) {
        if (buttonIndex < _groupList.count) {
            _groupCode = buttonIndex;
            //修改cell上的文字
            UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            cell.textLabel.text = _groupList[_groupCode];
            DLog(@"group : %@", _groupList[buttonIndex]);
        }
        
    }
}
@end
