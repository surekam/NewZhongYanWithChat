//
//  XHEmotionSectionBar.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-3.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHEmotionSectionBar.h"
#import "UIImage+ImageWithColour.h"

#define kXHStoreManagerItemWidth 60

@interface XHEmotionSectionBar ()

/**
 *  是否显示表情商店的按钮
 */
@property (nonatomic, assign) BOOL isShowEmotionStoreButton; // default is YES


@property (nonatomic, weak) UIScrollView *sectionBarScrollView;
@property (nonatomic, weak) UIButton *storeManagerItemButton;
@property (nonatomic, weak) UIButton *sendButton;

@end

@implementation XHEmotionSectionBar

- (void)sendButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didEmotionSendButtonClicked)]) {
        [self.delegate didEmotionSendButtonClicked];
    }
}

- (void)sectionButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelecteEmotionManager:atSection:)]) {
        NSInteger section = sender.tag;
        if (section < self.emotionManagers.count) {
            [self.delegate didSelecteEmotionManager:[self.emotionManagers objectAtIndex:section] atSection:section];
        }
    }
}

- (UIButton *)cratedButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(90, 0, kXHStoreManagerItemWidth, CGRectGetHeight(self.bounds));
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:COLOR(229, 229, 233)] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageWithColor:COLOR(229, 229, 233)] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(sectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)reloadData {
    if (!self.emotionManagers.count)
        return;
    
    [self.sectionBarScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (XHEmotionManager *emotionManager in self.emotionManagers) {
        NSInteger index = [self.emotionManagers indexOfObject:emotionManager];
        UIButton *sectionButton = [self cratedButton];
        sectionButton.tag = index;
        [sectionButton setTitle:emotionManager.emotionName forState:UIControlStateNormal];
        [sectionButton setTitleColor:COLOR(0, 97, 194) forState:UIControlStateNormal];
        sectionButton.titleLabel.font = [UIFont systemFontOfSize:14];

        CGRect sectionButtonFrame = sectionButton.frame;
        sectionButtonFrame.origin.x = index * (CGRectGetWidth(sectionButtonFrame));
        sectionButton.frame = sectionButtonFrame;
        
        
        [self.sectionBarScrollView addSubview:sectionButton];
    }
    
    [self.sectionBarScrollView setContentSize:CGSizeMake(self.emotionManagers.count * kXHStoreManagerItemWidth, CGRectGetHeight(self.bounds))];
}

#pragma mark - Lefy cycle

- (void)setup {
    if (!_sectionBarScrollView) {
        CGFloat scrollWidth = CGRectGetWidth(self.bounds);
        if (self.isShowEmotionStoreButton) {
            scrollWidth -= kXHStoreManagerItemWidth;
        }
        UIScrollView *sectionBarScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollWidth, CGRectGetHeight(self.bounds))];
        [sectionBarScrollView setScrollsToTop:NO];
        sectionBarScrollView.showsVerticalScrollIndicator = NO;
        sectionBarScrollView.showsHorizontalScrollIndicator = NO;
        sectionBarScrollView.pagingEnabled = NO;
        [self addSubview:sectionBarScrollView];
        _sectionBarScrollView = sectionBarScrollView;
    }
    
    if (self.isShowEmotionStoreButton) {
        UIButton *storeManagerItemButton = [self cratedButton];
        
        CGRect storeManagerItemButtonFrame = storeManagerItemButton.frame;
        storeManagerItemButtonFrame.origin.x = CGRectGetWidth(self.bounds) - kXHStoreManagerItemWidth;
        storeManagerItemButton.frame = storeManagerItemButtonFrame;
        
        [storeManagerItemButton setTitle:@"商店" forState:UIControlStateNormal];
        [storeManagerItemButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self addSubview:storeManagerItemButton];
        _storeManagerItemButton = storeManagerItemButton;
    }
    if (!_sendButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(CGRectGetWidth(self.bounds) - kXHStoreManagerItemWidth, 0, kXHStoreManagerItemWidth, CGRectGetHeight(self.bounds));
        [button setBackgroundImage:[UIImage imageWithColor:COLOR(0, 124, 237)] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:COLOR(124, 186, 243)] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageWithColor:COLOR(124, 186, 243)] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"发送" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        _sendButton = button;
    }
}

- (instancetype)initWithFrame:(CGRect)frame showEmotionStoreButton:(BOOL)isShowEmotionStoreButtoned {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.isShowEmotionStoreButton = isShowEmotionStoreButtoned;
        [self setup];
    }
    return self;
}

- (void)dealloc {
    self.emotionManagers = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self reloadData];
    }
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
