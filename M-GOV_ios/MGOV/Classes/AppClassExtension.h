//
//  AppClassExtension.h
//  MGOV
//
//  Created by sodas on 2010/9/3.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AppExtension) 

- (UIImage *)scaleToSize:(CGSize)newSize;
- (UIImage *)scaleProportionlyToWidth:(CGFloat)width;
- (UIImage *)scaleProportionlyToHeight:(CGFloat)height;
- (UIImage *)cropToRect:(CGRect)newRect;
- (UIImage *)fitToSize:(CGSize)newSize;
- (UIImage *)fixImageSize;
- (UIImage *)cropToRect:(CGRect)newRect;

@end

@interface NSDate (AppExtension)

+ (NSDate *)dateFromROCFormatString:(NSString *)ROCdate;

@end

float DegreesToRadians(float degree);