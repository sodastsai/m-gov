/*
 * 
 * LocationSelectorViewController.h
 * 2010/8/30
 * Shou
 * 
 * Address Selector with MapView
 *
 * Copyright 2010 NTU CSIE Mobile & HCI Lab
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#import "LocationSelectorViewController.h"
#import "MGOVGeocoder.h"

@implementation LocationSelectorViewController

@synthesize delegate;
@synthesize mapView;
@synthesize bottomBar, selectedCoord, caseImage;
@synthesize annotationAddress;

#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)MapView didAddAnnotationViews:(NSArray *)views {
	[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showAnnotationCallout) userInfo:nil repeats:NO];
}

- (void)showAnnotationCallout {
	[mapView selectAnnotation:[mapView.annotations lastObject] animated:YES];
}

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
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[caseImage fitToSize:CGSizeMake(40, 29)]];
		draggablePinView.leftCalloutAccessoryView = imageView;
		[imageView release];
	}
	return draggablePinView;
}

- (void)mapView:(MKMapView *)MapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
	if ( newState == MKAnnotationViewDragStateNone ) {
		NSString *tempAddress = [MGOVGeocoder returnFullAddress:annotationView.annotation.coordinate];
		if ([tempAddress rangeOfString:@"台北市"].location == NSNotFound || tempAddress == nil) {
			annotationView.annotation.coordinate = selectedCoord;
			UIAlertView *outofTaipeiCity = [[UIAlertView alloc] initWithTitle:@"超出服務範圍" message:@"1999的服務範圍僅限於台北市內！" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
			[outofTaipeiCity show];
			[outofTaipeiCity release];		
		} else {
			// Update annotation subtitle
			[self updatingAddress:annotationView.annotation];
		}
		tempAddress = nil;
	}
}


#pragma mark -
#pragma mark Location Selector method

- (void) updatingAddress:(AppMKAnnotation *)annotation {
	annotationAddress = [MGOVGeocoder returnFullAddress:annotation.coordinate];
	// Network
	if (annotationAddress!=nil) {
		selectedCoord = annotation.coordinate;
		annotation.annotationSubtitle = [annotationAddress substringFromIndex:5];
	}
}

- (void) transformCoordinate {
	[delegate userDidSelectDone:selectedCoord];
}

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate {
	return [self initWithCoordinate:coordinate andImage:nil];
}

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andImage:(UIImage *)image {
	if (self = [self init]) {
		selectedCoord = coordinate;
		self.caseImage = image;
	}
	return self;
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
	
	AppMKAnnotation *casePlace = [[AppMKAnnotation alloc] initWithCoordinate:selectedCoord andTitle:@"案件地點" andSubtitle:@""];
	[mapView addAnnotation:casePlace];
	[self updatingAddress:casePlace];
	if ([annotationAddress rangeOfString:@"台北市"].location == NSNotFound || annotationAddress == nil) {
		selectedCoord.latitude = 25.046337;
		selectedCoord.longitude = 121.51745;
		[mapView setCenterCoordinate:selectedCoord animated:YES];
		MKCoordinateRegion region;
		region.center = selectedCoord;
		MKCoordinateSpan span;
		span.latitudeDelta = 0.004;
		span.longitudeDelta = 0.004;
		region.span = span;
		[mapView setRegion:region];
		CLLocationCoordinate2D coord;
		coord.latitude = 25.046337;
		coord.longitude = 121.51745;
		casePlace.coordinate = coord;
		UIAlertView *outofTaipeiCity = [[UIAlertView alloc] initWithTitle:@"超出服務範圍" message:@"本服務目前僅受理台北市內的案件！" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
		[outofTaipeiCity show];
		[outofTaipeiCity release];
	}
	[casePlace release];
		
	// OK, Cancel
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"確定" style:UIBarButtonItemStyleBordered target:self action:@selector(transformCoordinate)];
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:delegate action:@selector(userDidSelectCancel)];
	doneButton.width = 149;
	cancelButton.width = 149;
	[bottomBar setItems:[NSArray arrayWithObjects:cancelButton, doneButton, nil] animated:YES];
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
	[bottomBar release];
    [super dealloc];
}

@end
