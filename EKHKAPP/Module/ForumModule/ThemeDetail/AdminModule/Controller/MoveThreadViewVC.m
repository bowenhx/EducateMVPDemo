//
//  MoveThreadViewVC.m
//  BKMobile
//
//  Created by Guibin on 15/12/1.
//  Copyright © 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "MoveThreadViewVC.h"
@interface MoveThreadViewVC ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate>
{
    __weak IBOutlet UITableView *_tableView;
    
    IBOutlet UIView *_pickerViewBg;
    
    __weak IBOutlet UIPickerView *_pickerView;
    
    IBOutlet UITextView         *_textView;             //操作理由
    

    __weak IBOutlet UILabel         *_textLab;
    
    NSArray         *_arrayData;
    
    NSMutableArray  *_pickerData;
    NSMutableArray  *_picData;
    
    NSInteger       _pickRow;
    NSInteger       _pickIndex;
    NSInteger       _componentIndex;
    NSInteger       _moveID;    //移动目标板块id
    NSInteger       _threadtypeid;//主题分类id
    NSInteger       _requiredtype; //0代表可以直接选该板块 1：代表必须选择该板块下的一个分类
}
@property (nonatomic , copy) NSString *pickTitle;
@end

@implementation MoveThreadViewVC

- (void)navRightBarItem
{
    //添加导航右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(didSelectSubmitAction:)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

}
- (void)setPickerViewFrame
{
    /**
     *  设置pickViewBg 的frame适应屏幕尺寸
     */
    _pickerViewBg.backgroundColor = [UIColor EKColorBackground];
    CGRect rect = _pickerViewBg.frame;
    rect.size.width = SCREEN_WIDTH;
    _pickerViewBg.frame = rect;
    
    
    UIView *pickerView = (UIView *)[_pickerViewBg viewWithTag:10];
    for (UIView *label in pickerView.subviews) {
        label.backgroundColor = [UIColor EKColorNavigation];
    }

}
- (void)loadDatas
{

    _pickerData = [NSMutableArray array];
    _picData = [NSMutableArray array];
    _pickRow = 0;
    _pickIndex = 0;
    _moveID = 0;
    _threadtypeid = 0;
    _pickTitle = @"請選擇";
    _arrayData = @[@"將要移動",
                   @"目標版塊",
                   @"操作原因"
                   ];

    
  
}

- (void)dataTrandsGroup:(NSArray *)arrData
{
    /**
     *  遍历一级板块
     */
    [arrData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        /**
         *  取出二级板块数组
         */
        NSMutableArray *tempData = [NSMutableArray array];
        NSMutableDictionary *dicObj = [NSMutableDictionary dictionaryWithDictionary:obj];
        NSArray *arrSubforums = obj[@"subforums"];
        
        /**
         *  遍历二级板块数据
         */
        [arrSubforums enumerateObjectsUsingBlock:^(NSDictionary *subforumsDict, NSUInteger idx, BOOL *stop) {
            
            //取出子数据
            NSArray *subforum = subforumsDict[@"subforum"];
            
            //存放临时数组中
            [tempData addObject:subforumsDict];
            
            
            NSArray *threadclass = subforumsDict[@"threadclass"];
            
            [threadclass enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *name = [NSString stringWithFormat:@"[%@]",obj[@"name"]];
                [tempData addObject:@{@"typeid":obj[@"typeid"],@"name":name,@"fid":subforumsDict[@"fid"],@"fname":subforumsDict[@"name"]}];
            }];
            
            
            /**
             *  遍历三级板块数据
             */
            [subforum enumerateObjectsUsingBlock:^(NSDictionary *subforumDic, NSUInteger idx, BOOL *stop) {
                /**
                 *  二级板块中添加三级板块
                 */
                NSString *name = [NSString stringWithFormat:@"-%@",subforumDic[@"name"]];
                
                
                [tempData addObject:@{@"fid":subforumDic[@"fid"],@"name":name,@"type":subforumDic[@"type"],@"ispassword":subforumDic[@"ispassword"]}];
                
                
                NSArray *threadclass = subforumDic[@"threadclass"];
                
                [threadclass enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    NSString *name = [NSString stringWithFormat:@"[%@]",obj[@"name"]];
                    [tempData addObject:@{@"typeid":obj[@"typeid"],@"name":name,@"fid":subforumDic[@"fid"],@"fname":subforumDic[@"name"]}];
                }];
            }];
        }];
        
        [dicObj setObject:tempData forKey:@"subforums"];
        [_pickerData addObject:dicObj];
        
    }];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:_pickerData options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    DLog(@"json = %@",json);
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navRightBarItem];
    [self setPickerViewFrame];
    [self loadDatas];
    [self requestPickViewData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestCauseAction];
}

#pragma mark 提交编辑信息
- (void)didSelectSubmitAction:(UINavigationBar *)item
{
    DLog(@"%ld",(long)_moveID);
    DLog(@"%ld",(long)_threadtypeid);
    
    if (_moveID == 0) {
        [self.view showHUDTitleView:@"請選擇目標版塊" image:nil];
        return;
    }
    
    if (_requiredtype == 1) {
        [self.view showHUDTitleView:@"請選擇分类版塊" image:nil];
        return;
    }

    if ([_textView.text isEqualToString:@""]) {
        [self.view showHUDTitleView:@"請選擇操作原因" image:nil];
        return;
    }
    
    NSDictionary *dicData = @{
                              @"token":TOKEN,
                              @"fid":_dicInfo[@"fid"],
                              @"tid":_dicInfo[@"tid"],
                              @"operation":@"move",
                              @"reason":_textView.text,
                              @"moveto":@(_moveID),
                              @"threadtypeid":@(_threadtypeid),
                              @"sendreasonpm":@(1)
                              };
    
    [self.view showHUDActivityView:@"正在加載..." shade:NO];
    
    [EKHttpUtil mHttpWithUrl:kManageThemeURL parameter:dicData response:^(BKNetworkModel *model, NSString *netErr) {
        [self.view removeHUDActivity];
      
        if (netErr) {
            [self.view showHUDTitleView:netErr image:nil];
        } else {
            if (model.status == 1) {
  
                //通知主题列表页面，刷新ui
                [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshThemeListNotifation object:nil];
                
                //彈出提示框
                [[[UIAlertView alloc] initWithTitle:nil message:model.message cancelButtonItem:[RIButtonItem itemWithLabel:@"確定" action:^{
                    //返回上頁
                    [self.navigationController popViewControllerAnimated:YES];
                }] otherButtonItems:nil, nil] show];
                
            } else {
                [self.view showHUDTitleView:model.message image:nil];
            }
        }
    }];
}

#pragma mark TableVeiwDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayData.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *defineCell = @"defineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defineCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:defineCell];
        
    }
    [self cellForRowAtTableViewCell:cell indexPath:indexPath];
    return cell;
   
}
- (void)cellForRowAtTableViewCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.detailTextLabel.text = _dicInfo[@"subject"];
        
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row ==1) {
            cell.detailTextLabel.text = _pickTitle;
        }
    }
    
    cell.textLabel.text = _arrayData[indexPath.row];
    
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _pickIndex = 0;
    
    switch (indexPath.row) {
        case 0:   break;
         case 1:
        {
            
            if (_pickerData.count) {
                _componentIndex = 2;
                [_pickerView reloadAllComponents];
                [self showPickView];
                //清空id，重新选择
                _moveID = 0;
                _threadtypeid = 0;
                _requiredtype = 0;
            }else{
                [self.view showHUDTitleView:@"數據加載錯誤，請稍後再試" image:nil];
                [self requestPickViewData];
            }
        }
            break;
        default:
        {
            if (_picData.count) {
                _componentIndex = 1;
                [_pickerView reloadAllComponents];
                [self showPickView];

            }else{
                [self.view showHUDTitleView:@"數據加載錯誤，請稍後再試" image:nil];
                [self requestCauseAction];
            }
        }
            break;
    }
    
}
#pragma  mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length >0) {
        _textLab.hidden = YES;
    }
    return YES;
}
#pragma  mark PickerViewDelegate
- (NSArray *)sectionsNumber
{
    return _pickerData[_pickRow][@"subforums"];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _componentIndex;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

    if (_componentIndex == 2) {
        if (component == 0) {
            return _pickerData.count;
        }
        return [[self sectionsNumber] count];
    }
    return _picData.count;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_componentIndex == 2) {
        if (component == 0) {
            return _pickerData[row][@"name"];
        }
        NSArray *componentArr =  [self sectionsNumber];
        NSString *name = componentArr[row][@"name"];
        return name;
    }
    return [NSString stringWithFormat:@"%@",_picData[row][@"str"]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_componentIndex == 2) {
        if (component == 0) {
            _pickRow = row;
            _pickIndex = 0;
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
        }else{
            _pickIndex = row;
        }
        
    }else{
        _pickIndex = row;
        _textView.text = _picData[row][@"str"];
    }

}
- (void)showPickView
{
    [self clearnBoardKey];
    CGRect rect = _pickerViewBg.frame;
    rect.origin.x = 0;
    rect.origin.y = SCREEN_HEIGHT;
    _pickerViewBg.frame = rect;
    if (!_pickerViewBg.superview) {
        [self.view addSubview:_pickerViewBg];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _pickerViewBg.frame;
        frame.origin.y = SCREEN_HEIGHT - _pickerViewBg.frame.size.height;
        _pickerViewBg.frame = frame;
    }];
    
}
- (void)didHiddenPickerView
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _pickerViewBg.frame;
        rect.origin.y = SCREEN_HEIGHT;
        _pickerViewBg.frame = rect;
        
        
    } completion:^(BOOL finished) {
        [_pickerViewBg removeFromSuperview];
    }];
    
}
- (void)clearnBoardKey
{
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
    }
}
#pragma mark 选择完成操作PickerDate
- (IBAction)didSelectCancelAction:(UIButton *)sender {
    [self didHiddenPickerView];
    
}

#pragma mark 选择完成并保存
- (IBAction)didSelectFinishAction:(UIButton *)sender {
    
    [self didHiddenPickerView];
    
    if (_componentIndex == 1) {
        //选择操作理由说明
        _textView.text = _picData[_pickIndex][@"str"];
        _textLab.hidden = YES;
        return;
    }
    
    //一级模块的数据
    _pickTitle = _pickerData[_pickRow][@"subforums"][_pickIndex][@"name"];
    _moveID = [_pickerData[_pickRow][@"subforums"][_pickIndex][@"fid"] integerValue];
    _requiredtype = [_pickerData[_pickRow][@"subforums"][_pickIndex][@"requiredtype"] integerValue];
    _threadtypeid = [_pickerData[_pickRow][@"subforums"][_pickIndex][@"typeid"] integerValue];
    //选择完后后去，如果是子版块，则去拼接上级板块，同理如果是子类分级也要去拼接上层两级板块主题
    __block NSInteger level = 0;
    if ([_pickTitle hasPrefix:@"-"]) {
        _pickTitle = [_pickTitle substringFromIndex:1];
    }else if ([_pickTitle hasPrefix:@"["]){
        NSArray *arrData = _pickerData[_pickRow][@"subforums"];
        //        _threadtypeid = [_pickerData[_pickRow][@"subforums"][_pickIndex][@"typeid"] integerValue];
        [arrData enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *name = obj[@"name"];
            
            if ([name isEqualToString:_pickTitle] && _pickIndex == idx) {
                level = 1;
            }
            
            if ( level == 1 ) {
                if ( ![name hasPrefix:@"["] ) {
                    _pickTitle = [_pickTitle stringByAppendingString:name];
                    *stop = true;
                    return ;
                }
            }
            
        }];
    }
    [_tableView reloadData];
}
- (void)requestPickViewData
{
    NSLog(@",,,%@",TOKEN);
    [EKHttpUtil mHttpWithUrl:kForumSimpleURL parameter:@{@"token":TOKEN} response:^(BKNetworkModel *model, NSString *netErr) {
        if (netErr) {
//            [self.view showHUDTitleView:netErr image:nil];
        }else{
            if (model.status) {
                [self dataTrandsGroup:model.data[@"lists"]];
            }
        }
       
    }];

}
- (void)requestCauseAction
{
    //操作理由
    [EKHttpUtil mHttpWithUrl:kReportReasonURL parameter:nil response:^(BKNetworkModel *model, NSString *netErr) {
        if (netErr) {
            
        }else{
            NSArray *items = model.data;
            if ([items isKindOfClass:[NSArray class]] && items.count) {
                [_picData setArray:items];
            }
        }
       
    }];
   
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
    }
}


//从详情页跳转到该页面
+ (void)push:(UIViewController *)vc model:(ThreadsDetailModel *)model{
    MoveThreadViewVC *moveThreadVC = [[MoveThreadViewVC alloc] initWithNibName:@"MoveThreadViewVC" bundle:nil];
    moveThreadVC.dicInfo = @{@"tid":@(model.tid),
                             @"fid":@(model.fid),
                             @"subject":model.subject
                             };
    [vc.navigationController pushViewController:moveThreadVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
