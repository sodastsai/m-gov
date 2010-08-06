//
//  MapViewController.h
//  Locations
//
//  Created by Eric Liou on 8/2/10.
//  Copyright 2010 SAS. All rights reserved.
//

@class Event;

@interface EventDetailViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
	Event *event;
	UILabel *timeLabel;
	UILabel *coordinatesLabel;
	UIButton *deletePhotoButton;
	UIImageView *photoImageView;
	
	UIBarButtonItem *mapPush;
	UIToolbar *controlBar;
}

@property (nonatomic, retain) Event *event;

@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UILabel *coordinatesLabel;
@property (nonatomic, retain) IBOutlet UIButton *deletePhotoButton;
@property (nonatomic, retain) IBOutlet UIImageView *photoImageView;

@property (nonatomic, retain) UIBarButtonItem *mapPush;

@property (nonatomic, retain) IBOutlet UIToolbar *controlBar;


- (IBAction)pushSubmit;

- (void)updatePhotoInfo;

@end
