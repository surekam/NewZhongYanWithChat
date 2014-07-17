//
//  SKHToolBar.m
//  test
//
//  Created by yangz on 14-5-13.
//  Copyright (c) 2014年 yangz. All rights reserved.
//

#import "SKHToolBar.h"


@implementation SKHToolBar
@synthesize remindBtn,emailBtn,addressdBtn,settingBtn,chatBtn;
@synthesize remindLabel,emailLabel,addressdLabel,settingLabel,chatLabel;
@synthesize remindBadge,emailBadge;
@synthesize owner;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = COLOR(247, 247, 247);
        
        //加view上边框的黑线
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 0.5)];
        [view setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:view];
        
        UIView *remindView=[[UIView alloc] initWithFrame:CGRectMake(20, 0, 42, 49)];
        remindView.backgroundColor=[UIColor clearColor];
        remindView.tag=1;
        UITapGestureRecognizer *singleTab =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleOne:)];
        singleTab.numberOfTouchesRequired=1;
        singleTab.numberOfTapsRequired=1;
        [remindView addGestureRecognizer:singleTab];
        [self addSubview:remindView];
        
        remindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        remindBtn.userInteractionEnabled=NO;
        [remindBtn setImage:Image(@"remind") forState:UIControlStateNormal];
        [remindBtn setImage:Image(@"remind_highnight") forState:UIControlStateSelected];
        [remindBtn setImage:Image(@"remind_highnight") forState:UIControlStateHighlighted];
        [remindBtn setFrame:CGRectMake(8, 9, 25, 25)];
        [remindView addSubview:remindBtn];
        
        remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 42, 21)];
        remindLabel.text = @"待办";
        remindLabel.textAlignment = NSTextAlignmentCenter;
        remindLabel.backgroundColor = [UIColor clearColor];
        remindLabel.font = [UIFont systemFontOfSize:13];
        [remindView addSubview:remindLabel];
        
        remindBadge= [[JSBadgeView alloc] initWithParentView:remindBtn alignment:JSBadgeViewAlignmentTopRight];
        //remindBadge.badgeText = [NSString stringWithFormat:@"%d", 2];
        
        
        
        
        UIView *emailView=[[UIView alloc] initWithFrame:CGRectMake(80, 0, 42, 49)];
        emailView.backgroundColor=[UIColor clearColor];
        emailView.tag=2;
        UITapGestureRecognizer *singleTab1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleOne:)];
        [emailView addGestureRecognizer:singleTab1];
        [self addSubview:emailView];
        
        emailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        emailBtn.userInteractionEnabled=NO;
        [emailBtn setImage:Image(@"email") forState:UIControlStateNormal];
        [emailBtn setImage:Image(@"email_highnight") forState:UIControlStateSelected];
        [emailBtn setImage:Image(@"email_highnight") forState:UIControlStateHighlighted];
        [emailBtn setFrame:CGRectMake(8, 9, 25, 25)];
        [emailView addSubview:emailBtn];
        
        emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 42, 21)];
        emailLabel.text = @"邮件";
        emailLabel.textAlignment = NSTextAlignmentCenter;
        emailLabel.backgroundColor = [UIColor clearColor];
        emailLabel.font = [UIFont systemFontOfSize:13];
        [emailView addSubview:emailLabel];
        
        emailBadge = [[JSBadgeView alloc] initWithParentView:emailBtn alignment:JSBadgeViewAlignmentTopRight];
        //emailBadge.badgeText = [NSString stringWithFormat:@"%d", 2];
        
        
        UIView *addressdView=[[UIView alloc] initWithFrame:CGRectMake(140, 0, 42, 49)];
        addressdView.backgroundColor=[UIColor clearColor];
        addressdView.tag=3;
        UITapGestureRecognizer *singleTab2 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleOne:)];
        [addressdView addGestureRecognizer:singleTab2];
        [self addSubview:addressdView];
        addressdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addressdBtn.userInteractionEnabled=NO;
        [addressdBtn setImage:Image(@"address") forState:UIControlStateNormal];
        [addressdBtn setImage:Image(@"address_highnight") forState:UIControlStateSelected];
        [addressdBtn setImage:Image(@"address_highnight") forState:UIControlStateHighlighted];
        [addressdBtn setFrame:CGRectMake(8, 9, 25, 25)];
        [addressdView addSubview:addressdBtn];
        
        addressdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 42, 21)];
        addressdLabel.text = @"通讯录";
        addressdLabel.textAlignment = NSTextAlignmentCenter;
        addressdLabel.backgroundColor = [UIColor clearColor];
        addressdLabel.font = [UIFont systemFontOfSize:13];
        [addressdView addSubview:addressdLabel];
        
        
        
        
        UIView *settingView=[[UIView alloc] initWithFrame:CGRectMake(200, 0, 42, 49)];
        settingView.backgroundColor=[UIColor clearColor];
        settingView.tag=4;
        UITapGestureRecognizer *singleTab3 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleOne:)];
        [settingView addGestureRecognizer:singleTab3];
        [self addSubview:settingView];
        settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        settingBtn.userInteractionEnabled=NO;
        [settingBtn setImage:Image(@"setting") forState:UIControlStateNormal];
        [settingBtn setImage:Image(@"setting_highnight") forState:UIControlStateSelected];
        [settingBtn setImage:Image(@"setting_highnight") forState:UIControlStateHighlighted];
        [settingBtn setFrame:CGRectMake(8, 9, 25, 25)];
        [settingView addSubview:settingBtn];
        
        settingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 42, 21)];
        settingLabel.text = @"设置";
        settingLabel.textAlignment = NSTextAlignmentCenter;
        settingLabel.backgroundColor = [UIColor clearColor];
        settingLabel.font = [UIFont systemFontOfSize:13];
        [settingView addSubview:settingLabel];
        
        
        
        //chat
        UIView *chatView = [[UIView alloc] initWithFrame:CGRectMake(260, 0, 42, 49)];
        chatView.backgroundColor = [UIColor clearColor];
        chatView.tag = 5;
        UITapGestureRecognizer *singleTab4 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleOne:)];
        [chatView addGestureRecognizer:singleTab4];
        [self addSubview:chatView];
        chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chatBtn.userInteractionEnabled=NO;
        [chatBtn setImage:Image(@"btn_sms_ecm") forState:UIControlStateNormal];
        [chatBtn setImage:Image(@"btn_sms_ecm_press") forState:UIControlStateSelected];
        [chatBtn setImage:Image(@"btn_sms_ecm_press") forState:UIControlStateHighlighted];
        [chatBtn setFrame:CGRectMake(8, 9, 25, 25)];
        [chatView addSubview:chatBtn];
        
        chatLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 42, 21)];
        chatLabel.text = @"聊天";
        chatLabel.textAlignment = NSTextAlignmentCenter;
        chatLabel.backgroundColor = [UIColor clearColor];
        chatLabel.font = [UIFont systemFontOfSize:13];
        [chatView addSubview:chatLabel];
    }
    return self;
}

-(void)singleOne:(UITapGestureRecognizer *)sender
{
    UIView *view=sender.view;
    
    //UIButton *btn=[view.subviews objectAtIndex:0];
    //btn.selected=YES;
    //[self performSelector:@selector(delayMethod:) withObject:btn afterDelay:0.3f];
    //NSLog(@"%ld",(long)view.tag);
    if (owner && [owner respondsToSelector:@selector(onSingleOneDone:)])
    {
     [owner onSingleOneDone:view.tag];
    }
    
}


-(void)delayMethod:(UIButton *)btn
{
    btn.selected=NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
