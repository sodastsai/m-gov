//
//  QueryViewController.m
//  MGOV
//
//  Created by Shou on 2010/8/25.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "QueryViewController.h"
#import "typesViewController.h"

@implementation QueryViewController

@synthesize selectedTypeTitle;
@synthesize qid;

#pragma mark -
#pragma mark QueryViewController Method

- (BOOL)submitQuery {
	NSLog(@"submitQuery");
	return YES;
	
}
- (void)locationSelector {
	
	LocationSelectorViewController *locationSelector = [[LocationSelectorViewController alloc] init];
	
	[self presentModalViewController:locationSelector animated:YES];
	
	[locationSelector release];
	
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"送出" style:UIBarButtonItemStylePlain target:self action:@selector(submitQuery)];
	self.navigationItem.rightBarButtonItem = submitButton;
	[submitButton release];
	
	selectedTypeTitle = [[NSString alloc] init];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
	// Set the height according to the edit area size
    if (indexPath.section == 0) {
		return 200;
	} else if (indexPath.section == 1 ){
		return 45;
	}
	return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return @"依照地址查詢";
	} else if(section == 1) {
		return @"依照案件種類查詢";
	}
	
	return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		if (indexPath.section == 0) {
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			#pragma mark Address MapView
			MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
			mapView.mapType = MKMapTypeStandard;
			GlobalVariable *shared = [GlobalVariable sharedVariable];
			[mapView setCenterCoordinate:shared.locationManager.location.coordinate animated:YES];
			MKCoordinateRegion region;
			region.center = shared.locationManager.location.coordinate;
			MKCoordinateSpan span;
			span.latitudeDelta = 0.004;
			span.longitudeDelta = 0.004;
			region.span = span;
			mapView.layer.cornerRadius = 10.0;
			mapView.layer.masksToBounds = YES;
			[mapView setRegion:region];
			
			UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
			mapButton.backgroundColor = [UIColor clearColor];
			[cell.contentView addSubview:mapButton];
			[mapButton addTarget:self action:@selector(locationSelector) forControlEvents:UIControlEventTouchUpInside];

			
			// TODO: correct the title: 現在位置or照片位置
			// TODO: correct the subtitle: 地址
			AppMKAnnotation *casePlace = [[AppMKAnnotation alloc] initWithCoordinate:region.center andTitle:@"Title test" andSubtitle:@"科科"];
			[mapView addAnnotation:casePlace];
			[casePlace release];
			
			cell.backgroundView = mapView;
			[mapView release];
		} else if (indexPath.section == 1) {
			// Define selector textlabel
			cell.textLabel.text = @"請按此選擇案件種類";
			// other style
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		}
    }
	
	if (indexPath.section == 1) {
		// Decide placeholder or selected result to show
		if ([selectedTypeTitle length])
			cell.textLabel.text = selectedTypeTitle;
		else
			cell.textLabel.text = @"請按此選擇案件種類";
	}	
	
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section==1 && indexPath.row==0) {
		typesViewController *typesView = [[typesViewController alloc] init];
		typesView.title = @"請選擇案件種類";
		UINavigationController *typeAndDetailSelector = [[UINavigationController alloc] initWithRootViewController:typesView];
		// Show the view
		typesView.delegate = self;
		[self presentModalViewController:typeAndDetailSelector animated:YES];
		// Add Back button
		UIBarButtonItem *backBuuton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:typesView.delegate action:@selector(leaveSelectorWithoutTitleAndQid)];
		typesView.navigationItem.leftBarButtonItem = backBuuton;
		[backBuuton release];
		[typesView release];
	}
}

#pragma mark -
#pragma mark TypeSelectorDelegateProtocol

- (void)typeSelectorDidSelectWithTitle:(NSString *)t andQid:(NSInteger)q {
	self.selectedTypeTitle = t;
	self.qid = q;
	// Dismiss the view
	[self dismissModalViewControllerAnimated:YES];
	// Reload tableview after selected
	[self.tableView reloadData];
}

- (void)leaveSelectorWithoutTitleAndQid {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}

- (void)dealloc {
    [super dealloc];
}

@end
