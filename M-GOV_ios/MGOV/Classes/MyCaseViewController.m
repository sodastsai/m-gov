    //
//  MyCaseViewController.m
//  MGOV
//
//  Created by sodas on 2010/9/9.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "MyCaseViewController.h"

@implementation MyCaseViewController

@synthesize myCaseSource, dictUserInformation;

#pragma mark -
#pragma mark Lifecycle

// Override the super class
- (id)initWithMode:(CaseSelectorMenuMode)mode andTitle:(NSString *)title {
	UIBarButtonItem *addCaseButton = [[[UIBarButtonItem alloc] initWithTitle:@"新增案件" style:UIBarButtonItemStyleBordered target:self action:@selector(addCase)] autorelease];
	return [self initWithMode:mode andTitle:title withRightBarButtonItem:addCaseButton];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Fetch User Information
	NSString *plistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"UserInformation.plist"];
	self.dictUserInformation = [[NSDictionary dictionaryWithContentsOfFile:plistPathInAppDocuments] retain];
	if ([[dictUserInformation valueForKey:@"User Email"] length]) [self queryGAEwithConditonType:DataSourceGAEQueryByEmail andCondition:[dictUserInformation objectForKey:@"User Email"]];
}

#pragma mark -
#pragma mark Method

- (void)addCase {
	// Call the add case view
	CaseAddViewController *caseAdder = [[CaseAddViewController alloc] initWithStyle:UITableViewStyleGrouped];
	caseAdder.delegate = self;
	
	[self.topViewController.navigationController pushViewController:caseAdder animated:YES];
	[caseAdder release];
}

- (void)queryGAEwithConditonType:(DataSourceGAEQueryTypes)conditionType andCondition:(id)condition {
	QueryGoogleAppEngine *qGAE = [QueryGoogleAppEngine requestQuery];
	qGAE.resultTarget = self;
	qGAE.indicatorTargetView = self.view;
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
	// Accept Array only
	if (type == DataSourceGAEReturnByNSDictionary) {
		self.myCaseSource = [result objectForKey:@"result"];
	} else {
		myCaseSource = nil;
	}
	[listViewController.tableView reloadData];
}

#pragma mark -
#pragma mark CaseSelectorDelegate

- (void)didSelectRowAtIndexPathInList:(NSIndexPath *)indexPath {
	if ([[dictUserInformation valueForKey:@"User Email"] length]!=0) {
		CaseViewerViewController *caseViewer = [[CaseViewerViewController alloc] initWithCaseID:[[myCaseSource objectAtIndex:indexPath.row] valueForKey:@"key"]];
		[self.topViewController.navigationController pushViewController:caseViewer animated:YES];
	}
} 

#pragma mark -
#pragma mark CaseAddViewControllerDelegate

- (void)refreshData {
	// If the original email is empty, after user submit case, reload the plist
	if (![[dictUserInformation valueForKey:@"User Email"] length]) {
		NSString *plistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"UserInformation.plist"];
		self.dictUserInformation = [NSDictionary dictionaryWithContentsOfFile:plistPathInAppDocuments];
	}
	[self queryGAEwithConditonType:DataSourceGAEQueryByEmail andCondition:[dictUserInformation objectForKey:@"User Email"]];
}

#pragma mark -
#pragma mark  CaseSelectorDataSource

- (NSArray *) setupAnnotationArrayForMapView {
	CLLocationCoordinate2D coordinate;
	NSMutableArray *annotationArray = [[[NSMutableArray alloc] init] autorelease];
	for (int i = 0; i < [myCaseSource count]; i++) {
		coordinate.longitude = [[[[myCaseSource objectAtIndex:i] objectForKey:@"coordinates"] objectAtIndex:0] doubleValue];
		coordinate.latitude = [[[[myCaseSource objectAtIndex:i] objectForKey:@"coordinates"] objectAtIndex:1] doubleValue];
		AppMKAnnotation *casePlace=[[AppMKAnnotation alloc] initWithCoordinate:coordinate andTitle:[[myCaseSource objectAtIndex:i] objectForKey:@"key"] andSubtitle:@"" andCaseID:[[myCaseSource objectAtIndex:i] objectForKey:@"key"]];
		[annotationArray addObject:casePlace];
		[casePlace release];
	}
	return annotationArray;
}

- (NSInteger)numberOfSectionsInList {
	return 1;
}

- (NSInteger)numberOfRowsInListSection:(NSInteger)section {
	if ([[dictUserInformation valueForKey:@"User Email"] length]==0) return 1;
	else return [myCaseSource count];
}

- (CGFloat)heightForRowAtIndexPathInList:(NSIndexPath *)indexPath {
	if ([[dictUserInformation valueForKey:@"User Email"] length]==0) return 372;
	else return [CaseSelectorCell cellHeight];
}

- (NSString *)titleForHeaderInSectionInList:(NSInteger)section {
	if ([[dictUserInformation valueForKey:@"User Email"] length]==0) return @"";
	else return @"XD";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	if ([[dictUserInformation valueForKey:@"User Email"] length]==0) {
		CaseSelectorCell *cell = (CaseSelectorCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell==nil) {
			cell = [[[CaseSelectorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NoMyCase.png"]];
		cell.backgroundView = background;
		[background release];
		tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;
	}
	
	CaseSelectorCell *cell = (CaseSelectorCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[CaseSelectorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	cell.backgroundView = nil;
	// Case ID
	cell.caseID.text = [NSString stringWithFormat:@"%d" , [[myCaseSource objectAtIndex:indexPath.row] objectForKey:@"key"]];
	// Case Type
	NSString *caseTypeText = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"QidToType" ofType:@"plist"]] valueForKey:[[myCaseSource objectAtIndex:indexPath.row] valueForKey:@"typeid"]];
	cell.caseType.text = caseTypeText;
	// Case Date
	if ([[myCaseSource objectAtIndex:indexPath.row] objectForKey:@"date"]!=nil) {
		// Original ROC Format
		NSString *originalDate = [[[[[myCaseSource objectAtIndex:indexPath.row] objectForKey:@"date"] stringByReplacingOccurrencesOfString:@"年" withString:@"/"]
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
	caseCoord.longitude  = [[[[myCaseSource objectAtIndex:indexPath.row] objectForKey:@"coordinates"] objectAtIndex:0] doubleValue];
	caseCoord.latitude = [[[[myCaseSource objectAtIndex:indexPath.row] objectForKey:@"coordinates"] objectAtIndex:1] doubleValue];
	//cell.caseAddress.text = [[MGOVGeocoder returnFullAddress:caseCoord] substringFromIndex:5];
	
	return cell;
}

- (void)dealloc {
	//[dictUserInformation release];
	[super dealloc];
}

@end
