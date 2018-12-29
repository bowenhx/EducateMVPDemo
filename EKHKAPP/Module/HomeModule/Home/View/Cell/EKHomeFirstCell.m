//
//  EKHomeFirstCell.m
//  EKHKAPP
//
//  Created by ligb on 2017/9/14.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import "EKHomeFirstCell.h"

@interface EKHomeFirstCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;


@end


@implementation EKHomeFirstCell

- (void)setVHomeThreadModel:(EKHomeThreadModel *)vHomeThreadModel {
    _vHomeThreadModel = vHomeThreadModel;
    
    _titleLabel.text = vHomeThreadModel.title;
    _authorLabel.text = vHomeThreadModel.username;
    _timeLabel.text = vHomeThreadModel.dateline;
    _reviewLabel.text = vHomeThreadModel.reply;
}

@end
