//
//  LocationSelectorViewController.m
//  MGOV
//
//  Created by iphone on 2010/8/30.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "LocationSelectorViewController.h"
#import "GlobalVariable.h"
#import "AppMKAnnotation.h"

@implementation LocationSelectorViewController


@synthesize navigationBar, searchBar, mapView;
@synthesize backButton;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	GlobalVariable *shared = [GlobalVariable sharedVariable];
	[mapView setCenterCoordinate:shared.locationManager.location.coordinate animated:YES];
	MKCoordinateRegion region;
	region.center = shared.locationManager.location.coordinate;
	MKCoordinateSpan span;
	span.latitudeDelta = 0.004;
	span.longitudeDelta = 0.004;
	region.span = span;
	[mapView setRegion:region];
	
	AppMKAnnotation *casePlace = [[AppMKAnnotation alloc] initWithCoordinate:region.center andTitle:@"Title test" andSubtitle:@"科科"];
	[mapView addAnnotation:casePlace];
	[casePlace release];
	
}



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
	[mapView release];
	[navigationBar release];
	[searchBar release];
    [super dealloc];
}


@end
