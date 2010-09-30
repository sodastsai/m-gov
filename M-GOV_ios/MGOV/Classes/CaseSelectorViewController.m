    //
//  CaseSelectorViewController.m
//  MGOV
//
//  Created by sodas on 2010/9/9.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "CaseSelectorViewController.h"


@implementation CaseSelectorViewController

@synthesize listViewController, mapViewController;
@synthesize selectorDelegate, dataSource;
@synthesize rightButtonItem;
@synthesize caseID;
@synthesize mapView;

#pragma mark -
#pragma mark Method

- (void)refreshViews {
	// Map View
	NSArray *annotationArray = [self annotationArrayForMapView];
	[self dropAnnotation:annotationArray];
	[self.mapView setCenterCoordinate:self.mapView.region.center animated:YES];
	// Table View
	[listViewController.tableView reloadData];
}

#pragma mark -
#pragma mark Two views

- (UIViewController *)initialMapViewController {
	if (mapViewController == nil) {
		
		mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 342)];
		mapView.delegate = self;
		MGOVGeocoder *shared = [MGOVGeocoder sharedVariable];	
		[mapView setCenterCoordinate:shared.locationManager.location.coordinate animated:YES];
		MKCoordinateRegion region;
		region.center = shared.locationManager.location.coordinate;
		MKCoordinateSpan span;
		span.latitudeDelta = 0.004;
		span.longitudeDelta = 0.004;
		region.span = span;
		[mapView setRegion:region];
		
		mapViewController = [[UIViewController alloc] init];
		mapViewController.view = mapView;
		mapViewController.view.autoresizesSubviews = YES;
		mapViewController.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
		
		// Set Bar
		UIBarButtonItem *changeMode = [[UIBarButtonItem alloc] initWithTitle:@"列表模式" style:UIBarButtonItemStyleBordered target:self action:@selector(changeToAnotherMode)];
		mapViewController.navigationItem.leftBarButtonItem = changeMode;
		[changeMode release];
		mapViewController.navigationItem.title = self.title;
		mapViewController.navigationItem.rightBarButtonItem = rightButtonItem;
		mapViewController.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	}
	[self refreshViews];
	return mapViewController;
}

- (UITableViewController *)initialListViewController {
	if (listViewController == nil) {
		listViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
		listViewController.tableView.delegate = self;
		listViewController.tableView.dataSource = self;
		// Set Bar
		UIBarButtonItem *changeMode = [[UIBarButtonItem alloc] initWithTitle:@"地圖模式" style:UIBarButtonItemStyleBordered target:self action:@selector(changeToAnotherMode)];
		listViewController.navigationItem.leftBarButtonItem = changeMode;
		[changeMode release];
		listViewController.navigationItem.title = self.title;
		listViewController.navigationItem.rightBarButtonItem = rightButtonItem;
		listViewController.navigationController.navigationBar.barStyle = UIBarStyleDefault;
		
		listViewController.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
		listViewController.view.autoresizesSubviews = YES;
	}
	[self refreshViews];
	return listViewController;
}

- (void)changeToAnotherMode {
	// First create a CATransition object to describe the transition
	CATransition *transition = [CATransition animation];
	// Animate over 0.5 of a second
	transition.duration = 0.5;
	// using the ease in/out timing function
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	
	// Next add it to the containerView's layer. This will perform the transition based on how we change its contents.
	[self.view.layer addAnimation:transition forKey:nil];
	
	if (menuMode == CaseSelectorMapMode) {
		// Change to List mode.
		listViewController = [self initialListViewController];
		
		[listViewController viewWillAppear:YES];
        [mapViewController viewWillDisappear:YES];
        [self setRootViewController:listViewController];
        [mapViewController viewDidDisappear:YES];
        [listViewController viewDidAppear:YES];
		menuMode = CaseSelectorListMode;
	} else {
		// Change to Map mode.
		mapViewController = [self initialMapViewController];
        
		[mapViewController viewWillAppear:YES];
        [listViewController viewWillDisappear:YES];
        [self setRootViewController:mapViewController];
        [listViewController viewDidDisappear:YES];
        [mapViewController viewDidAppear:YES];
		menuMode = CaseSelectorMapMode;
	}
}

#pragma mark -
#pragma mark Lifecycle

- (id)initWithMode:(CaseSelectorMenuMode)mode andTitle:(NSString *)title {
	return [self initWithMode:mode andTitle:title withRightBarButtonItem:nil];
}

- (id)initWithMode:(CaseSelectorMenuMode)mode andTitle:(NSString *)title withRightBarButtonItem:(UIBarButtonItem *)rightButton {
	emptyRootViewController = [[UIViewController alloc] init];
	emptyRootViewController.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
	
	if (self = [super initWithRootViewController:emptyRootViewController]) {
		self.title = title;
		self.rightButtonItem = rightButton;
		menuMode = mode;
		
		if (menuMode == CaseSelectorMapMode) {
			mapViewController = [self initialMapViewController];
			mapViewController.navigationItem.hidesBackButton = YES;
			[self pushViewController:mapViewController animated:NO];
		} else {
			listViewController = [self initialListViewController];
			listViewController.navigationItem.hidesBackButton = YES;
			[self pushViewController:listViewController animated:NO];
		}
	}
	return self;
}

//override to remove empty root controller
- (NSArray *)viewControllers {
    NSArray *viewControllers = [super viewControllers];
	if (viewControllers != nil && viewControllers.count > 0) {
		NSMutableArray *array = [NSMutableArray arrayWithArray:viewControllers];
		[array removeObjectAtIndex:0];
		return array;
	}
	return viewControllers;
}

//override so it pops to the perceived root
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    //we use index 0 because we overrided “viewControllers”
    return [self popToViewController:[self.viewControllers objectAtIndex:0] animated:animated];
}

//this is the new method that lets you set the perceived root, the previous one will be popped (released)
- (void)setRootViewController:(UIViewController *)rootViewController {
    rootViewController.navigationItem.hidesBackButton = YES;
    [self popToViewController:emptyRootViewController animated:NO];
    [self pushViewController:rootViewController animated:NO];
}

#pragma mark -
#pragma mark MapView data source

- (void)dropAnnotation:(NSArray *)data{
	[mapView removeAnnotations:mapView.annotations];
	[mapView addAnnotations:data];
}

- (NSArray *)annotationArrayForMapView {
	return [dataSource setupAnnotationArrayForMapView];
}

#pragma mark -
#pragma mark MapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)MapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	// Act like table view cells
	static NSString * const pinAnnotationIdentifier = @"PinIdentifier";
	MKPinAnnotationView *caseAnnotationView = (MKPinAnnotationView *)[MapView dequeueReusableAnnotationViewWithIdentifier:pinAnnotationIdentifier];
	
	if (caseAnnotationView) {
		// Already exists
		caseAnnotationView.annotation = annotation;
	} else {		
		// Renew
		caseAnnotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinAnnotationIdentifier] autorelease];
		caseAnnotationView.draggable = NO;
		caseAnnotationView.canShowCallout = YES;
		caseAnnotationView.animatesDrop = YES;
		UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		caseAnnotationView.rightCalloutAccessoryView = detailButton;
		[detailButton addTarget:self action:@selector(pushToCaseViewer) forControlEvents:UIControlEventTouchUpInside];
	}
	return caseAnnotationView;
}

- (void)mapView:(MKMapView *)MapView didSelectAnnotationView:(MKAnnotationView *)annotationView {
	caseID = [(AppMKAnnotation *)annotationView.annotation annotationID];
}

- (void) pushToCaseViewer {
	CaseViewerViewController *caseViewer = [[CaseViewerViewController alloc] initWithCaseID:caseID];
	[self.topViewController.navigationController pushViewController:caseViewer animated:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [dataSource titleForHeaderInSectionInList:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [dataSource numberOfSectionsInList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [dataSource numberOfRowsInListSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [dataSource heightForRowAtIndexPathInList:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[selectorDelegate didSelectRowAtIndexPathInList:indexPath];
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [super dealloc];
}

@end
