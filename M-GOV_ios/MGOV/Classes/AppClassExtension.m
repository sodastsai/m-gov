/*
 * 
 * AppClassExtension.m
 * 2010/9/3
 * sodas
 * 
 * Provide extensions to OS-provided classes 
 *
 * ==UIImage==
 *  The drawRect in next two method means the new place and size to draw the image in CGContextDrawImage
 *  And the image will draw again in context which is defined with the new CGSize
 *  So since the size of new image is defined and the image will draw again following the rect.
 *  The image could be scale and crop.
 *
 *  More clearly, the context is the new canvs. And the drawRect is the copy of original image.
 *  Since the drawRect wass the alter of original image, the size of the drawRect is the size of the new image,
 *  and the origin of the drawRect is the point where start to draw the image.
 *  So it will follow the drawRect to draw the image in context
 *
 *  And Here's some strange bug while take a new photo in portrait mode,
 *  In order to fix this, you must run fixImageSize first.
 *  This is already combined into following scale and crop methods.
 *
 * ==NSDate==
 *  Convert ROC year to A.D.
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

#import "AppClassExtension.h"

@implementation UIImage (AppExtension)

#pragma mark -
#pragma mark Basic

- (UIImage*)fixImageSize {
	// Fix some strange bug
	UIGraphicsBeginImageContext(self.size);
	[self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

float DegreesToRadians(float degree) {
	return degree/180*M_PI;
}

#pragma mark -
#pragma mark Fit (Combination)

- (UIImage *)fitToSize:(CGSize)newSize {
	float originalProportion = self.size.width/self.size.height;
	float targetProportion = newSize.width/newSize.height;
	float scaleProportion = newSize.width/self.size.width;
	UIImage *targetImage;
	
	if (targetProportion == originalProportion) {
		// Same Proportion
		// Do not have to crop, Direct scale
		targetImage = [self scaleToSize:newSize];
	} else if (targetProportion < originalProportion) {
		// Relative Landscape
		// Crop Rect
		CGFloat originX = self.size.width*scaleProportion/2 - newSize.width/2;
		CGRect cropRect = CGRectMake(originX, 0, newSize.width, newSize.height);
		// Scale to Height, Crop
		targetImage = [[self scaleProportionlyToHeight:newSize.height] cropToRect:cropRect];
	} else {
		// Relative Portrait
		// Scale to Width
		CGFloat originY = self.size.height*scaleProportion/2 - newSize.height/2;
		CGRect cropRect = CGRectMake(0, originY, newSize.width, newSize.height);
		targetImage = [[self scaleProportionlyToWidth:newSize.width] cropToRect:cropRect];
	}
	
	return targetImage;
}

#pragma mark -
#pragma mark Scale

- (UIImage *)scaleToSize:(CGSize)newSize {
	UIImage *targetImage = [self fixImageSize];
	// Prepare new size context
	UIGraphicsBeginImageContext(newSize);
	// Get current image
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// Change the coordinate from CoreGraphics (Quartz2D) to UIView
	CGContextTranslateCTM(context, 0.0, newSize.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	// Draw (Scale)
	// The size of this drawRect is for scale
	CGRect drawRect = CGRectMake(0, 0, newSize.width, newSize.height);
	CGContextDrawImage(context, drawRect, targetImage.CGImage);
	
	// Get result and clean
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return scaledImage;
}

- (UIImage *)scaleProportionlyToWidth:(CGFloat)width {
	float originalProportion = self.size.width/self.size.height;
	CGFloat height = width/originalProportion;
	return [self scaleToSize:CGSizeMake(width, height)];
}

- (UIImage *)scaleProportionlyToHeight:(CGFloat)height {
	float originalProportion = self.size.width/self.size.height;
	CGFloat width = height*originalProportion;
	return [self scaleToSize:CGSizeMake(width, height)];
}

#pragma mark -
#pragma mark Rotate

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees 
{   
	// calculate the size of the rotated view's containing box for our drawing space
	UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
	CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
	rotatedViewBox.transform = t;
	CGSize rotatedSize = rotatedViewBox.frame.size;
	[rotatedViewBox release];
	
	// Create the bitmap context
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	
	// Move the origin to the middle of the image so we will rotate and scale around the center.
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	
	//   // Rotate the image context
	CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
	
	// Now, draw the rotated/scaled image into the context
	CGContextScaleCTM(bitmap, 1.0, -1.0);
	CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
	
}

#pragma mark -
#pragma mark Crop

- (UIImage *)cropToRect:(CGRect)newRect {
	UIImage *targetImage = [self fixImageSize];
	// Prepare new rect context
	UIGraphicsBeginImageContext(newRect.size);
	// Get current image
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// Change the coordinate from CoreGraphics (Quartz2D) to UIView
	CGContextTranslateCTM(context, 0.0, newRect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	// Draw (Crop)
	// This drawRect is for crop
	CGRect clippedRect = CGRectMake(0, 0, newRect.size.width, newRect.size.height);
	CGContextClipToRect(context, clippedRect);
	CGRect drawRect = CGRectMake(newRect.origin.x*(-1), newRect.origin.y*(-1), targetImage.size.width, targetImage.size.height);
	CGContextDrawImage(context, drawRect, targetImage.CGImage);
	
	UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return croppedImage;
}

@end

@implementation NSDate (AppExtension)

+ (NSDate *)dateFromROCFormatString:(NSString *)ROCdate {
	NSString *regEx1 = @"^[0-9.]*";
	NSRange yearRange = [ROCdate rangeOfString:regEx1 options:NSRegularExpressionSearch];
	NSInteger formattedYear = [[ROCdate substringWithRange:yearRange] intValue];
	NSString *restString = [ROCdate substringFromIndex:yearRange.length];
	formattedYear += 1911;
	NSString *formattedDateString = [NSString stringWithFormat:@"%d%@", formattedYear, restString];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
	NSDate *formattedDate = [dateFormatter dateFromString:formattedDateString];
	[dateFormatter release];
	return formattedDate;
}

@end
 