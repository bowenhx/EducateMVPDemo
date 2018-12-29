/**
 -  EKSearchForumCell.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/22.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"搜寻论坛"的论坛cell
 */

#import "EKSearchForumCell.h"
#import "EKSearchForumModel.h"
#import "EKSearchUserModel.h"

@interface EKSearchForumCell ()
@property (weak, nonatomic) IBOutlet UILabel *vSubjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *vAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *vDatelineLabel;
@property (weak, nonatomic) IBOutlet UILabel *vRepliesLabel;
@end

@implementation EKSearchForumCell
- (void)setVModel:(id)vModel {
    [super setVModel:vModel];
    EKSearchForumModel *forumModel = vModel;
    
    _vSubjectLabel.text = forumModel.subject;
    _vAuthorLabel.text = forumModel.author;
    _vDatelineLabel.text = forumModel.dateline;
    _vRepliesLabel.text = forumModel.replies;
}
@end
