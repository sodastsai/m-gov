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
	qGAE.returnType = DataSourceGAEReturnByNSArray;
	qGAE.resultTarget = self;
	qGAE.queryCondition = @"1110";
	qGAE.resultRange = NSRangeFromString(@"0,10");
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
	}
}

#pragma mark -
#pragma mark CaseSelectorDelegate

- (void)didSelectRowAtIndexPathInList:(NSIndexPath *)indexPath {
	NSLog(@"Hit");
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
	return 44;
}

- (NSString *)titleForHeaderInSectionInList:(NSInteger)section {
	return @"XD";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	cell.textLabel.text = @"XDDD";
	return cell;
}

@end
