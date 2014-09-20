//
//  SKChatConversationCellTableViewCell.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-4.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKChatConversationCellTableViewCell.h"
#import "JSBadgeView.h"

@implementation SKChatConversationCellTableViewCell
@synthesize headImg = _headImg;
@synthesize nameLabel = _nameLabel;
@synthesize msgLabel = _msgLabel;
@synthesize timeLabel = _timeLabel;
@synthesize unreadNum = _unreadNum;

JSBadgeView *badgeView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 150, 20)];
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 32, 240, 20)];
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 5, 80, 20)];
        UIView* imgContentView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        _headImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [imgContentView addSubview:_headImg];
        
        _headImg.layer.cornerRadius = 5;
        _headImg.layer.masksToBounds = NO;
        _headImg.layer.borderWidth = 1.0;
        _headImg.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        _nameLabel.font=[UIFont boldSystemFontOfSize:15];
        _nameLabel.textColor = [UIColor blackColor];
        
        _msgLabel.font= [UIFont systemFontOfSize:12];
        _msgLabel.textColor = [UIColor grayColor];
        
        
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:imgContentView];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_msgLabel];
        [self.contentView addSubview:_timeLabel];
        
        badgeView = [[JSBadgeView alloc] initWithParentView:imgContentView alignment:JSBadgeViewAlignmentTopRight];
        badgeView.badgePositionAdjustment = CGPointMake(badgeView.frame.origin.x-3, badgeView.frame.origin.y+3);
         badgeView.clearsContextBeforeDrawing = YES;
    }
    return self;
}

- (void)setTime:(NSDate *)msgTime
{
    if (msgTime) {
        self.timeLabel.text = [msgTime dateToConversationListDate];
    }
}

- (void)setUnreadNum:(NSString *)unreadNum
{
    if ([unreadNum intValue] > 0) {
        _unreadNum = unreadNum;
        badgeView.badgeText = [unreadNum intValue] > 99 ? @"99+" : unreadNum;
    }
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
@end
