//
//  ManageReportTableViewCell.m
//  BKMobile
//
//  Created by bowen on 15/12/18.
//  Copyright © 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "ManageReportTableViewCell.h"
#import "ReportModel.h"

@implementation ManageReportTableViewCell
{
    __weak IBOutlet UILabel *labReport;
    
    __weak IBOutlet UILabel *labExcuse;
    
    
    __weak IBOutlet UILabel *vExcLabel;

    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    _labFruitStatus.textColor = [UIColor EKColorNavigation];
    
    _btnDelete.layer.cornerRadius = _btnDelete.h / 2;
    _btnDispose.layer.cornerRadius = _btnDispose.h / 2;
}



-(void)refreshView:(ReportModel *)model
{
    labExcuse.text = [NSString stringWithFormat:@"%@：%@",model.author,model.subject];
   
    NSString *str = nil;
    if ([model.msglist isKindOfClass:[NSArray class]]) {
        str = [model.msglist componentsJoinedByString:@"\n"];
    }else if ([model.msglist isKindOfClass:[NSString class]])
    {
        str = model.msglist;
    }
    
    vExcLabel.text = str;
    
    if (!_labFruitStatus.hidden) {
        _labFruitStatus.text = model.opresult;
        [_btnDispose setTitle:@"刪除" forState:UIControlStateNormal];
    }
    
    
}


@end
