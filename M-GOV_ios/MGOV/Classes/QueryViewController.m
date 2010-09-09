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
	UIBarButtonItem *setConditionButton = [[[UIBarButtonItem alloc] initWithTitle:@"設定條件" style:UIBarButtonItemStyleBordered target:self action:@selector(setQueryCondition)] autorelease];
	
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
	UIActionSheet *setCondition = [[UIActionSheet alloc] initWithTitle:@"設定搜尋條件" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"重設所有搜尋條件" otherButtonTitles:@"設定案件種類", @"回到現在位置", nil];
	[setCondition showFromTabBar:self.tabBarController.tabBar];
	[setCondition release];
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
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex==0) {
		NSLog(@"Reset");
	} else if (buttonIndex==1) {
		NSLog(@"Type");
	} else if (buttonIndex==2) {
		NSLog(@"Back");
	} else if (buttonIndex==3) {
		// Do nothing but cancel
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
	
	NSString *caseTypeText = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"QidToType" ofType:@"plist"]] valueForKey:[[queryCaseSource objectAtIndex:indexPath.row] valueForKey:@"typeid"]];
	cell.caseType.text = caseTypeText;
	cell.caseDate.text = @"兩天前";
	CLLocationCoordinate2D caseCoord;
	caseCoord.longitude  = [[[[queryCaseSource objectAtIndex:indexPath.row] objectForKey:@"coordinates"] objectAtIndex:0] doubleValue];
	caseCoord.latitude = [[[[queryCaseSource objectAtIndex:indexPath.row] objectForKey:@"coordinates"] objectAtIndex:1] doubleValue];
	cell.caseAddress.text = [MGOVGeocoder returnFullAddress:caseCoord];
	
	return cell;
}

@end