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

#pragma mark -
#pragma mark Lifecycle

// Override the super class
- (id)initWithMode:(CaseSelectorMenuMode)mode andTitle:(NSString *)title {
	UIBarButtonItem *setConditionButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(setQueryCondition)] autorelease];
	
	QueryGoogleAppEngine *qGAE = [[QueryGoogleAppEngine alloc] init];
	qGAE.conditionType = DataSourceGAEQueryByType;
	qGAE.returnType = DataSourceGAEReturnByNSArray;
	qGAE.resultTarget = self;
	qGAE.queryCondition = @"1110";
	qGAE.resultRange = NSRangeFromString(@"0,10");
	[qGAE startQuery];
	[qGAE release];
	
	return [self initWithMode:mode andTitle:title withRightBarButtonItem:setConditionButton];
}

#pragma mark -
#pragma mark Method

- (void)setQueryCondition {
	NSLog(@"XD");
}

#pragma mark -
#pragma mark QueryGAEReciever

- (void)recieveQueryResultType:(DataSourceGAEReturnTypes)type withResult:(id)result {
	// Accept Array only
	if (type == DataSourceGAEReturnByNSArray) {
		self.queryCaseSource = result;
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
	return [queryCaseSource count];
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