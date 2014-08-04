//
//  UIImage+ImageWithColour.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-7-31.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "UIImage+ImageWithColour.h"

@implementation UIImage (ImageWithColour)
+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
