//
//  InvitationViewCell.m
//  BKMobile
//
//  Created by Guibin on 15/8/3.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "InvitationViewCell.h"

#import "BTextKit.h"


@interface InvitationViewCell ()
{
    __weak IBOutlet NSLayoutConstraint *_nameWidth;
    
    __weak IBOutlet NSLayoutConstraint *_textHeight;
    
    __weak IBOutlet NSLayoutConstraint *_commentHeight;
    
    __weak IBOutlet NSLayoutConstraint *_huodongHeight;
    
    __weak IBOutlet NSLayoutConstraint *_toupiaoHeight;
    
}
@property (weak, nonatomic) IBOutlet UIView  *viewBg;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *lzMarkLab;

@property (weak, nonatomic) IBOutlet UILabel *floorLab;

@property (weak, nonatomic) IBOutlet UILabel *levelLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *appinfo;

@property (weak, nonatomic) IBOutlet UIView  *commentViewBg;

@property (weak, nonatomic) IBOutlet UILabel *commentLineLab;

@property (weak, nonatomic) IBOutlet UIView *huodongView;/**<活動*/

@property (weak, nonatomic) IBOutlet UIView *toupiaoView;/**<投票*/

@end


@implementation InvitationViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.separatorInset = UIEdgeInsetsZero;
    self.lzMarkLab.backgroundColor = @"#ff912f".color;
    self.nameLab.textColor = [UIColor EKColorNavigation];
    self.commentLineLab.backgroundColor = [UIColor EKColorNavigation];
    self.floorLab.textColor = [UIColor EKColorCellLabel];
    self.levelLab.textColor = [UIColor EKColorCellLabel];
    self.appinfo.textColor = [UIColor EKColorCellLabel];
    self.timeLab.textColor = [UIColor EKColorCellLabel];
    [self.reportBtn setTitleColor:[UIColor EKColorCellLabel] forState:UIControlStateNormal];
    [self.editBtn setTitleColor:[UIColor EKColorCellLabel] forState:UIControlStateNormal];
    [self.revertBtn setTitleColor:[UIColor EKColorCellLabel] forState:UIControlStateNormal];
    //设置图片按照原比例显示
    self.iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconBtn.layer.masksToBounds = YES;
    self.iconBtn.layer.cornerRadius = 17;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setItem:(InvitationDataModel *)item{
    _nameWidth.constant = item.lzWidth;
    _textHeight.constant = item.viewHeight;
    self.manageBtn.hidden = YES;
    
    
    //头像
    NSURL *iconURL = [NSURL URLWithString:item.avatar];
    [self.iconBtn sd_setImageWithURL:iconURL
                            forState:UIControlStateNormal
                    placeholderImage:[UIImage imageNamed:kPlaceHolderAvatar]];
    
    //用户名
    self.nameLab.text = item.author;
    
    //楼层
    self.floorLab.text = item.number;
    
    //生產值 和 等级
    self.levelLab.text = item.uniteAutor;
    
    //设备标示
    self.appinfo.text = item.appinfo;
    
    //发帖时间
    self.timeLab.text = item.dateline;
    
    //帖子内容
    self.textView.attributedText = item.attString;
    
    //帖字点评
    [self.commentBtn setAttributedTitle:[self commentTextDescribe:item.commentcount] forState:UIControlStateNormal];
    
    //判断是否为楼主，处理楼主标签
    if (item.first) {
        self.lzMarkLab.hidden = NO;
    }else{
        self.lzMarkLab.hidden = YES;
        NSString *author = [BModelData sharedInstance].author;
        if ([item.author isEqualToString:author]) {
            self.lzMarkLab.hidden = NO;
            _nameWidth.constant = [BModelData sharedInstance].lzWidth;
        }
    }
    
    //添加会员背景色
//    if (item.groupid == 19) {
//        self.viewBg.backgroundColor = [UIColor EKColorMemberFBg];
//    }else{
//        self.viewBg.backgroundColor = [UIColor cellSpace:NO];
//    }
    
    //加载gif 表情动画
    [BTextKit appendGIF:self.textView list:item.smileyInf];
    
    //没有评论不显示评论view
    if ( item.commentcount == 0 ) {
        _commentHeight.constant = 0;
        _commentViewBg.hidden = YES;
    }else{
        _commentHeight.constant = 25;
        _commentViewBg.hidden = NO;
    }
    
    /**
     * 根据权限判断编辑按钮是否显示
     */
//    if ( [BKTool isStringBlank:USERID] ) {
        self.editBtn.hidden = YES;
//    }else{
//        //判斷是否是限制编辑的板块
//        if ( !item.iseditenable ) {
//            self.editBtn.hidden = YES;
//        }else{
//            self.editBtn.hidden = NO;
//        }
//    }

    
    /*
     * 处理活动和投票
     */
    if (_threadType == ThreadTypeActivity) {//如果是活动贴
        //显示活动内容VIEW
        _huodongHeight.constant = kActivityViewHeight;
        _huodongView.hidden = NO;
        //隐藏投票view
        _toupiaoHeight.constant = 0;
        _toupiaoView.hidden = YES;
        
    }else if (_threadType == ThreadTypePolls){//如果是投票贴
        //显示投票view
        _toupiaoView.hidden = NO;
        _toupiaoHeight.constant = kPollsViewHeight;
        
        //隐藏活动内容view
        _huodongHeight.constant = 0;
        _huodongView.hidden = YES;
    }
}


- (NSMutableAttributedString *)commentTextDescribe:(NSInteger)number
{
    NSString *comment = [NSString stringWithFormat:@"共%ld條點評，點擊查看",(long)number];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:comment];
    NSInteger length = attString.length;
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor EKColorNavigation] range:NSMakeRange(6, length-6)];
    return attString;
}
- (void)setThreadType:(ThreadType)threadType{
    _threadType = threadType;
    
    //活动贴判断
    if (_threadType == ThreadTypeActivity) {
        _huodongHeight.constant = kActivityViewHeight;
        _huodongView.hidden = NO;
        
        if (_activityView) {
            
            [_activityView removeFromSuperview];
            _activityView = nil;
            
        }
        
        CGRect aViewRect = CGRectMake(0, 0, SCREEN_WIDTH - 20.0, kActivityViewHeight);
        ActivityViewType aViewType = [_threadacts[@"cost"] isEqualToString:@"0"] ? ActivityViewTypeIsNoCost : ActivityViewTypeIsHaveCost;
        self.activityView = [[ThreadActivityView alloc] initWithFrame:aViewRect withActivityViewType:aViewType];
        [_huodongView addSubview:_activityView];
        [_activityView setThreadacts:_threadacts];
        [_activityView layoutIfNeeded];
        
    }else{
        _huodongHeight.constant = 0;
        _huodongView.hidden = YES;
    }
    
    //投票貼判斷
    if (_threadType == ThreadTypePolls) {
        _toupiaoView.hidden = NO;
        
        if (_pollsView) {
            [_pollsView removeFromSuperview];
            _pollsView = nil;
        }
        CGRect aViewRect = CGRectMake(0, 0, WIDTH(_textView), kPollsViewHeight);
        self.pollsView = [[ThreadPollsView alloc] initWithFrame:aViewRect];
        [_toupiaoView addSubview:_pollsView];
        
    }else{
        _toupiaoHeight.constant = 0;
        _toupiaoView.hidden = YES;
    }
    
}

//- (void)setFrame:(CGRect)frame {
//    frame.size.height -= 2;    // 减掉的值就是分隔线的高度
//    [super setFrame:frame];
//}

@end
