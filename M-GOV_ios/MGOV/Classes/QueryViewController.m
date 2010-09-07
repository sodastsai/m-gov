//
//  QueryViewController.m
//  MGOV
//
//  Created by Shou on 2010/9/2.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "QueryViewController.h"


@implementation QueryViewController

@synthesize qid, selectedTypeTitle;

#pragma mark -
#pragma mark CaseDisplayView Delegate

- (void) pushToCaseViewerAtCaseID:(int)caseID {
	
	CaseViewerViewController *caseViewer = [[CaseViewerViewController alloc] initWithCaseID:[[caseData objectAtIndex:caseID]objectForKey:@"key"]];
	[self.navigationController pushViewController:caseViewer animated:YES];
	[caseViewer release];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (![caseData count]) return 1;
    return [caseData count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";

    CaseDisplayTableCell *cell = (CaseDisplayTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CaseDisplayTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    // Configure the cell...
    if ([caseData count] != 0) {
		NSString *caseType = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"QidToType" ofType:@"plist"]] valueForKey:[[caseData objectAtIndex:indexPath.row] objectForKey:@"typeid"]];
		cell.typeLabel.text = caseType;
		
		CLLocationCoordinate2D coordinate;
		coordinate.longitude = [[[[caseData objectAtIndex:indexPath.row] objectForKey:@"coordinates"] objectAtIndex:0] doubleValue];
		coordinate.latitude = [[[[caseData objectAtIndex:indexPath.row] objectForKey:@"coordinates"] objectAtIndex:1] doubleValue];
		cell.addressLabel.text = [NSString stringWithFormat:@"%@", [MGOVGeocoder returnFullAddress:coordinate]];
	}
	
    return cell;
}


#pragma mark -
#pragma mark QueryView method

- (void)openSearchDialogAction {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"設定搜尋條件" delegate:self cancelButtonTitle:@"重設所有搜尋條件" destructiveButtonTitle:nil otherButtonTitles:@"設定種類", @"回到現在位置", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
	// Cannot use [actionSheet showInView:self.view]! This will be affected by the UITabBar 
	[actionSheet showInView:self.tabBarController.view];
	[actionSheet release];
}

- (void)backToCurrentLocation {
	MGOVGeocoder *shared = [MGOVGeocoder sharedVariable];
	[caseDisplayView.mapView setCenterCoordinate:shared.locationManager.location.coordinate];
}

- (void)modeChange {
	if (!caseDisplayView.transitioning) {
		[caseDisplayView performTransition];
		if (caseDisplayView.listView.hidden) {
			self.navigationItem.leftBarButtonItem.title = @"列表";
			self.navigationItem.rightBarButtonItem = nil;
		}
		else {
			self.navigationItem.leftBarButtonItem.title = @"地圖";
			self.navigationItem.rightBarButtonItem = caseTypeSelector;
		}
	}
}

- (void)typeSelect {
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


#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == 0) {
		[self typeSelect];
	} else if (buttonIndex == 1) {
		[self backToCurrentLocation];
	} 
	
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
	
	[self backToCurrentLocation];
}

#pragma mark -
#pragma mark typesViewControllerDelegate

- (void)typeSelectorDidSelectWithTitle:(NSString *)t andQid:(NSInteger)q {
	self.selectedTypeTitle = t;
	self.qid = q;
	// Dismiss the view
	[self dismissModalViewControllerAnimated:YES];
	// Reload tableview after selected
}

- (void)leaveSelectorWithoutTitleAndQid {
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	caseDisplayView = [[CaseDisplayView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) andDefaultView:@"mapView"];
	caseDisplayView.delegate = self;
	caseDisplayView.listView.dataSource = self;
	//caseDisplayView.listView.delegate = caseDisplayView;
	[self.view addSubview:caseDisplayView];
	[caseDisplayView release];
	
	UIBarButtonItem *modeChangeButton = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStyleBordered target:self action:@selector(modeChange)];
	self.navigationItem.leftBarButtonItem = modeChangeButton;
	[modeChangeButton release];
	
	caseTypeSelector = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(openSearchDialogAction)];	
	
	UIButton *searchCriteria = [UIButton buttonWithType:UIButtonTypeInfoDark];
	searchCriteria.frame = CGRectMake(290, 340, 20, 20);
	[caseDisplayView.mapView addSubview:searchCriteria];
	[searchCriteria addTarget:self action:@selector(openSearchDialogAction) forControlEvents:UIControlEventTouchUpInside];

	NSString *str = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://ntu-ecoliving.appspot.com/ecoliving/query_region/%E6%9D%BE%E5%B1%B1%E5%8D%80/10"] encoding:NSUTF8StringEncoding error:nil];
	caseData = [[NSArray alloc] initWithArray:[str JSONValue]];	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
	
	[caseDisplayView.listView reloadData];
}

#pragma mark -
#pragma mark Memory management

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
    [super dealloc];
	[caseTypeSelector release];
	[selectedTypeTitle release];
	[caseDisplayView release];
}


@end
