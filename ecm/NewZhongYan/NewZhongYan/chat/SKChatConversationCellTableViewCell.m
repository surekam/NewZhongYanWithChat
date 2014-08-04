//
//  SKChatConversationCellTableViewCell.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-4.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKChatConversationCellTableViewCell.h"

@implementation SKChatConversationCellTableViewCell
@synthesize headImg = _headImg;
@synthesize nameLabel = _nameLabel;
@synthesize msgLabel = _msgLabel;
@synthesize timeLabel = _timeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _headImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 4, 50, 50)];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 50, 20)];
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 32, 50, 20)];
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(255, 5, 50, 20)];
        
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
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
