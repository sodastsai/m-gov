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

@implementation LocationSelectorViewController


@synthesize topBar, searchBar, mapView;
@synthesize searchBarCell, titleCell;
@synthesize selectedAddress;

#pragma mark -
#pragma mark Location Selector method

- (void) selectDone {
	
	[self dismissModalViewControllerAnimated:YES];
	
}

- (void) selectCancel {
	
	[self dismissModalViewControllerAnimated:YES];
	
}

- (void) updatingAddress:(CLLocationCoordinate2D)coordinate {
	// Use Google API to transform Latitude & Longitude to the corresponding address  
	NSURL *url = [[NSURL alloc] initWithString:@"http://maps.google.com/maps/api/geocode/json?latlng=25.047924,121.517081&sensor=true&language=zh-TW"];
	NSString *str = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	//NSLog(@"%@", str);	
	NSDictionary *dict = [str JSONValue];
	NSLog(@"%@", [[[dict objectForKey:@"results"] objectAtIndex:0] objectForKey:@"formatted_address"]);
	NSLog(@"%@", [[[[[dict objectForKey:@"results"] objectAtIndex:0] objectForKey:@"address_components"] objectAtIndex:1] objectForKey:@"long_name"]);
	selectedAddress.text = [NSString stringWithFormat:@"%@", [[[dict objectForKey:@"results"] objectAtIndex:0] objectForKey:@"formatted_address"]];
	
	[url release];
	[str release];	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
	return 45;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.row == 1) {
		return searchBarCell;
	}
	if (indexPath.row == 0) {
		return titleCell;
	}
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	return cell;
}


#pragma mark -
#pragma mark View lifecycle

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
	
	topBar.backgroundColor = [UIColor blackColor];
	topBar.scrollEnabled = NO;
	topBar.separatorStyle = UITableViewCellSeparatorStyleNone;
	searchBarCell.clipsToBounds = YES;
	selectedAddress.textAlignment = UITextAlignmentCenter;
	
	[self updatingAddress:shared.locationManager.location.coordinate];
	
	UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 420, 159.5, 45)];
	UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 420, 160, 45)];
	doneButton.backgroundColor = [UIColor blackColor];
	cancelButton.backgroundColor = [UIColor blackColor];
	doneButton.alpha = 0.8;
	cancelButton.alpha = 0.8;
	doneButton.showsTouchWhenHighlighted = YES;
	cancelButton.showsTouchWhenHighlighted = YES;
	doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
	cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
	[doneButton setTitle:@"確定" forState:UIControlStateNormal];
	[cancelButton setTitle:@"取消" forState:UIControlStateNormal];
	[doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneButton addTarget:self action:@selector(selectCancel) forControlEvents:UIControlEventTouchUpInside];
	[cancelButton addTarget:self action:@selector(selectDone) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:doneButton];
	[self.view addSubview:cancelButton];
	[doneButton release];
	[cancelButton release];
	
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
	[topBar release];
	[searchBar release];
	[searchBarCell release];
    [super dealloc];
}


@end
