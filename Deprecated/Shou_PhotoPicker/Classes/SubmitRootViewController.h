//
//  SubmitRootViewController.h
//  MGOV
//
//  Created by iphone on 2010/8/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "JSON.h"

@interface SubmitRootViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>{

	NSMutableArray *eventsArray;
	CLLocationManager *locationManager;
	
	NSManagedObjectContext *managedObjectContext;	    

}

@property (nonatomic, retain) NSMutableArray *eventsArray;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;	    


-(void) addEvent:(UIImage *)image;

@end
