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
        self.itemSize = CGSizeMake(kXHEmotionImageViewSize, kXHEmotionImageViewSize);
        self.minimumLineSpacing = kXHEmotionMinimumLineSpacing;
        self.sectionInset = UIEdgeInsetsMake(kXHEmotionMinimumLineSpacing - 4, kXHEmotionMinimumLineSpacing, 0, kXHEmotionMinimumLineSpacing);
        self.collectionView.alwaysBounceVertical = YES;
    }
    return self;
}


- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    for(int i = 1; i < [answer count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = answer[i - 1];
        CGFloat maximumSpacing = kXHEmotionMinimumLineSpacing;
        CGFloat origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            if (i == 1 || i == 8 || i == 15) {
                CGRect frame = currentLayoutAttributes.frame;
                frame.origin.x = origin + maximumSpacing;
                currentLayoutAttributes.frame = frame;
            }
        }
    }
    return answer;
}


//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UICollectionViewLayoutAttributes *attr = [super layoutAttributesForItemAtIndexPath:indexPath];
//    if (indexPath.row == 22) {
//        CGRect rect =  attr.frame;
//        attr.frame = CGRectMake(rect.origin.x + kXHEmotionMinimumLineSpacing, rect.origin.y, rect.size.width, rect.size.height);
//    }
//    
//    return attr;
//}

@end
