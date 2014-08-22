//
//  SKFourBtnToolBar.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-21.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SKFourBtnToolBarProtocol <NSObject>

-(void)onClickFirstbtn;
-(void)onClickSecondbtn;
-(void)onClickThirdbtn;
-(void)onClickFourthbtn;

@end

@interface SKFourBtnToolBar : UIView
{
    UIButton* homeButton;
    UIButton* firstButton;
    UIButton* secondButton;
    UIButton* thirdButton;
    UIButton* fourthButton;
    UILabel*  firstLabel;
    UILabel*  secondLabel;
    UILabel*  thirdLabel;
    UILabel*  fourthLabel;
    UIImageView *homeBgImageView;
}

@property(nonatomic,strong)UIButton* homeButton;
@property(nonatomic,strong)UIButton* firstButton;
@property(nonatomic,strong)UIButton* secondButton;
@property(nonatomic,retain)UIButton* thirdButton;
@property(nonatomic,retain)UIButton* fourthButton;

@property(nonatomic,strong)UILabel*  firstLabel;
@property(nonatomic,strong)UILabel*  secondLabel;
@property(nonatomic,strong)UILabel*  thirdLabel;
@property(nonatomic,strong)UILabel*  fourthLabel;

-(void)setFirstItem:(NSString*)imageName Title:(NSString*)title;
-(void)setSecondItem:(NSString*)imageName Title:(NSString*)title;
-(void)setThirdItem:(NSString*)imageName Title:(NSString*)title;
-(void)setFourthItem:(NSString*)imageName Title:(NSString*)title;

@end
