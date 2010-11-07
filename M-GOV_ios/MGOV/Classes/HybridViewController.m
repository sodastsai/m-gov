/*
 * 
 * HybridViewController.m
 * 2010/9/9
 * sodas
 * 
 * A hybrid view controller which combines MapView and TableView with Navigation Controller
 * Use this view controller to show location-related data in list way and map way
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

#import "HybridViewController.h"

@implementation HybridViewController

@synthesize listViewController, mapViewController;
@synthesize selectorDelegate, dataSource;
@synthesize rightButtonItem;
@synthesize caseID;
@synthesize mapView;

#pragma mark -
#pragma mark Method

- (void)refreshViews {
	// Map View
	if (mapViewController != nil) {
		NSArray *annotationArray = [self annotationArrayForMapView];
		[self dropAnnotation:annotationArray];
		[self.mapView setCenterCoordinate:self.mapView.region.center animated:YES];
	}
	// Table View
	if (listViewController != nil) [listViewController.tableView reloadData];
}

#pragma mark -
#pragma mark Two views

- (UIViewController *)initialMapViewController {
	if (mapViewController == nil) {
		// New a mapView
		mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 342)];
		mapView.delegate = self;
		// Set map view center to current location
		MGOVGeocoder *shared = [MGOVGeocoder sharedVariable];	
		[mapView setCenterCoordinate:shared.locationManager.location.coordinate animated:YES];
		MKCoordinateRegion region;
		region.center = shared.locationManager.location.coordinate;
		MKCoordinateSpan span;
		span.latitudeDelta = 0.004;
		span.longitudeDelta = 0.004;
		region.span = span;
		[mapView setRegion:region];
		// Set map to show user current location
		mapView.showsUserLocation = YES;
		mapView.userLocation.title = @"Current Location!";
		mapView.userLocation.subtitle = @"";
		// View Controller
		mapViewController = [[UIViewController alloc] init];
		mapViewController.view = mapView;
		[mapView release];
		mapViewController.view.autoresizesSubviews = YES;
		mapViewController.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
		
		// Set Bar
		UIBarButtonItem *changeMode = [[UIBarButtonItem alloc] initWithTitle:@"列表模式" style:UIBarButtonItemStyleBordered target:self action:@selector(changeToAnotherMode)];
		mapViewController.navigationItem.leftBarButtonItem = changeMode;
		[changeMode release];
		mapViewController.navigationItem.title = self.title;
		mapViewController.navigationItem.rightBarButtonItem = self.rightButtonItem;
		mapViewController.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	}
	[self refreshViews];
	return mapViewController;
}

- (UITableViewController *)initialListViewController {
	if (listViewController == nil) {
		// View Controller
		listViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
		listViewController.tableView.delegate = self;
		listViewController.tableView.dataSource = self;
		// Set Bar
		UIBarButtonItem *changeMode = [[UIBarButtonItem alloc] initWithTitle:@"地圖模式" style:UIBarButtonItemStyleBordered target:self action:@selector(changeToAnotherMode)];
		listViewController.navigationItem.leftBarButtonItem = changeMode;
		[changeMode release];
		listViewController.navigationItem.title = self.title;
		listViewController.navigationItem.rightBarButtonItem = self.rightButtonItem;
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
	
	if (menuMode == HybridViewMapMode) {
		// Change to List mode.
		listViewController = [self initialListViewController];
		
		[listViewController viewWillAppear:YES];
        [mapViewController viewWillDisappear:YES];
        [self setRootViewController:listViewController];
		[mapViewController viewDidDisappear:YES];
        [listViewController viewDidAppear:YES];
		menuMode = HybridViewListMode;
	} else {
		// Change to Map mode.
		mapViewController = [self initialMapViewController];
        
		[mapViewController viewWillAppear:YES];
        [listViewController viewWillDisappear:YES];
        [self setRootViewController:mapViewController];
		[listViewController viewDidDisappear:YES];
        [mapViewController viewDidAppear:YES];
		menuMode = HybridViewMapMode;
	}
}

#pragma mark -
#pragma mark Lifecycle

- (id)initWithMode:(HybridViewMenuMode)mode andTitle:(NSString *)aTitle {
	return [self initWithMode:mode andTitle:aTitle withRightBarButtonItem:nil];
}

- (id)initWithMode:(HybridViewMenuMode)mode andTitle:(NSString *)aTitle withRightBarButtonItem:(UIBarButtonItem *)rightButton {
	emptyRootViewController = [[UIViewController alloc] init];
	emptyRootViewController.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
	
	if (self = [super initWithRootViewController:emptyRootViewController]) {
		
		self.title = aTitle;
		self.navigationItem.title = aTitle;
		self.rightButtonItem = rightButton;
		menuMode = mode;
		
		if (menuMode == HybridViewMapMode) {
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
    NSArray *viewControllers = super.viewControllers;
	if (viewControllers != nil && viewControllers.count > 0) {
		NSMutableArray *array = [NSMutableArray arrayWithArray:viewControllers];
		[array removeObjectAtIndex:0];
		return array;
	}
	return viewControllers;
}

//override so it pops to the perceived root
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    // we use index 0 because we overrided “viewControllers”
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
	// Let the system use the "blue dot" for the user location
	if ([annotation isKindOfClass:[MKUserLocation class]]) return nil; 
	
	// Act like table view cells
	static NSString * const pinAnnotationIdentifier = @"PinIdentifier";
	MKPinAnnotationView *dataAnnotationView = (MKPinAnnotationView *)[MapView dequeueReusableAnnotationViewWithIdentifier:pinAnnotationIdentifier];
	
	if (dataAnnotationView) {
		// Already exists
		dataAnnotationView.annotation = annotation;
	} else {		
		// Renew
		dataAnnotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinAnnotationIdentifier] autorelease];
		dataAnnotationView.draggable = NO;
		dataAnnotationView.canShowCallout = YES;
		dataAnnotationView.animatesDrop = YES;
		UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		dataAnnotationView.rightCalloutAccessoryView = detailButton;
		[detailButton addTarget:self action:@selector(pushToChildViewControllerInMap) forControlEvents:UIControlEventTouchUpInside];
	}
	return dataAnnotationView;
}

- (void)mapView:(MKMapView *)MapView didSelectAnnotationView:(MKAnnotationView *)annotationView {
	[selectorDelegate didSelectAnnotationViewInMap:annotationView];
}

- (void) pushToChildViewControllerInMap {
	[self pushViewController:selectorDelegate.childViewController animated:YES];
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
	[listViewController release];
	mapView.delegate=nil;
	[mapViewController release];
	[(id)dataSource release];
	[(id)selectorDelegate release];
	[rightButtonItem release];
	[emptyRootViewController release];
}

@end
