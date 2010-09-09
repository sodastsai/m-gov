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

#pragma mark -
#pragma mark Two views

- (UIViewController *)initialMapViewController {
	if (mapViewController == nil) {
		
		MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 342)];
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
		[mapView release];
		
		// Set Bar
		UIBarButtonItem *changeMode = [[UIBarButtonItem alloc] initWithTitle:@"列表模式" style:UIBarButtonItemStyleBordered target:self action:@selector(changeToAnotherMode)];
		mapViewController.navigationItem.leftBarButtonItem = changeMode;
		[changeMode release];
		mapViewController.navigationItem.title = self.title;
		mapViewController.navigationItem.rightBarButtonItem = rightButtonItem;
	}
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
	}
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
		rightButtonItem = rightButton;
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
