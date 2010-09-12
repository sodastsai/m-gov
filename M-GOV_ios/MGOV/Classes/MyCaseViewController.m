    //
//  MyCaseViewController.m
//  MGOV
//
//  Created by sodas on 2010/9/9.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "MyCaseViewController.h"

@implementation MyCaseViewController

@synthesize myCaseSource;

#pragma mark -
#pragma mark Lifecycle

// Override the super class
- (id)initWithMode:(CaseSelectorMenuMode)mode andTitle:(NSString *)title {
	UIBarButtonItem *addCaseButton = [[[UIBarButtonItem alloc] initWithTitle:@"新增案件" style:UIBarButtonItemStyleBordered target:self action:@selector(addCase)] autorelease];
	
	QueryGoogleAppEngine *qGAE = [[QueryGoogleAppEngine alloc] init];
	qGAE.conditionType = DataSourceGAEQueryByType;
	qGAE.resultTarget = self;
	qGAE.queryCondition = @"1110";
	qGAE.resultRange = NSRangeFromString(@"0,50");
	[qGAE startQuery];
	[qGAE release];
	
	return [self initWithMode:mode andTitle:title withRightBarButtonItem:addCaseButton];
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

#pragma mark -
#pragma mark QueryGAEReciever

- (void)recieveQueryResultType:(DataSourceGAEReturnTypes)type withResult:(id)result {
	// Accept Array only
	if (type == DataSourceGAEReturnByNSArray) {
		self.myCaseSource = result;
	} else {
		myCaseSource = nil;
	}

}

#pragma mark -
#pragma mark CaseSelectorDelegate

- (void)didSelectRowAtIndexPathInList:(NSIndexPath *)indexPath {
	CaseViewerViewController *caseViewer = [[CaseViewerViewController alloc] initWithCaseID:[[myCaseSource objectAtIndex:indexPath.row] valueForKey:@"key"]];
	[self.topViewController.navigationController pushViewController:caseViewer animated:YES];
}

#pragma mark -
#pragma mark  CaseSelectorDataSource

- (NSInteger)numberOfSectionsInList {
	return 1;
}

- (NSInteger)numberOfRowsInListSection:(NSInteger)section {
	return [myCaseSource count];
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
	cell.caseID.text = [[myCaseSource objectAtIndex:indexPath.row] objectForKey:@"key"];
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
	cell.caseAddress.text = [[MGOVGeocoder returnFullAddress:caseCoord] substringFromIndex:5];
	
	return cell;
}

@end
