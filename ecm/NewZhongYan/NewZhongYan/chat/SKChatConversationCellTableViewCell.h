//
//  SKChatConversationCellTableViewCell.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-4.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKChatConversationCellTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headImg;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, copy) NSString *unreadNum;

- (void)setTime:(NSDate *)msgTime;
- (void)setUnreadNum:(NSString *)unreadNum;
@end
