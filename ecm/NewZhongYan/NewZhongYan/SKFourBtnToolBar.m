//
//  SKFourBtnToolBar.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-21.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKFourBtnToolBar.h"
#import "SKViewController.h"

@implementation SKFourBtnToolBar
@synthesize homeButton,firstButton,secondButton,thirdButton,fourthButton;
@synthesize firstLabel,secondLabel,thirdLabel,fourthLabel;

-(void)backToRoot:(id)sender
{
    SKViewController* controller = [APPUtils AppRootViewController];
    [controller.navigationController popToRootViewControllerAnimated:YES];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR(247, 247, 247);
        homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [homeButton setImage:Image(@"homepage") forState:UIControlStateNormal];
        [homeButton setImage:Image(@"homepage_blue") forState:UIControlStateSelected];
        [homeButton setImage:Image(@"homepage_blue") forState:UIControlStateHighlighted];
        [homeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 8, 0)];
        [homeButton setFrame:CGRectMake(2, 0, 49, 49)];
        [homeButton addTarget:self action:@selector(backToRoot:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:homeButton];
        
        UILabel* homeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        homeLabel.text = @"首页";
        homeLabel.textAlignment = NSTextAlignmentCenter;
        homeLabel.backgroundColor = [UIColor clearColor];
        homeLabel.font = [UIFont systemFontOfSize:10];
        homeLabel.font = [UIFont systemFontOfSize:12];
        CGPoint labelCenter = homeButton.center;
        labelCenter.y += 15;
        [homeLabel setCenter:labelCenter];
        [self addSubview:homeLabel];
        
        //first
        firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [firstButton setFrame:CGRectMake(90, 0, 49, 49)];
        [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 8, 0)];
        [self addSubview:firstButton];
        
        firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        firstLabel.text = @"first";
        firstLabel.textAlignment = NSTextAlignmentCenter;
        firstLabel.backgroundColor = [UIColor clearColor];
        firstLabel.font = [UIFont systemFontOfSize:10];
        firstLabel.font = [UIFont systemFontOfSize:12];
        CGPoint firstLabelCenter = firstButton.center;
        firstLabelCenter.y += 15;
        [firstLabel setCenter:firstLabelCenter];
        [self addSubview:firstLabel];
        
        //second
        secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [secondButton setFrame:CGRectMake(150, 0, 49, 49)];
        [secondButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 8, 0)];
        [self addSubview:secondButton];
        
        secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        secondLabel.text = @"second";
        secondLabel.textAlignment = NSTextAlignmentCenter;
        secondLabel.backgroundColor = [UIColor clearColor];
        secondLabel.font = [UIFont systemFontOfSize:10];
        secondLabel.font = [UIFont systemFontOfSize:12];
        CGPoint secondlabelCenter = secondButton.center;
        secondlabelCenter.y += 15;
        [secondLabel setCenter:secondlabelCenter];
        [self addSubview:secondLabel];
        
        //third
        thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [thirdButton setFrame:CGRectMake(210, 0, 49, 49)];
        [thirdButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 8, 0)];
        [self addSubview:thirdButton];
        
        thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        thirdLabel.text = @"third";
        thirdLabel.textAlignment = NSTextAlignmentCenter;
        thirdLabel.backgroundColor = [UIColor clearColor];
        thirdLabel.font = [UIFont systemFontOfSize:10];
        thirdLabel.font = [UIFont systemFontOfSize:12];
        CGPoint thirdlabelCenter = thirdButton.center;
        thirdlabelCenter.y += 15;
        [thirdLabel setCenter:thirdlabelCenter];
        [self addSubview:thirdLabel];
        
        //fourth
        fourthButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [fourthButton setFrame:CGRectMake(270, 0, 49, 49)];
        [fourthButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 8, 0)];
        [self addSubview:fourthButton];
        
        fourthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        fourthLabel.text = @"fourth";
        fourthLabel.textAlignment = NSTextAlignmentCenter;
        fourthLabel.backgroundColor = [UIColor clearColor];
        fourthLabel.font = [UIFont systemFontOfSize:10];
        fourthLabel.font = [UIFont systemFontOfSize:12];
        CGPoint fourthLabelCenter = fourthButton.center;
        fourthLabelCenter.y += 15;
        [fourthLabel setCenter:fourthLabelCenter];
        [self addSubview:fourthLabel];
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 0.5)];
        [view setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:view];
    }
    return self;
}

-(void)setFirstItem:(NSString*)imageName Title:(NSString*)title
{
    [firstLabel setText:title];
    [firstButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [firstButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_press",imageName]] forState:UIControlStateSelected];
    [firstButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_press",imageName]] forState:UIControlStateHighlighted];
}

-(void)setSecondItem:(NSString*)imageName Title:(NSString*)title
{
    [secondLabel setText:title];
    [secondButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [secondButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_press",imageName]] forState:UIControlStateSelected];
    [secondButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_press",imageName]] forState:UIControlStateHighlighted];
}

-(void)setThirdItem:(NSString*)imageName Title:(NSString*)title
{
    [thirdLabel setText:title];
    [thirdButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [thirdButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_press",imageName]] forState:UIControlStateSelected];
    [thirdButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_press",imageName]] forState:UIControlStateHighlighted];
}

-(void)setFourthItem:(NSString*)imageName Title:(NSString*)title
{
    [fourthLabel setText:title];
    [fourthButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [fourthButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_press",imageName]] forState:UIControlStateSelected];
    [fourthButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_press",imageName]] forState:UIControlStateHighlighted];
}

@end
