//
//  QueryViewController.m
//  MGOV
//
//  Created by Shou on 2010/8/25.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "QueryViewController.h"


@implementation QueryViewController

@synthesize selectedTypeTitle;
@synthesize qid;

#pragma mark -
#pragma mark QueryViewController Method

- (BOOL)submitQuery {
	NSLog(@"submitQuery");
	return YES;
	
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
		return @"依照案件地點查詢";
	} else if(section == 1) {
		return @"依照案件種類查詢";
	}
	
	return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.section==0) {
		return locationCell;
	}
	// Type Selector is a normal table view cell
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	if (indexPath.section == 1) {
		if ([selectedTypeTitle length]) cell.textLabel.text = selectedTypeTitle;
		else cell.textLabel.text = @"請按此選擇案件種類";
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
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
#pragma mark LocationSelectorTableCellDelegate

- (void)openLocationSelector {
	locationSelector = [[LocationSelectorViewController alloc] initWithCoordinate:selectedCoord];
	locationSelector.delegate = self;
	[self presentModalViewController:locationSelector animated:YES];
}

#pragma mark -
#pragma mark LocationSelectorViewControllerDelegate

- (void)userDidSelectCancel {
	// Dismiss the view
	[self dismissModalViewControllerAnimated:YES];
}

- (void)userDidSelectDone:(CLLocationCoordinate2D)coordinate {
	// Dismiss the view
	[locationCell updatingCoordinate:coordinate];
	selectedCoord = coordinate;
	[self.tableView reloadData];
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"送出" style:UIBarButtonItemStylePlain target:self action:@selector(submitQuery)];
	self.navigationItem.rightBarButtonItem = submitButton;
	[submitButton release];
	
	locationCell = [[LocationSelectorTableCell alloc] initWithHeight:200];
	locationCell.delegate = self;
	
	selectedTypeTitle = [[NSString alloc] init];
	
	MGOVGeocoder *shared = [MGOVGeocoder sharedVariable];
	selectedCoord = shared.locationManager.location.coordinate;
	shared = nil;
	[shared release];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}

- (void)dealloc {
	[locationSelector release];
	[locationCell release];
    [super dealloc];
}

@end
