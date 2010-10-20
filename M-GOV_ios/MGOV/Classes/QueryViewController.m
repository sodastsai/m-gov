//
//  QueryViewController.m
//  MGOV
//
//  Created by sodas on 2010/9/9.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "QueryViewController.h"

@implementation QueryViewController

@synthesize typeID;
@synthesize queryTotalLength;

#pragma mark -
#pragma mark Override

- (void)queryGAEwithConditonType:(DataSourceGAEQueryTypes)conditionType andCondition:(id)condition {
	nextButton.enabled = NO;
	lastButton.enabled = NO;
	[super queryGAEwithConditonType:conditionType andCondition:condition];
}

- (id)initWithMode:(HybridViewMenuMode)mode andTitle:(NSString *)title {
	caseSource = nil;
	
	UIBarButtonItem *setConditionButton = [[UIBarButtonItem alloc] initWithTitle:@"設定條件" style:UIBarButtonItemStyleBordered target:self action:@selector(setQueryCondition)];
	self = [self initWithMode:mode andTitle:title withRightBarButtonItem:setConditionButton];
	[setConditionButton release];
	
	return self;
}

- (void)refreshDataSource {
	if (queryTotalLength!=-1) [super refreshDataSource];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
	[childViewController cleanTableView];
	return [super popViewControllerAnimated:animated];
}

#pragma mark -
#pragma mark Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	nextButton = [[UIButton alloc] initWithFrame:CGRectMake(274, 7, 30, 30)];
	[nextButton setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
	[nextButton addTarget:self action:@selector(nextCase) forControlEvents:UIControlEventTouchUpInside];
	[informationBar addSubview:nextButton];
	[nextButton release];
	
	lastButton = [[UIButton alloc] initWithFrame:CGRectMake(17, 7, 30, 30)];
	[lastButton setImage:[UIImage imageNamed:@"previous.png"] forState:UIControlStateNormal];
	[lastButton addTarget:self action:@selector(lastCase) forControlEvents:UIControlEventTouchUpInside];
	[informationBar addSubview:lastButton];
	[lastButton release];
	
	queryTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(51, 2, 218, 21)];
	queryTypeLabel.backgroundColor = [UIColor clearColor];
	queryTypeLabel.textColor = [UIColor whiteColor];
	queryTypeLabel.textAlignment = UITextAlignmentCenter;
	queryTypeLabel.font = [UIFont boldSystemFontOfSize:14];
	queryTypeLabel.text = @"所有案件種類";
	[informationBar addSubview:queryTypeLabel];
	[queryTypeLabel release];
	
	numberDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(51, 20, 218, 21)];
	numberDisplayLabel.backgroundColor = [UIColor clearColor];
	numberDisplayLabel.textColor = [UIColor whiteColor];
	numberDisplayLabel.textAlignment = UITextAlignmentCenter;
	numberDisplayLabel.font = [UIFont systemFontOfSize:14];
	[informationBar addSubview:numberDisplayLabel];
	[numberDisplayLabel release];
	
	typeID = 0;
	queryTotalLength = -1;
}

- (void)viewDidAppear:(BOOL)animated {
	if (queryTotalLength == -1) {
		MGOVGeocoder *shared = [MGOVGeocoder sharedVariable];
		[mapView setCenterCoordinate:shared.locationManager.location.coordinate];
	}
	queryTotalLength = 0;
}

#pragma mark -
#pragma mark Method

- (void)queryAfterSetRangeAndType {
	if (!typeID) {
		// Query without type
		[self queryGAEwithConditonType:DataSourceGAEQueryByCoordinate andCondition:[QueryGoogleAppEngine generateMapQueryConditionFromRegion:self.mapView.region]];
	} else {
		// Query with type
		NSArray *keyArray = [[NSArray alloc] initWithObjects:@"DataSourceGAEQueryByCoordinate", @"DataSourceGAEQueryByType", nil];
		NSArray *valueArray = [[NSArray alloc] initWithObjects:[QueryGoogleAppEngine generateMapQueryConditionFromRegion:self.mapView.region], [NSString stringWithFormat:@"%d", typeID], nil];
		NSDictionary *contentDictionary = [[NSDictionary alloc] initWithObjects:valueArray forKeys:keyArray];
		[self queryGAEwithConditonType:DataSourceGAEQueryByMultiConditons andCondition:contentDictionary];
		[contentDictionary release];
		[keyArray release];
		[valueArray release];
	}
}

- (void)setQueryCondition {
	UIActionSheet *setCondition = [[UIActionSheet alloc] initWithTitle:@"設定搜尋條件" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"所有案件種類", @"依案件種類搜尋", nil];
	[setCondition showFromTabBar:self.tabBarController.tabBar];
	[setCondition release];
}

- (void)nextCase {
	if (queryTotalLength > queryRange.location+queryRange.length) {
		// Move Sector
		queryRange.location += kDataSectorSize;
		// Start Query
		[self queryAfterSetRangeAndType];
	}
}

- (void)lastCase {
	if (queryRange.location >= kDataSectorSize) {
		// Move Sector
		queryRange.location -= kDataSectorSize;
		// Start Query
		[self queryAfterSetRangeAndType];
	}
}

#pragma mark -
#pragma mark QueryGAEReciever

- (void)recieveQueryResultType:(DataSourceGAEReturnTypes)type withResult:(id)result {
	// Check type
	if ([[result objectForKey:@"length"] intValue]==0)
		self.caseSource = nil;
	if (type == DataSourceGAEReturnByNSDictionary) {
		self.caseSource = [result objectForKey:@"result"];
		self.queryTotalLength = [[result objectForKey:@"length"] intValue];
	}
	// Refresh
	if (![caseSource count]) {
		numberDisplayLabel.text = @"找不到此區域符合條件的案件";
		numberDisplayLabel.font = [UIFont boldSystemFontOfSize:14];
		lastButton.enabled = NO;
		nextButton.enabled = NO;
	} else {
		int rangeStart = queryRange.location +1;
		int rangeEnd = queryRange.location+[caseSource count];
		// Update Label
		numberDisplayLabel.text = [NSString stringWithFormat:@"%d-%d 筆，共 %d 筆", rangeStart, rangeEnd, queryTotalLength];
		numberDisplayLabel.font = [UIFont systemFontOfSize:14];
		// Lock or Unlock Button
		if (rangeStart!=1) lastButton.enabled = YES;
		else lastButton.enabled = NO;
		if (rangeEnd!=queryTotalLength) nextButton.enabled = YES;
		else nextButton.enabled = NO;
	}
	self.topViewController.navigationItem.leftBarButtonItem.enabled = YES;
	self.topViewController.navigationItem.rightBarButtonItem.enabled = YES;
	[self refreshViews];
	[super recieveQueryResultType:type withResult:result];
}


#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)MapView regionWillChangeAnimated:(BOOL)animated {
	// Lock Buttons
	nextButton.enabled = NO;
	lastButton.enabled = NO;
	self.topViewController.navigationItem.leftBarButtonItem.enabled =  NO;
	self.topViewController.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)mapView:(MKMapView *)MapView regionDidChangeAnimated:(BOOL)animated {
	if (queryTotalLength != -1) {
		// Initial
		queryRange = NSRangeFromString([NSString stringWithFormat:@"0,%d", kDataSectorSize]);
		// Start Query
		[self queryAfterSetRangeAndType];
	}
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex==1) {
		// Select Type
		TypesViewController *typeSelector = [[TypesViewController alloc] init];
		typeSelector.delegate = self;
		
		UINavigationController *typeAndDetailSelector = [[UINavigationController alloc] initWithRootViewController:typeSelector];
		[self presentModalViewController:typeAndDetailSelector animated:YES];
		
		[typeSelector release];
		[typeAndDetailSelector release];
	} else if (buttonIndex==0) {
		// All type
		queryTypeLabel.text = @"所有案件種類";
		typeID = 0;
		[self queryGAEwithConditonType:DataSourceGAEQueryByCoordinate andCondition:[QueryGoogleAppEngine generateMapQueryConditionFromRegion:self.mapView.region]];
	} else if (buttonIndex==2) {
		// Do nothing but cancel
	}
}

#pragma mark -
#pragma mark TypeSelectorDelegate

- (void)typeSelectorDidSelectWithTitle:(NSString *)t andQid:(NSInteger)q {
	// Update Selector
	typeID = q;
	queryTypeLabel.text = t;
	[self dismissModalViewControllerAnimated:YES];
	
	// Start Query
	[self queryAfterSetRangeAndType];
}

- (void)leaveSelectorWithoutTitleAndQid {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
    [super dealloc];
}

@end