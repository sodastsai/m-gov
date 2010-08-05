//
//  TempView.h
//  StreetFix
//
//  Created by Eric Liou on 7/28/10.
//  Copyright 2010 SAS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CameraView : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
	IBOutlet UITextField *doneButtonPressed;
	NSMutableDictionary *photos;
	NSArray *arr1;
}

@property (nonatomic, retain) IBOutlet UITextField *doneButtonPressed;
@property (nonatomic, retain) NSDictionary *photos;
@property (nonatomic, retain) NSArray *arr1;

-(void)takePhoto;


@end
