/*
 * 
 * AppClassExtension.h
 * 2010/9/3
 * sodas
 * 
 * Provide extensions to OS-provided classes 
 *
 * Copyright 2010 NTU CSIE Mobile & HCI Lab
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

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