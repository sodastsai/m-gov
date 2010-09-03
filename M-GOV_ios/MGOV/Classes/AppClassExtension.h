//
//  AppClassExtension.h
//  MGOV
//
//  Created by sodas on 2010/9/3.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AppExtension) 

+ (UIImage *)scaleImage:(UIImage*)originalImage ToSize:(CGSize)newSize;

@end