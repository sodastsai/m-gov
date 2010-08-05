//
//  PhotoPicker.h
//  StreetFix
//
//  Created by Eric Liou on 7/29/10.
//  Copyright 2010 SAS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PhotoPicker : UIViewController 
{
	UIImagePickerController *pick;
}

@property (nonatomic, retain) UIImagePickerController *pick;

@end
