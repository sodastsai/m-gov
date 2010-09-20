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
	
	UIView *queryConditionBar = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 44)];
	queryConditionBar.backgroundColor = [UIColor colorWithHue:0.5944 saturation:0.35 brightness:0.7 alpha:0.7];
	UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	nextButton.frame = CGRectMake(17, 6, 29, 31);
	UIButton *lastButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	lastButton.frame = CGRectMake(274, 6, 29, 31);
	[queryConditionBar addSubview:nextButton];
	[queryConditionBar addSubview:lastButton];
	queryTypeLabel  = [[UILabel alloc] initWithFrame:CGRectMake(51, 3, 218, 21)];
	numberDisplayLabel  = [[UILabel alloc] initWithFrame:CGRectMake(51, 20, 218, 21)];
	queryTypeLabel.backgroundColor = [UIColor clearColor];
	numberDisplayLabel.backgroundColor = [UIColor clearColor];
	queryTypeLabel.textColor = [UIColor whiteColor];
	numberDisplayLabel.textColor = [UIColor whiteColor];
	queryTypeLabel.textAlignment = UITextAlignmentCenter;
	numberDisplayLabel.textAlignment = UITextAlignmentCenter;
	queryTypeLabel.font = [UIFont systemFontOfSize:14];
	numberDisplayLabel.font = [UIFont systemFontOfSize:14];
	queryTypeLabel.text = @"所有案件種類";
	numberDisplayLabel.text = @"1-10 筆，共 100 筆";
	[queryConditionBar addSubview:queryTypeLabel];
	[queryConditionBar addSubview:numberDisplayLabel];
	
	[self.view addSubview:queryConditionBar];
	
	[queryConditionBar release];
	//[nextButton release];
	//[lastButton release];
	
	typeID = 0;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	//[[self.view.subviews lastObject] setHidden:NO];
}

#pragma mark -
#pragma mark Method

- (void)sendQueryWithConditionType:(DataSourceGAEQueryTypes)conditionType Condition:(NSString *)condition Range:(NSRange)range {
	QueryGoogleAppEngine *qGAE = [[QueryGoogleAppEngine alloc] init];
	qGAE.conditionType = conditionType;
	qGAE.resultTarget = self;
	qGAE.queryCondition = condition;
	qGAE.resultRange = range;
	[qGAE startQuery];
	[qGAE release];
	if ([queryCaseSource count] < 10) {
		queryRange = NSRangeFromString([NSString stringWithFormat:@"0,%d", [queryCaseSource count]]);
	} else queryRange = NSRangeFromString(@"0,10");
	NSArray *annotationArray = [self annotationArrayForMapView];
	[self dropAnnotation:annotationArray withRange:queryRange];
	[self.mapView setCenterCoordinate:self.mapView.region.center animated:YES];
	[listViewController.tableView reloadData];
}

- (void)setQueryCondition {
	UIActionSheet *setCondition = [[UIActionSheet alloc] initWithTitle:@"設定搜尋條件" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"設定案件種類", @"回到現在位置", nil];
	[setCondition showFromTabBar:self.tabBarController.tabBar];
	[setCondition release];
}

- (void)startQueryToGAE:(QueryGoogleAppEngine *)qGAE {
	[qGAE startQuery];
}

#pragma mark -
#pragma mark QueryGAEReciever

- (void)recieveQueryResultType:(DataSourceGAEReturnTypes)type withResult:(id)result {
	// Accept Array only
	if (type == DataSourceGAEReturnByNSDictionary) {
		self.queryCaseSource = [result objectForKey:@"result"];
	}
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)MapView regionDidChangeAnimated:(BOOL)animated {
	if (!typeID) {
		[self sendQueryWithConditionType:DataSourceGAEQueryByCoordinate Condition:[NSString stringWithFormat:@"%f&%f&%f&%f", self.mapView.centerCoordinate.longitude, self.mapView.centerCoordinate.latitude, self.mapView.region.span.longitudeDelta/2, self.mapView.region.span.latitudeDelta/2] Range:NSRangeFromString(@"0,10000")];
	} else {
		[self sendQueryWithConditionType:DataSourceGAEQueryByCoordinateAndType Condition:[NSString stringWithFormat:@"%f&%f&%f&%f&%d", self.mapView.centerCoordinate.longitude, self.mapView.centerCoordinate.latitude, self.mapView.region.span.longitudeDelta/2, self.mapView.region.span.latitudeDelta/2, typeID] Range:NSRangeFromString(@"0,10000")];	
	}
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex==0) {
		typesViewController *typeSelector = [[typesViewController alloc] init];
		typeSelector.delegate = self;
		UINavigationController *typeAndDetailSelector = [[UINavigationController alloc] initWithRootViewController:typeSelector];
		[self presentModalViewController:typeAndDetailSelector animated:YES];
		[typeSelector release];
		[typeAndDetailSelector release];
	} else if (buttonIndex==1) {
		NSLog(@"Back");
		MGOVGeocoder *shared = [MGOVGeocoder sharedVariable];
		[mapView setCenterCoordinate:shared.locationManager.location.coordinate animated:YES];
	} else if (buttonIndex==2) {
		// Do nothing but cancel
	}
}

#pragma mark -
#pragma mark TypeSelectorDelegate

- (void)typeSelectorDidSelectWithTitle:(NSString *)t andQid:(NSInteger)q {
	typeID = q;
	[self sendQueryWithConditionType:DataSourceGAEQueryByCoordinateAndType Condition:[NSString stringWithFormat:@"%f&%f&%f&%f&%d", self.mapView.centerCoordinate.longitude, self.mapView.centerCoordinate.latitude, self.mapView.region.span.longitudeDelta/2, self.mapView.region.span.latitudeDelta/2, typeID] Range:NSRangeFromString(@"0,10000")];
	queryTypeLabel.text = t;
	[self dismissModalViewControllerAnimated:YES];
}

- (void)leaveSelectorWithoutTitleAndQid {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark CaseSelectorDelegate

- (void)didSelectRowAtIndexPathInList:(NSIndexPath *)indexPath {
	CaseViewerViewController *caseViewer = [[CaseViewerViewController alloc] initWithCaseID:[[queryCaseSource objectAtIndex:indexPath.row] valueForKey:@"key"]];
	//[self.topViewController.navigationController pushViewController:caseViewer animated:YES];
	[self pushViewController:caseViewer animated:YES];
}

#pragma mark -
#pragma mark  CaseSelectorDataSource

- (NSArray *) setupAnnotationArrayForMapView {
	CLLocationCoordinate2D coordinate;
	NSMutableArray *annotationArray = [[[NSMutableArray alloc] init] autorelease];
	for (int i = 0; i < [queryCaseSource count]; i++) {
		coordinate.longitude = [[[[queryCaseSource objectAtIndex:i] objectForKey:@"coordinates"] objectAtIndex:0] doubleValue];
		coordinate.latitude = [[[[queryCaseSource objectAtIndex:i] objectForKey:@"coordinates"] objectAtIndex:1] doubleValue];
		AppMKAnnotation *casePlace = [[AppMKAnnotation alloc] initWithCoordinate:coordinate andTitle:[[queryCaseSource objectAtIndex:i] objectForKey:@"key"] andSubtitle:@"" andCaseID:[[queryCaseSource objectAtIndex:i] objectForKey:@"key"]];
		[annotationArray addObject:casePlace];
		[casePlace release];
	}
	return annotationArray;
}

- (NSInteger)numberOfSectionsInList {
	return 1;
}

- (NSInteger)numberOfRowsInListSection:(NSInteger)section {
	return [queryCaseSource count];
}

- (CGFloat)heightForRowAtIndexPathInList:(NSIndexPath *)indexPath {
	return [CaseSelectorCell cellHeight];
}

- (NSString *)titleForHeaderInSectionInList:(NSInteger)section {
	return @"XD";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
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
	//cell.caseAddress.text = [[MGOVGeocoder returnFullAddress:caseCoord] substringFromIndex:5];
	
	return cell;
}

@end