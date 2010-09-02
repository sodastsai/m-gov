//
//  LocationSelectorViewController.m
//  MGOV
//
//  Created by Shou on 2010/8/30.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "LocationSelectorViewController.h"
#import "GlobalVariable.h"
#import "AppMKAnnotation.h"
#import "AppMKAnnotationView.h"

@implementation LocationSelectorViewController

@synthesize delegate;
@synthesize titleBar, mapView, barTitle;
@synthesize selectedAddress, selectedCoord;
@synthesize bottomBar;

#pragma mark -
#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)MapView viewForAnnotation:(id <MKAnnotation>)annotation {
	static NSString * const kPinAnnotationIdentifier = @"PinIdentifier";
	MKAnnotationView *draggablePinView = [MapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
	
	if (draggablePinView) {
		draggablePinView.annotation = annotation;
	} else {		
		draggablePinView = [[[AppMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier] autorelease];
		if ([draggablePinView isKindOfClass:[AppMKAnnotationView class]]) {
			((AppMKAnnotationView *)draggablePinView).AmapView = MapView;
		}
	}
	return draggablePinView;
}

- (void)mapView:(MKMapView *)MapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
	if ( oldState == MKAnnotationViewDragStateDragging && newState == MKAnnotationViewDragStateEnding ) {
		// Update annotation subtitle
		[self updatingAddress:annotationView.annotation];
		// Update the center of mapview to annotation point
		[MapView setCenterCoordinate:annotationView.annotation.coordinate animated:YES];
	}
}


#pragma mark -
#pragma mark Location Selector method

- (void) updatingAddress:(AppMKAnnotation *)annotation{
	// Use Google API to transform Latitude & Longitude to the corresponding address  
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?latlng=%f,%f&sensor=true&language=zh-TW", annotation.coordinate.latitude, annotation.coordinate.longitude]];
	NSString *str = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	NSDictionary *dict = [str JSONValue];
	NSString *address = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@", [[[dict objectForKey:@"results"] objectAtIndex:0] objectForKey:@"formatted_address"]]];
	selectedAddress.text = address;
	[annotation setSubtitle:address];
	[url release];
	[str release];	
	[address release];
	selectedCoord = annotation.coordinate;
}

- (void) transformCoordinate {
	[delegate userDidSelectDone:selectedCoord];
}

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate {
	selectedCoord = coordinate;
	return [self init];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];

	[mapView setCenterCoordinate:selectedCoord animated:YES];
	MKCoordinateRegion region;
	region.center = selectedCoord;
	MKCoordinateSpan span;
	span.latitudeDelta = 0.004;
	span.longitudeDelta = 0.004;
	region.span = span;
	[mapView setRegion:region];
	
	AppMKAnnotation *casePlace = [[AppMKAnnotation alloc] initWithCoordinate:selectedCoord andTitle:@"Title test" andSubtitle:@"科科"];
	[mapView addAnnotation:casePlace];
	[self updatingAddress:casePlace];
	[casePlace release];
	
	// OK, Cancel
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"確定" style:UIBarButtonItemStyleBordered target:self action:@selector(transformCoordinate)];
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:delegate action:@selector(userDidSelectCancel)];
	doneButton.width = 149;
	cancelButton.width = 149;
	[bottomBar setItems:[NSArray arrayWithObjects:doneButton, cancelButton, nil] animated:YES];
	[doneButton release];
	[cancelButton release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	// MapView could not release
	[titleBar release];
	[barTitle release];
	[selectedAddress release];
	[bottomBar release];
    [super dealloc];
}


@end
