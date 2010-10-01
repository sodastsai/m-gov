//
//  CaseSelectorViewController.m
//  MGOV
//
//  Created by sodas on 2010/10/1.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "CaseSelectorViewController.h"

/*
 *
 *  Use this Class to merge the common section between MyCase and Query views.
 *  HybridViewController sets most part of common UI section, but contains no Data Source section.
 *  The common Data Source section is set here.
 *
 */

@implementation CaseSelectorViewController

@synthesize childViewController, caseSource;

#pragma mark -
#pragma mark Override

- (void)pushToChildViewControllerInMap {
	informationBar.hidden = YES;
	[super pushToChildViewControllerInMap];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
	informationBar.hidden = NO;
	return [super popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Data Source Method

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
#pragma mark HybridViewDelegate

- (void)didSelectRowAtIndexPathInList:(NSIndexPath *)indexPath {
	if (indexPath.section != 0) {
		informationBar.hidden = YES;
		caseID = [[caseSource objectAtIndex:indexPath.row] valueForKey:@"key"];
		childViewController = [[CaseViewerViewController alloc] initWithCaseID:caseID];
		[self pushViewController:childViewController animated:YES];
		[childViewController release];
	}
}

- (void)didSelectAnnotationViewInMap:(MKAnnotationView *)annotationView {
	caseID = [(AppMKAnnotation *)annotationView.annotation annotationID];
	self.childViewController = [[[CaseViewerViewController alloc] initWithCaseID:caseID] autorelease];
}

#pragma mark -
#pragma mark HybridViewDataSource

- (NSInteger)numberOfSectionsInList {
	return 2;
}

- (NSInteger)numberOfRowsInListSection:(NSInteger)section {
	if (section == 0) return 1;
	return [caseSource count];
}

- (CGFloat)heightForRowAtIndexPathInList:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) return 44;
	return [CaseSelectorCell cellHeight];
}

- (NSString *)titleForHeaderInSectionInList:(NSInteger)section {
	return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"caseCell";
	static NSString *CellIdentifier2 = @"informationBarCell";
	// First Cell which is covered by InformationBar
	if (indexPath.section == 0) {
		// Waste some memory since this cell could not be shared to other Case.
		CaseSelectorCell *cell = (CaseSelectorCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
		if (cell == nil) 
			cell = [[[CaseSelectorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		return cell;
	}
	
	// Normal Section Cell
	CaseSelectorCell *cell = (CaseSelectorCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [[[CaseSelectorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	
	// Case ID
	cell.caseID.text = [[caseSource objectAtIndex:indexPath.row] objectForKey:@"key"];
	// Case Type
	NSString *caseTypeText = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"QidToType" ofType:@"plist"]] valueForKey:[[caseSource objectAtIndex:indexPath.row] valueForKey:@"typeid"]];
	cell.caseType.text = caseTypeText;
	// Case Date
	if ([[caseSource objectAtIndex:indexPath.row] objectForKey:@"date"]!=nil) {
		// Original ROC Format
		NSString *originalDate = [[[[[caseSource objectAtIndex:indexPath.row] objectForKey:@"date"] stringByReplacingOccurrencesOfString:@"年" withString:@"/"]
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
	caseCoord.longitude  = [[[[caseSource objectAtIndex:indexPath.row] objectForKey:@"coordinates"] objectAtIndex:0] doubleValue];
	caseCoord.latitude = [[[[caseSource objectAtIndex:indexPath.row] objectForKey:@"coordinates"] objectAtIndex:1] doubleValue];
	// TODO: query with cache
	//cell.caseAddress.text = [[MGOVGeocoder returnFullAddress:caseCoord] substringFromIndex:5];
	cell.caseAddress.text = @"台北市大安區羅斯福路四段一號";
	// Case Status
	if ([[[caseSource objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"完工"]||
		[[[caseSource objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"結案"]||
		[[[caseSource objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"轉府外單位"])
		cell.caseStatus.image = [UIImage imageNamed:@"ok.png"];
	else if ([[[caseSource objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"無法辦理"]||
			 [[[caseSource objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"退回區公所"])
		cell.caseStatus.image = [UIImage imageNamed:@"fail.png"];
	else cell.caseStatus.image = [UIImage imageNamed:@"unknown.png"];
	
	return cell;
}

- (NSArray *) setupAnnotationArrayForMapView {
	CLLocationCoordinate2D coordinate;
	NSMutableArray *annotationArray = [[[NSMutableArray alloc] init] autorelease];
	for (int i = 0; i < [caseSource count]; i++) {
		coordinate.longitude = [[[[caseSource objectAtIndex:i] objectForKey:@"coordinates"] objectAtIndex:0] doubleValue];
		coordinate.latitude = [[[[caseSource objectAtIndex:i] objectForKey:@"coordinates"] objectAtIndex:1] doubleValue];
		NSString *typeStr = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"QidToType" ofType:@"plist"]] valueForKey:[[caseSource objectAtIndex:i] valueForKey:@"typeid"]];
		AppMKAnnotation *casePlace = [[AppMKAnnotation alloc] initWithCoordinate:coordinate andTitle:typeStr andSubtitle:@"" andCaseID:[[caseSource objectAtIndex:i] objectForKey:@"key"]];
		[annotationArray addObject:casePlace];
		[casePlace release];
	}
	return annotationArray;
}

#pragma mark -
#pragma mark Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	// Show Information Bar
	informationBar = [[[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 44)] autorelease];
	informationBar.backgroundColor = [UIColor colorWithHue:0.5944 saturation:0.35 brightness:0.7 alpha:0.7];
	[self.view addSubview:informationBar];
}

@end