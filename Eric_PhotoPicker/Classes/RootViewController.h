//
//  MapViewController.h
//  Locations
//
//  Created by Eric Liou on 8/2/10.
//  Copyright 2010 SAS. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "Photo.h"

@class Photo;

@interface RootViewController : UITableViewController <CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
	
    NSMutableArray *eventsArray;
	NSManagedObjectContext *managedObjectContext;	    
    CLLocationManager *locationManager;
    UIBarButtonItem *addButton;
	UIImage *tempImage;
	Photo *tempPhoto;
}

@property (nonatomic, retain) NSMutableArray *eventsArray;
@property (nonatomic, retain) UIImage *tempImage;
@property (nonatomic, retain) Photo *tempPhoto;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;	    
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) UIBarButtonItem *addButton;

- (void)addEvent;

@end
