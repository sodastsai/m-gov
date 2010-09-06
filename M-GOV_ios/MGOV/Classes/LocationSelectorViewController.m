//
//  LocationSelectorViewController.m
//  MGOV
//
//  Created by Shou on 2010/8/30.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "LocationSelectorViewController.h"
#import "MGOVGeocoder.h"

@implementation LocationSelectorViewController

@synthesize delegate;
@synthesize titleBar, mapView, barTitle;
@synthesize selectedAddress, selectedCoord;
@synthesize bottomBar;

#pragma mark -
#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)MapView viewForAnnotation:(id<MKAnnotation>)annotation {
	// Act like table view cells
	static NSString * const pinAnnotationIdentifier = @"PinIdentifier";
	MKPinAnnotationView *draggablePinView = (MKPinAnnotationView *)[MapView dequeueReusableAnnotationViewWithIdentifier:pinAnnotationIdentifier];

	if (draggablePinView) {
		// Already exists
		draggablePinView.annotation = annotation;
	} else {		
		// Renew
		draggablePinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinAnnotationIdentifier] autorelease];
		draggablePinView.draggable = YES;
		draggablePinView.canShowCallout = YES;
		draggablePinView.animatesDrop = YES;
		draggablePinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure] ;
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

- (void) updatingAddress:(AppMKAnnotation *)annotation {
	NSString *address = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@", [MGOVGeocoder returnFullAddress:annotation.coordinate]]];
	selectedAddress.text = address;
	[address release];
	selectedCoord = annotation.coordinate;
}

- (void) transformCoordinate {
	[delegate userDidSelectDone:selectedCoord];
}

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate {
	selectedCoord = coordinate;
	caseImage = nil;
	return [self init];
}

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andImage:(UIImage *)image {
	selectedCoord = coordinate;
	caseImage = image;
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
	
	AppMKAnnotation *casePlace = [[AppMKAnnotation alloc] initWithCoordinate:selectedCoord andTitle:@" " andSubtitle:@""];
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
