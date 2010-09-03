//
//  AppClassExtension.m
//  MGOV
//
//  Created by sodas on 2010/9/3.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "AppClassExtension.h"

@implementation UIImage (AppExtension)

/*
 *  The drawRect in next two method means the new place and size to draw the image in CGContextDrawImage
 *  And the image will draw again in context which is defined with the new CGSize
 *  So since the size of new image is defined and the image will draw again following the rect.
 *  The image could be scale and crop.
 *
 *  More clearly, the context is the new canvs. And the drawRect is the copy of original image.
 *  Since the drawRect wass the alter of original image, the size of the drawRect is the size of the new image,
 *  and the origin of the drawRect is the point where start to draw the image.
 *  So it will follow the drawRect to draw the image in context
 */

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

- (UIImage *)scaleToSize:(CGSize)newSize {
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
	CGContextDrawImage(context, drawRect, self.CGImage);
	
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

- (UIImage *)cropToRect:(CGRect)newRect {
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
	CGRect drawRect = CGRectMake(newRect.origin.x*(-1), newRect.origin.y*(-1), self.size.width, self.size.height);
	CGContextDrawImage(context, drawRect, self.CGImage);
	
	UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return croppedImage;
}

@end
