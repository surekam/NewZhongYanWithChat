//
//  XHEmotionManagerView.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-3.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHEmotionManagerView.h"

#import "XHEmotionSectionBar.h"

#import "XHEmotionCollectionViewCell.h"
#import "XHEmotionCollectionViewFlowLayout.h"


@interface XHEmotionManagerView () <UICollectionViewDelegate, UICollectionViewDataSource, XHEmotionSectionBarDelegate>

/**
 *  显示表情的collectView控件
 */
@property (nonatomic, weak) UICollectionView *emotionCollectionView;

/**
 *  显示页码的控件
 */
@property (nonatomic, weak) UIPageControl *emotionPageControl;

/**
 *  管理多种类别gif表情的滚动试图
 */
@property (nonatomic, weak) XHEmotionSectionBar *emotionSectionBar;

/**
 *  当前选择了哪类gif表情标识
 */
@property (nonatomic, assign) NSInteger selectedIndex;

/**
 *  配置默认控件
 */
- (void)setup;

@end

@implementation XHEmotionManagerView

- (void)reloadData {
    NSInteger numberOfEmotionManagers = [self.dataSource numberOfEmotionManagers];
    if (!numberOfEmotionManagers) {
        return ;
    }
    
    self.emotionSectionBar.emotionManagers = [self.dataSource emotionManagersAtManager];
    [self.emotionSectionBar reloadData];
    
    
    XHEmotionManager *emotionManager = [self.dataSource emotionManagerForColumn:self.selectedIndex];
    NSInteger numberOfEmotions = emotionManager.emotions.count;
    self.emotionPageControl.numberOfPages = (numberOfEmotions / (kXHEmotionPerRowItemCount * 3) + (numberOfEmotions % (kXHEmotionPerRowItemCount * 3) ? 1 : 0));
    
    
    [self.emotionCollectionView reloadData];
    [self.emotionCollectionView setContentOffset:CGPointZero animated:YES];
}

- (void)deleteEmotionButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didDeleteEmotionButtonClicked)]) {
        [self.delegate didDeleteEmotionButtonClicked];
    }
}


#pragma mark - Life cycle

- (void)setup {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
    self.isShowEmotionStoreButton = NO;
    
    
    if (!_emotionCollectionView) {
        UICollectionView *emotionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - kXHEmotionPageControlHeight - kXHEmotionSectionBarHeight) collectionViewLayout:[[XHEmotionCollectionViewFlowLayout alloc] init]];
        emotionCollectionView.backgroundColor = self.backgroundColor;
        [emotionCollectionView registerClass:[XHEmotionCollectionViewCell class] forCellWithReuseIdentifier:kXHEmotionCollectionViewCellIdentifier];
        emotionCollectionView.showsHorizontalScrollIndicator = NO;
        emotionCollectionView.showsVerticalScrollIndicator = NO;
        [emotionCollectionView setScrollsToTop:NO];
        emotionCollectionView.pagingEnabled = YES;
        emotionCollectionView.delegate = self;
        emotionCollectionView.dataSource = self;
        [self addSubview:emotionCollectionView];
        self.emotionCollectionView = emotionCollectionView;
    }
    
    if (!_emotionPageControl) {
        UIPageControl *emotionPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.emotionCollectionView.frame), CGRectGetWidth(self.bounds), kXHEmotionPageControlHeight)];
        emotionPageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.471 alpha:1.000];
        emotionPageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.678 alpha:1.000];
        emotionPageControl.backgroundColor = self.backgroundColor;
        emotionPageControl.hidesForSinglePage = YES;
        emotionPageControl.defersCurrentPageDisplay = YES;
        [self addSubview:emotionPageControl];
        self.emotionPageControl = emotionPageControl;
    }
    
    if (!_emotionSectionBar) {
        XHEmotionSectionBar *emotionSectionBar = [[XHEmotionSectionBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.emotionPageControl.frame), CGRectGetWidth(self.bounds), kXHEmotionSectionBarHeight) showEmotionStoreButton:self.isShowEmotionStoreButton];
        emotionSectionBar.delegate = self;
        emotionSectionBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        emotionSectionBar.backgroundColor = [UIColor colorWithWhite:0.886 alpha:1.000];
        [self addSubview:emotionSectionBar];
        self.emotionSectionBar = emotionSectionBar;
    }
    //self.emotionCollectionView.backgroundColor = [UIColor yellowColor];
}

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)dealloc {
    self.emotionPageControl = nil;
    self.emotionSectionBar = nil;
    self.emotionCollectionView.delegate = nil;
    self.emotionCollectionView.dataSource = nil;
    self.emotionCollectionView = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self reloadData];
    }
}

#pragma mark - XHEmotionSectionBar Delegate

- (void)didSelecteEmotionManager:(XHEmotionManager *)emotionManager atSection:(NSInteger)section {
    self.selectedIndex = section;
    self.emotionPageControl.currentPage = 0;
    [self reloadData];
}

- (void)didEmotionSendButtonClicked {
    if ([self.delegate respondsToSelector:@selector(didSendEmotion)]) {
        [self.delegate didSendEmotion];
    }
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    //根据当前的坐标与页宽计算当前页码
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    [self.emotionPageControl setCurrentPage:currentPage];
    
    CGFloat contentWidth = self.emotionCollectionView.contentSize.width;
    if (pageWidth * self.emotionPageControl.numberOfPages - contentWidth > pageWidth/2) {
        self.emotionCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, pageWidth * self.emotionPageControl.numberOfPages - contentWidth);
    }
//    NSLog(@"contentSize=%f,%f", self.emotionCollectionView.contentSize.width, self.emotionCollectionView.contentSize.height);
//    NSLog(@"contentInset=%f,%f,%f,%f", self.emotionCollectionView.contentInset.top, self.emotionCollectionView.contentInset.left, self.emotionCollectionView.contentInset.bottom, self.emotionCollectionView.contentInset.right);
}

#pragma UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.emotionPageControl.numberOfPages;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return kXHEmotionPerRowItemCount * 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XHEmotionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXHEmotionCollectionViewCellIdentifier forIndexPath:indexPath];
    XHEmotionManager *emotionManager = [self.dataSource emotionManagerForColumn:self.selectedIndex];
    
    NSInteger currentIndex = indexPath.section * kXHEmotionPerRowItemCount * 3 + indexPath.row;
    NSArray *contentSubViews = [cell.contentView subviews];
    for (UIView *subView in contentSubViews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [subView removeFromSuperview];
        }
    }
    
    if (indexPath.row == kXHEmotionPerRowItemCount * 3 - 1) {
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        [deleteButton setImage:Image(@"face_delete") forState:UIControlStateNormal];
        [deleteButton setImage:Image(@"face_delete_pressed") forState:UIControlStateSelected];
        deleteButton.contentMode = UIViewContentModeCenter;
        deleteButton.backgroundColor = [UIColor clearColor];

        [deleteButton addTarget:self action:@selector(deleteEmotionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.emotion = nil;
        [cell.contentView addSubview:deleteButton];
    } else if (currentIndex - indexPath.section > emotionManager.emotions.count - 1) {
        cell.emotion = nil;
    } else {
        cell.emotion = emotionManager.emotions[currentIndex - indexPath.section];
    }

    return cell;
}

#pragma mark - UICollectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelecteEmotion:atIndexPath:)]) {
        XHEmotionManager *emotionManager = [self.dataSource emotionManagerForColumn:self.selectedIndex];
        NSInteger currentIndex = indexPath.section * kXHEmotionPerRowItemCount * 3 + indexPath.row - indexPath.section;
        if (currentIndex < emotionManager.emotions.count) {
            [self.delegate didSelecteEmotion:emotionManager.emotions[currentIndex] atIndexPath:indexPath];
        }
    }
}

@end
