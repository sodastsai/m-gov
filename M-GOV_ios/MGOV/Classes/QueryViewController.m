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

- (IBAction)openPhotoDialogAction {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"回到當下位置" destructiveButtonTitle:nil otherButtonTitles:@"地圖模式", @"清單模式", nil];
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
	if (caseDisplayView.listView.hidden) {
		caseDisplayView.listView.hidden = NO;
		caseDisplayView.mapView.hidden = YES;
		self.navigationItem.leftBarButtonItem.title = @"地圖";
	}
	else {
		caseDisplayView.mapView.hidden = NO;
		caseDisplayView.listView.hidden = YES;
		self.navigationItem.leftBarButtonItem.title = @"清單";
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
		
	} else if (buttonIndex == 1) {
		
	} else {
		[self backToCurrentLocation];
	}
	
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
		
	UIBarButtonItem *modeChangeButton = [[UIBarButtonItem alloc] initWithTitle:@"清單" style:UIBarButtonItemStyleBordered target:self action:@selector(modeChange)];
	self.navigationItem.leftBarButtonItem = modeChangeButton;
	[modeChangeButton release];
	
	UIBarButtonItem *caseTypeSelector = [[UIBarButtonItem alloc] initWithTitle:@"種類" style:UIBarButtonItemStyleBordered target:self action:@selector(typeSelect)];
	self.navigationItem.rightBarButtonItem = caseTypeSelector;
	[caseTypeSelector release];
	
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
}


@end
