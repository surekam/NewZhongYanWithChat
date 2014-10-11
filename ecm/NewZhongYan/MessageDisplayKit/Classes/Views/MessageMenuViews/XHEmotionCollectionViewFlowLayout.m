//
//  XHEmotionCollectionViewFlowLayout.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-3.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHEmotionCollectionViewFlowLayout.h"

@implementation XHEmotionCollectionViewFlowLayout

- (id)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.itemSize = CGSizeMake(kXHEmotionImageViewSize+14, kXHEmotionImageViewSize+14);
        self.minimumLineSpacing = kXHEmotionMinimumLineSpacing-15;
        self.minimumInteritemSpacing = kXHEmotionMinimumLineSpacing-15;
        self.sectionInset = UIEdgeInsetsMake(kXHEmotionMinimumLineSpacing - 4, kXHEmotionMinimumLineSpacing - 4, kXHEmotionMinimumLineSpacing - 12, kXHEmotionMinimumLineSpacing - 4);
        self.collectionView.alwaysBounceVertical = YES;
    }
    return self;
}

@end
