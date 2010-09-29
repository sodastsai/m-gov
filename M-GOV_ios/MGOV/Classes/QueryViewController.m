//
//  QueryViewController.m
//  MGOV
//
//  Created by sodas on 2010/9/9.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "QueryViewController.h"

@implementation QueryViewController

@synthesize queryCaseSource;
@synthesize typeID;
@synthesize queryTotalLength;

#pragma mark -
#pragma mark Lifecycle

// Override the super class
- (id)initWithMode:(CaseSelectorMenuMode)mode andTitle:(NSString *)title {
	UIBarButtonItem *setConditionButton = [[[UIBarButtonItem alloc] initWithTitle:@"設定條件" style:UIBarButtonItemStyleBordered target:self action:@selector(setQueryCondition)] autorelease];
	queryCaseSource = nil;
	return [self initWithMode:mode andTitle:title withRightBarButtonItem:setConditionButton];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	queryConditionBar = [[[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 44)] autorelease];
	queryConditionBar.backgroundColor = [UIColor colorWithHue:0.5944 saturation:0.35 brightness:0.7 alpha:0.7];
	UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	nextButton.frame = CGRectMake(274, 6, 29, 31);
	UIButton *lastButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	lastButton.frame = CGRectMake(17, 6, 29, 31);
	[nextButton addTarget:self action:@selector(nextCase) forControlEvents:UIControlEventTouchUpInside];
	[lastButton addTarget:self action:@selector(lastCase) forControlEvents:UIControlEventTouchUpInside];
	[queryConditionBar addSubview:nextButton];
	[queryConditionBar addSubview:lastButton];
	
	queryTypeLabel  = [[[UILabel alloc] initWithFrame:CGRectMake(51, 3, 218, 21)] autorelease];
	numberDisplayLabel  = [[[UILabel alloc] initWithFrame:CGRectMake(51, 20, 218, 21)] autorelease];
	queryTypeLabel.backgroundColor = [UIColor clearColor];
	numberDisplayLabel.backgroundColor = [UIColor clearColor];
	queryTypeLabel.textColor = [UIColor whiteColor];
	numberDisplayLabel.textColor = [UIColor whiteColor];
	queryTypeLabel.textAlignment = UITextAlignmentCenter;
	numberDisplayLabel.textAlignment = UITextAlignmentCenter;
	queryTypeLabel.font = [UIFont systemFontOfSize:14];
	numberDisplayLabel.font = [UIFont systemFontOfSize:14];
	queryTypeLabel.text = @"所有案件種類";
	[queryConditionBar addSubview:queryTypeLabel];
	[queryConditionBar addSubview:numberDisplayLabel];
	
	[self.view addSubview:queryConditionBar];
	
	typeID = 0;
	queryTotalLength = -1;
}

- (void)viewDidAppear:(BOOL)animated {
	queryTotalLength = 0;
}

#pragma mark -
#pragma mark Method

- (void)setQueryCondition {
	UIActionSheet *setCondition = [[UIActionSheet alloc] initWithTitle:@"設定搜尋條件" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"重設搜尋條件" otherButtonTitles:@"依案件種類搜尋", nil];
	[setCondition showFromTabBar:self.tabBarController.tabBar];
	[setCondition release];
}

- (void)nextCase {
	if (queryTotalLength > queryRange.location+queryRange.length) {
		// Move Sector
		queryRange.location += kDataSectorSize;
		// Start Query
		if (!typeID) {
			// Query without type
			[self queryGAEwithConditonType:DataSourceGAEQueryByCoordinate andCondition:[QueryGoogleAppEngine generateMapQueryConditionFromRegion:self.mapView.region]];
		} else {
			// Query with type
			NSArray *keyArray = [NSArray arrayWithObjects:@"DataSourceGAEQueryByCoordinate", @"DataSourceGAEQueryByType", nil];
			NSArray *valueArray = [NSArray arrayWithObjects:[QueryGoogleAppEngine generateMapQueryConditionFromRegion:self.mapView.region], [NSString stringWithFormat:@"%d", typeID], nil];
			[self queryGAEwithConditonType:DataSourceGAEQueryByMultiConditons andCondition:[NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray]];
		}
	}
}

- (void)lastCase {
	if (queryRange.location >= kDataSectorSize) {
		// Move Sector
		queryRange.location -= kDataSectorSize;
		// Start Query
		if (!typeID) {
			// Query without type
			[self queryGAEwithConditonType:DataSourceGAEQueryByCoordinate andCondition:[QueryGoogleAppEngine generateMapQueryConditionFromRegion:self.mapView.region]];
		} else {
			// Query with type
			NSArray *keyArray = [NSArray arrayWithObjects:@"DataSourceGAEQueryByCoordinate", @"DataSourceGAEQueryByType", nil];
			NSArray *valueArray = [NSArray arrayWithObjects:[QueryGoogleAppEngine generateMapQueryConditionFromRegion:self.mapView.region], [NSString stringWithFormat:@"%d", typeID], nil];
			[self queryGAEwithConditonType:DataSourceGAEQueryByMultiConditons andCondition:[NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray]];
		}
	}
}

- (void)queryGAEwithConditonType:(DataSourceGAEQueryTypes)conditionType andCondition:(id)condition {
	QueryGoogleAppEngine *qGAE = [QueryGoogleAppEngine requestQuery];
	qGAE.resultTarget = self;
	qGAE.indicatorTargetView = self.view;
	qGAE.resultRange = queryRange;
	if (conditionType == DataSourceGAEQueryByMultiConditons) {
		qGAE.conditionType = conditionType;
		qGAE.queryMultiConditions = condition;
	} else {
		qGAE.conditionType = conditionType;
		qGAE.queryCondition = condition;
	}
	self.topViewController.navigationItem.leftBarButtonItem.enabled =  NO;
	self.topViewController.navigationItem.rightBarButtonItem.enabled = NO;
	[qGAE startQuery];
}


#pragma mark -
#pragma mark QueryGAEReciever

- (void)recieveQueryResultType:(DataSourceGAEReturnTypes)type withResult:(id)result {
	// Check type
	if ([result count]==0) self.queryCaseSource = nil;
	if (type == DataSourceGAEReturnByNSDictionary) {
		self.queryCaseSource = [result objectForKey:@"result"];
		self.queryTotalLength = [[result objectForKey:@"length"] intValue];
	}
	// Refresh
	[self refreshViews];
	if (![queryCaseSource count]) numberDisplayLabel.text = [NSString stringWithFormat:@"%d-%d 筆，共 %d 筆", 0, 0, 0];
	else numberDisplayLabel.text = [NSString stringWithFormat:@"%d-%d 筆，共 %d 筆", queryRange.location+1, queryRange.location+[queryCaseSource count], queryTotalLength];
	self.topViewController.navigationItem.leftBarButtonItem.enabled = YES;
	self.topViewController.navigationItem.rightBarButtonItem.enabled = YES;
}


#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
	self.topViewController.navigationItem.leftBarButtonItem.enabled =  NO;
	self.topViewController.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)mapView:(MKMapView *)MapView regionDidChangeAnimated:(BOOL)animated {
	if (queryTotalLength != -1) {
		// Initial
		queryRange = NSRangeFromString([NSString stringWithFormat:@"0,%d", kDataSectorSize]);
		// Start Query
		if (!typeID) {
			// Query without type
			[self queryGAEwithConditonType:DataSourceGAEQueryByCoordinate andCondition:[QueryGoogleAppEngine generateMapQueryConditionFromRegion:self.mapView.region]];
		} else {
			// Query with type
			NSArray *keyArray = [NSArray arrayWithObjects:@"DataSourceGAEQueryByCoordinate", @"DataSourceGAEQueryByType", nil];
			NSArray *valueArray = [NSArray arrayWithObjects:[QueryGoogleAppEngine generateMapQueryConditionFromRegion:self.mapView.region], [NSString stringWithFormat:@"%d", typeID], nil];
			[self queryGAEwithConditonType:DataSourceGAEQueryByMultiConditons andCondition:[NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray]];
		}
	}
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex==1) {
		// Select Type
		typesViewController *typeSelector = [[typesViewController alloc] init];
		typeSelector.delegate = self;
		UINavigationController *typeAndDetailSelector = [[UINavigationController alloc] initWithRootViewController:typeSelector];
		[self presentModalViewController:typeAndDetailSelector animated:YES];
		[typeSelector release];
		[typeAndDetailSelector release];
	} else if (buttonIndex==0) {
		// Reset
		MGOVGeocoder *shared = [MGOVGeocoder sharedVariable];
		queryTypeLabel.text = @"所有案件種類";
		typeID = 0;
		[mapView setCenterCoordinate:shared.locationManager.location.coordinate animated:YES];
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
	if (!typeID) {
		// Query without type
		[self queryGAEwithConditonType:DataSourceGAEQueryByCoordinate andCondition:[QueryGoogleAppEngine generateMapQueryConditionFromRegion:self.mapView.region]];
	} else {
		// Query with type
		NSArray *keyArray = [NSArray arrayWithObjects:@"DataSourceGAEQueryByCoordinate", @"DataSourceGAEQueryByType", nil];
		NSArray *valueArray = [NSArray arrayWithObjects:[QueryGoogleAppEngine generateMapQueryConditionFromRegion:self.mapView.region], [NSString stringWithFormat:@"%d", typeID], nil];
		[self queryGAEwithConditonType:DataSourceGAEQueryByMultiConditons andCondition:[NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray]];
	}
}

- (void)leaveSelectorWithoutTitleAndQid {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark CaseSelectorDelegate

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
	[[self.view.subviews lastObject] setHidden:NO];
	return [super popViewControllerAnimated:YES];
}

- (void)didSelectRowAtIndexPathInList:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) {
		[[self.view.subviews lastObject] setHidden:YES];
		CaseViewerViewController *caseViewer = [[CaseViewerViewController alloc] initWithCaseID:[[queryCaseSource objectAtIndex:indexPath.row] valueForKey:@"key"]];
		//[self.topViewController.navigationController pushViewController:caseViewer animated:YES];
		[self pushViewController:caseViewer animated:YES];
	}
}

#pragma mark -
#pragma mark  CaseSelectorDataSource

- (NSArray *) setupAnnotationArrayForMapView {
	CLLocationCoordinate2D coordinate;
	NSMutableArray *annotationArray = [[[NSMutableArray alloc] init] autorelease];
	for (int i = 0; i < [queryCaseSource count]; i++) {
		coordinate.longitude = [[[[queryCaseSource objectAtIndex:i] objectForKey:@"coordinates"] objectAtIndex:0] doubleValue];
		coordinate.latitude = [[[[queryCaseSource objectAtIndex:i] objectForKey:@"coordinates"] objectAtIndex:1] doubleValue];
		NSString *typeStr = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"QidToType" ofType:@"plist"]] valueForKey:[[queryCaseSource objectAtIndex:i] valueForKey:@"typeid"]];
		AppMKAnnotation *casePlace = [[AppMKAnnotation alloc] initWithCoordinate:coordinate andTitle:typeStr andSubtitle:@"" andCaseID:[[queryCaseSource objectAtIndex:i] objectForKey:@"key"]];
		[annotationArray addObject:casePlace];
		[casePlace release];
	}
	return annotationArray;
}

- (NSInteger)numberOfSectionsInList {
	return 2;
}

- (NSInteger)numberOfRowsInListSection:(NSInteger)section {
	if (section == 0) return 1;
	return [queryCaseSource count];
}

- (CGFloat)heightForRowAtIndexPathInList:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) return 44;
	return [CaseSelectorCell cellHeight];
}

- (NSString *)titleForHeaderInSectionInList:(NSInteger)section {
	if (section == 1) return @"XD";
	return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	if (indexPath.section == 0) {
		CaseSelectorCell *cell = [[[CaseSelectorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		return cell;
	}
	
	CaseSelectorCell *cell = (CaseSelectorCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[CaseSelectorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	// Case ID
	cell.caseID.text = [[queryCaseSource objectAtIndex:indexPath.row] objectForKey:@"key"];
	// Case Type
	NSString *caseTypeText = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"QidToType" ofType:@"plist"]] valueForKey:[[queryCaseSource objectAtIndex:indexPath.row] valueForKey:@"typeid"]];
	cell.caseType.text = caseTypeText;
	// Case Date
	if ([[queryCaseSource objectAtIndex:indexPath.row] objectForKey:@"date"]!=nil) {
		// Original ROC Format
		NSString *originalDate = [[[[[queryCaseSource objectAtIndex:indexPath.row] objectForKey:@"date"] stringByReplacingOccurrencesOfString:@"年" withString:@"/"]
								   stringByReplacingOccurrencesOfString:@"月" withString:@"/"] 
								  stringByReplacingOccurrencesOfString:@"日" withString:@""];
		NSString *originalLongDate = [originalDate stringByAppendingString:@" 23:59:59"];
		// Convert to Common Era
		NSDate *formattedDate = [NSDate dateFromROCFormatString:originalLongDate];
		
		// Make today's end
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *todayDate = [[dateFormatter stringFromDate:[NSDate date]] stringByAppendingString:@" 23:59:59"];
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		NSDate *todayEnd = [dateFormatter dateFromString:todayDate];
		[dateFormatter release];
		
		// Check Interval
		if ([todayEnd timeIntervalSinceDate:formattedDate] < 86400) {
			cell.caseDate.text = @"今天";
		} else if ([todayEnd timeIntervalSinceDate:formattedDate]  < 86400*2) {
			cell.caseDate.text = @"昨天";
		} else if ([todayEnd timeIntervalSinceDate:formattedDate]  < 86400*3) {
			cell.caseDate.text = @"兩天前";
		} else {
			cell.caseDate.text = originalDate;
		}
	} else {
		// No Date
		cell.caseDate.text = @"";
	}
	// Case Address
	CLLocationCoordinate2D caseCoord;
	caseCoord.longitude  = [[[[queryCaseSource objectAtIndex:indexPath.row] objectForKey:@"coordinates"] objectAtIndex:0] doubleValue];
	caseCoord.latitude = [[[[queryCaseSource objectAtIndex:indexPath.row] objectForKey:@"coordinates"] objectAtIndex:1] doubleValue];
	// TODO: query with cache
	//cell.caseAddress.text = [[MGOVGeocoder returnFullAddress:caseCoord] substringFromIndex:5];
	// Case Status
	cell.caseStatus.image = [UIImage imageNamed:@"ok.png"];
	
	return cell;
}


- (void)dealloc {
    [super dealloc];
}

@end