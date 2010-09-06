//
//  QueryViewController.m
//  MGOV
//
//  Created by iphone on 2010/9/2.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "QueryViewController.h"


@implementation QueryViewController

@synthesize qid, selectedTypeTitle;

#pragma mark -
#pragma mark QueryView method

- (IBAction)openSearchDialogAction {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"設定搜尋條件" delegate:self cancelButtonTitle:@"重設所有搜尋條件" destructiveButtonTitle:nil otherButtonTitles:@"設定種類", @"回到現在位置", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
	// Cannot use [actionSheet showInView:self.view]! This will be affected by the UITabBar 
	[actionSheet showInView:self.tabBarController.view];
	[actionSheet release];
}

- (void)backToCurrentLocation {
	MGOVGeocoder *shared = [MGOVGeocoder sharedVariable];	
	[caseDisplayView.mapView setCenterCoordinate:shared.locationManager.location.coordinate animated:YES];
	MKCoordinateRegion region;
	region.center = shared.locationManager.location.coordinate;
	MKCoordinateSpan span;
	span.latitudeDelta = 0.004;
	span.longitudeDelta = 0.004;
	region.span = span;
	[caseDisplayView.mapView setRegion:region];
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
	
	caseDisplayView = [[CaseDisplayView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	[self.view addSubview:caseDisplayView];
	[caseDisplayView release];
	[self backToCurrentLocation];
		
	UIBarButtonItem *modeChangeButton = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStyleBordered target:self action:@selector(modeChange)];
	self.navigationItem.leftBarButtonItem = modeChangeButton;
	[modeChangeButton release];
	
	
	caseTypeSelector = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(typeSelect)];
	//self.navigationItem.rightBarButtonItem = caseTypeSelector;
	
	
	UIButton *searchCriteria = [UIButton buttonWithType:UIButtonTypeInfoDark];
	searchCriteria.frame = CGRectMake(290, 340, 20, 20);
	[caseDisplayView.mapView addSubview:searchCriteria];
	[searchCriteria addTarget:self action:@selector(openSearchDialogAction) forControlEvents:UIControlEventTouchUpInside];
	
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
