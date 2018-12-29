//
//  BlogTypeTableViewController.m
//  EduKingdom
//
//  Created by ligb on 2017/1/13.
//  Copyright © 2017年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import "BlogTypeTableViewController.h"
#import "BlogListModel.h"
#import "EKFriendViewController.h"
#import "BlogSettingTableViewCell.h"

@interface BlogTypeTableViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic , strong) NSMutableArray *itemArray;
@property (nonatomic , copy) NSArray *friends;
@property (nonatomic , copy) NSString *password;
@end

@implementation BlogTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)mInitUI {
    [self.vRightBarButton setTitle:@"完成" forState:UIControlStateNormal];
    //注册xib
    [_tableView registerNib:[UINib nibWithNibName:@"BlogSettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"blogSettingTableViewCell"];
    [_tableView setTableFooterView:[[UIView alloc] init]];
}

- (void)mInitData{
    if (_blogSetting == EditBlogSetting_Type) {
    
        NSData *saveData = [BKSaveData readDataByFile:SAVE_BLOG_TYPE];
        if (saveData) {
            NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:saveData];
            _itemArray = [[NSMutableArray alloc] initWithArray:arr];
            [self.tableView reloadData];
        } else {
            [BlogTypeModel mRequestBlogTypeListBlock:^(NSArray *data, NSString *netErr) {
                [self.view removeHUDActivity];
                if (netErr) {
                    [self.view showHUDTitleView:netErr image:nil];
                }else{
                    if (data.count > 0) {
                        _itemArray = [[NSMutableArray alloc] initWithArray:data];
                        [self.tableView reloadData];
                    }
                }
            }];
        }
    } else if (_blogSetting == EditBlogSetting_Intimity) {
        //隐私设置页面
        _itemArray = [[NSMutableArray alloc] initWithObjects:@"全站用戶可見",@"僅好友可見",@"指定好友可見",@"僅自己可見",@"憑密碼可見", nil];
        [self.tableView reloadData];
    }
}

#pragma mark - 点击右上角“完成“按钮
- (void)mTouchRightBarButton{
   if (_blogSetting == EditBlogSetting_Type){
       BlogTypeModel *typeModel = _itemArray[_selectIndex];
       if (_typeObj) {
           _typeObj ( typeModel , typeModel.catname , _selectIndex);
       }
    } else if (_blogSetting == EditBlogSetting_Intimity) {
        [self backSelectContent];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backSelectContent{
    //这里先去返回cell中detail text 显示
    if (_typeObj) {
        _typeObj ( nil , _itemArray[_selectIndex] , _selectIndex);
    }
    
    //根据类型再返回指定的需求信息
    switch (_selectIndex) {
        case 2: {
            //选中的是指定好友，需要返回好友名字
            if (_freendsPw) {
                _freendsPw (_friends , nil);
            }
        }
            break;
        case 4: {
            //设置了密码选项，返回密码
            if (_freendsPw) {
                _freendsPw (nil , _password);
            }
        }
            break;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *defineCell = @"blogSettingTableViewCell";
    BlogSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defineCell forIndexPath:indexPath];
    [self cellForRowSurplusTableViewCell:cell indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_blogSetting == EditBlogSetting_Type) {
        _selectIndex = indexPath.row;
        [_tableView reloadData];
    }else if (_blogSetting == EditBlogSetting_Intimity) {
        if (indexPath.row == 2) {
            EKFriendViewController *friendVC = [[EKFriendViewController alloc] init];
            friendVC.friendPageType = FriendPageTypeIsPublishBlog;
            friendVC.usernames = ^(NSArray *usernames){
                NSLog(@"usernames = %@",usernames);
                if (usernames.count) {
                    _selectIndex = indexPath.row;
                    [_tableView reloadData];
                    _friends = [usernames copy];
                }
            };
            [self.navigationController pushViewController:friendVC animated:YES];
            
        } else if (indexPath.row == 4) {
            //凭密码可见
            [self addAlertViewAction];
        } else {
            _selectIndex = indexPath.row;
            [_tableView reloadData];
        }
    }
}

- (void)cellForRowSurplusTableViewCell:(BlogSettingTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    if (_blogSetting == EditBlogSetting_Type) {
        cell.leftImg.hidden = YES;
        BlogTypeModel *typeModel = _itemArray[indexPath.row];
        cell.textLab.text = typeModel.catname;
        if (indexPath.row == _selectIndex) {
            cell.rightImg.hidden = NO;
        } else {
            cell.rightImg.hidden = YES;
        }
        
    } else if (_blogSetting == EditBlogSetting_Intimity) {
        cell.rightImg.hidden = YES;
        if (indexPath.row == 2 || indexPath.row == 4) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == _selectIndex) {
            cell.leftImg.hidden = NO;
        }else{
            cell.leftImg.hidden = YES;
        }
        cell.textLab.text = _itemArray[indexPath.row];
    }
}

#pragma mark - UIAlertView
- (void)addAlertViewAction {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"設置密碼" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定", nil];
    //添加一个密码输入框
    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alertView show];
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.backgroundColor = [UIColor whiteColor];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.borderStyle = UITextBorderStyleNone;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
    } else {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if ([BKTool isStringBlank:textField.text]) {
            [self.view showHUDTitleView:@"請输入有效密码" image:nil];
            [self addAlertViewAction];
        } else {
            //完成
            _password = textField.text;
            _selectIndex = 4;
            [_tableView reloadData];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
