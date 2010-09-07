//
//  CaseDisplayView.m
//  MGOV
//
//  Created by Shou on 2010/9/3.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "CaseDisplayView.h"


@implementation CaseDisplayView

@synthesize mapView, listView;
@synthesize transitioning;
@synthesize delegate;

#pragma mark -
#pragma mark ViewTransition

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
	transitioning = NO;
}

-(void)performTransition {
	// First create a CATransition object to describe the transition
	CATransition *transition = [CATransition animation];
	// Animate over 0.5 of a second
	transition.duration = 0.5;
	// using the ease in/out timing function
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	transition.type = kCATransitionFade;
	
	// Finally, to avoid overlapping transitions we assign ourselves as the delegate for the animation and wait for the
	// -animationDidStop:finished: message. When it comes in, we will flag that we are no longer transitioning.
	transitioning = YES;
	transition.delegate = self;
	
	// Next add it to the containerView's layer. This will perform the transition based on how we change its contents.
	[self.layer addAnimation:transition forKey:nil];
	
	// Here we hide view1, and show view2, which will cause Core Animation to animate view1 away and view2 in.
	if (mapView.hidden) {
		mapView.hidden = NO;
		listView.hidden = YES;
	}
	else {
		mapView.hidden = YES;
		listView.hidden = NO;
	}	
}

-(void)loadCaseData:(NSDictionary *)dict {
	caseData = [NSDictionary dictionaryWithDictionary:dict];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//CaseViewerViewController *detailViewController = [[CaseViewerViewController alloc] initWithNibName:@"CaseViewer" bundle:nil];
	//[detailViewController initWithCaseID:@"09909-500718"];
	//CaseViewerViewController *detailViewController = [[CaseViewerViewController alloc] initWithCaseID:@"09909-500718"];
	// Pass the selected object to the new view controller.
	[delegate pushToCaseViewerAtCaseID:indexPath.row];
	//[detailViewController release];
}

- (id)initWithFrame:(CGRect)frame andDefaultView:(NSString *)defaultView {
	if ([self initWithFrame:frame]) {
		if ([defaultView isEqualToString:@"mapView"])listView.hidden = YES;
		if ([defaultView isEqualToString:@"listView"]) mapView.hidden = YES;
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	// TODO: should be set to default
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		caseData = [[NSMutableArray alloc] init];
		mapView = [[MKMapView alloc] initWithFrame:frame];
		listView = [[UITableView alloc] initWithFrame:frame];
		listView.delegate = self;
		[self addSubview:listView];
		[self addSubview:mapView];
		transitioning = NO;
		MGOVGeocoder *shared = [MGOVGeocoder sharedVariable];	
		[mapView setCenterCoordinate:shared.locationManager.location.coordinate animated:YES];
		MKCoordinateRegion region;
		region.center = shared.locationManager.location.coordinate;
		MKCoordinateSpan span;
		span.latitudeDelta = 0.004;
		span.longitudeDelta = 0.004;
		region.span = span;
		[mapView setRegion:region];
    }
    return self;
}

- (void)dealloc {
	[mapView release];
	[listView release];
	[caseData release];
    [super dealloc];
}


@end
