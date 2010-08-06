//
//  MapViewController.m
//  Locations
//
//  Created by Eric Liou on 8/2/10.
//  Copyright 2010 SAS. All rights reserved.
//

#import "MapViewController.h"
#import "Event.h"
#import "Photo.h"
#import "MapViewController.h"


@implementation MapViewController


@synthesize event;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    self.title = @"Map";
	
	map = [[MKMapView alloc] initWithFrame:[self.view bounds]];
	
	map.mapType = MKMapTypeStandard;
	map.showsUserLocation = NO;
	
	CLLocationCoordinate2D coords;
	
	
	coords.latitude = [event.photo.pictureLatitude floatValue];
	coords.longitude = [event.photo.pictureLongitude floatValue];
	
	float zoomLevel = 0.018;
	
	MKCoordinateRegion region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(zoomLevel, zoomLevel));
	[map setRegion:[map regionThatFits:region] animated:YES];
	
	[self.view addSubview:map];

}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
