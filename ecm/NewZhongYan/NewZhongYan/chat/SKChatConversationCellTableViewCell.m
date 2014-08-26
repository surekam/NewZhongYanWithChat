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
        _headImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, 155, 20)];
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 32, 245, 20)];
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 4, 80, 20)];
        
        _headImg.layer.cornerRadius = 5;
        _headImg.layer.masksToBounds = NO;
        _headImg.layer.borderWidth = 1.0;
        _headImg.layer.borderColor = [UIColor blackColor].CGColor;
        
        _nameLabel.font=[UIFont boldSystemFontOfSize:15];
        _nameLabel.textColor = [UIColor blackColor];
        
        _msgLabel.font= [UIFont systemFontOfSize:12];
        _msgLabel.textColor = [UIColor grayColor];
        
        
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:_headImg];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_msgLabel];
        [self.contentView addSubview:_timeLabel];
        
        badgeView = [[JSBadgeView alloc] initWithParentView:_headImg alignment:JSBadgeViewAlignmentTopRight];
        badgeView.badgePositionAdjustment = CGPointMake(badgeView.frame.origin.x-5, badgeView.frame.origin.y+5);
        badgeView.clearsContextBeforeDrawing = YES;
        
    }
    return self;
}

- (void)setTime:(NSDate *)msgTime
{
    if (msgTime) {
        self.timeLabel.text = [msgTime datetoIMDate];
    }
}

- (void)setUnreadNum:(NSString *)unreadNum
{
    if ([unreadNum intValue] > 0) {
        _unreadNum = unreadNum;
        badgeView.badgeText = unreadNum;
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
