/*
 * 
 * MyCaseViewController.m
 * 2010/9/9
 * sodas
 * 
 * The Main View Controller of My Case
 *
 * Copyright 2010 NTU CSIE Mobile & HCI Lab
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#import "MyCaseViewController.h"

@implementation MyCaseViewController

#pragma mark -
#pragma mark Override

- (id)initWithMode:(HybridViewMenuMode)mode andTitle:(NSString *)title {
	// Set Range length to 0 to fectch all data
	queryRange = NSRangeFromString(@"0,0");
	
	UIBarButtonItem *addCaseButton = [[UIBarButtonItem alloc] initWithTitle:@"新增案件" style:UIBarButtonItemStyleBordered target:self action:@selector(addCase)];
	self = [self initWithMode:mode andTitle:title withRightBarButtonItem:addCaseButton];
	[addCaseButton release];
	
	return self;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
	// Pop original one
	UIViewController *popResult = [super popViewControllerAnimated:animated];
	
	if (![self myCaseDataAvailability]) informationBar.hidden = YES;
	[childViewController cleanTableView];
	
	// Return original one
	return popResult;
}

- (void)didSelectRowAtIndexPathInList:(NSIndexPath *)indexPath {
	if ([self myCaseDataAvailability])
		[super didSelectRowAtIndexPathInList:indexPath];
}

- (NSInteger)numberOfSectionsInList {
	if (![self myCaseDataAvailability]) return 1;
	else return [super numberOfSectionsInList];
}

- (NSInteger)numberOfRowsInListSection:(NSInteger)section {
	if (![self myCaseDataAvailability]) return 1;
	else return [super numberOfRowsInListSection:section];
}

- (CGFloat)heightForRowAtIndexPathInList:(NSIndexPath *)indexPath {
	if (![self myCaseDataAvailability]) return 372;
	else return [super heightForRowAtIndexPathInList:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (![self myCaseDataAvailability]) {
		static NSString *CellIdentifier = @"NoMyCaseCell";
		CaseSelectorCell *cell = (CaseSelectorCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell==nil) {
			cell = [[[CaseSelectorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		// Check If case source is loaded
		// After it has been loaded, we could decide which to show
		if (caseSourceDidLoaded) {
			UIImageView *cellNoCase = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NoMyCase.png"]];
			cell.backgroundView = cellNoCase;
			[cellNoCase release];
		} else {
			UIView *cellGray = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
			cellGray.backgroundColor = [UIColor darkGrayColor];
			cell.backgroundView = cellGray;
			[cellGray release];
		} 
		
		tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;
		return cell;
		
	} else return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)refreshDataSource {
	if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"User Email"] length]) {
		self.currentConditionType = DataSourceGAEQueryByMultiConditons;
		self.currentCondition = [self setConditionWithEmailAndFilter:filter];

		[super refreshDataSource];
	} else {
		caseSourceDidLoaded = YES;
		[self.listViewController.tableView reloadData];
		informationBar.hidden = YES;
	}
}

- (void)queryGAEwithConditonType:(DataSourceGAEQueryTypes)conditionType andCondition:(id)condition {
	for (NSUInteger i=0; i<filter.numberOfSegments; i++)
		if (i!=filter.selectedSegmentIndex)
			[filter setEnabled:NO forSegmentAtIndex:i];
	[super queryGAEwithConditonType:conditionType andCondition:condition];
}

- (void)changeToAnotherMode {
	[super changeToAnotherMode];
	if (menuMode == HybridViewMapMode)
		[GoogleAnalytics trackAction:GANActionMyCaseMapMode withLabel:nil andTimeStamp:NO andUDID:NO];
	else
		[GoogleAnalytics trackAction:GANActionMyCaseListMode withLabel:nil andTimeStamp:NO andUDID:NO];
}

#pragma mark -
#pragma mark Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	// Update Datasource
	caseSourceDidLoaded = NO;
	if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"User Email"] length]) {
		// Since App Engine will be slow at first start up and then time out, we send twice here.
		// Dummy one
		QueryGoogleAppEngine *qGAE = [QueryGoogleAppEngine requestQuery];
		qGAE.resultTarget = nil;
		qGAE.indicatorTargetView = nil;
		qGAE.resultRange = NSRangeFromString(@"0,1");
		qGAE.conditionType = DataSourceGAEQueryByEmail;
		qGAE.queryCondition = @"a@b.c";
		[qGAE startQuery];
		// Real one
		[self queryGAEwithConditonType:DataSourceGAEQueryByEmail andCondition:[[NSUserDefaults standardUserDefaults] stringForKey:@"User Email"]];
	} else caseSourceDidLoaded = YES;
	
	// Add Filter
	if (filter==nil)
		filter = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"所有案件", @"完工", @"處理中", @"退回", nil]];
	filter.segmentedControlStyle = UISegmentedControlStyleBar;
	// Use int for clear view
	int filterX = (320 - filter.frame.size.width)/2;
	int filterY = (44 - filter.frame.size.height)/2;
	filter.frame = CGRectMake(filterX, filterY, filter.frame.size.width, filter.frame.size.height);
	filter.selectedSegmentIndex = 0;
	currentSegmentIndex = 0;
	[filter addTarget:self action:@selector(setCaseFilter:) forControlEvents:UIControlEventValueChanged];
		
	[informationBar addSubview:filter];
	
	if ([self myCaseDataAvailability]) {
		informationBar.hidden = NO;
	} else {
		// Hide Filter/InformationBar
		informationBar.hidden = YES;
	}
}

#pragma mark -
#pragma mark Method

- (BOOL)myCaseDataAvailability {
	return (([[[NSUserDefaults standardUserDefaults] stringForKey:@"User Email"] length]!=0 && [caseSource count]!=0)||filter.selectedSegmentIndex!=0);
}

- (void)addCase {
	// Call the add case view
	if (caseAdder==nil)
		caseAdder = [[CaseAddViewController alloc] initWithStyle:UITableViewStyleGrouped];
	caseAdder.myCase = self;
	informationBar.hidden = YES;
	
	[self pushViewController:caseAdder animated:YES];
}

- (void)setCaseFilter:(UISegmentedControl *)segmentedControl {
	if (segmentedControl.selectedSegmentIndex != currentSegmentIndex) {
		[self queryGAEwithConditonType:DataSourceGAEQueryByMultiConditons andCondition:[self setConditionWithEmailAndFilter:segmentedControl]];
		currentSegmentIndex = segmentedControl.selectedSegmentIndex;
		
		if (segmentedControl.selectedSegmentIndex==0)
			[GoogleAnalytics trackAction:GANActionMyCaseFilterAll withLabel:nil andTimeStamp:NO andUDID:NO];
		else if (segmentedControl.selectedSegmentIndex==1)
			[GoogleAnalytics trackAction:GANActionMyCaseFilterOK withLabel:nil andTimeStamp:NO andUDID:NO];
		else if (segmentedControl.selectedSegmentIndex==2)
			[GoogleAnalytics trackAction:GANActionMyCaseFilterUnknown withLabel:nil andTimeStamp:NO andUDID:NO];
		else if (segmentedControl.selectedSegmentIndex==3)
			[GoogleAnalytics trackAction:GANActionMyCaseFilterFailed withLabel:nil andTimeStamp:NO andUDID:NO];
	}
}

- (NSDictionary *)setConditionWithEmailAndFilter:(UISegmentedControl *)statusFilter {
	// Defined a new case query condition
	NSArray *keyArray = [[NSArray alloc] initWithObjects:@"DataSourceGAEQueryByEmail", @"DataSourceGAEQueryByStatus", nil];
	
	// Set status by selected segment
	NSString *statusCondition = @"";
	if (statusFilter.selectedSegmentIndex==0) {
		[keyArray release];
		keyArray = [[NSArray alloc] initWithObjects:@"DataSourceGAEQueryByEmail", nil];
		statusCondition = nil;
	} else if (statusFilter.selectedSegmentIndex==1) {
		statusCondition = [NSString stringWithFormat:@"%d", 1];
	} else if (statusFilter.selectedSegmentIndex==2) {
		statusCondition = [NSString stringWithFormat:@"%d", 0];
	} else if (statusFilter.selectedSegmentIndex==3) {
		statusCondition = [NSString stringWithFormat:@"%d", 2];
	}
	
	NSArray *valueArray = [[NSArray alloc] initWithObjects:[[NSUserDefaults standardUserDefaults] stringForKey:@"User Email"], statusCondition, nil];
	NSDictionary *conditionDictionary = [[[NSDictionary alloc] initWithObjects:valueArray forKeys:keyArray] autorelease];
	
	[keyArray release];
	[valueArray release];
	
	return conditionDictionary;
}

#pragma mark -
#pragma mark QueryGAEReciever

- (void)recieveQueryResultType:(DataSourceGAEReturnTypes)type withResult:(id)result {
	// Accept Array only
	if (type == DataSourceGAEReturnByNSDictionary) {
		self.caseSource = [result objectForKey:@"result"];
	} else {
		caseSource = nil;
	}
	caseSourceDidLoaded = YES;
	
	if ([self myCaseDataAvailability]) informationBar.hidden = NO;
	else informationBar.hidden = YES;
	
	for (NSUInteger i=0; i<filter.numberOfSegments; i++)
		if (i!=filter.selectedSegmentIndex)
			[filter setEnabled:YES forSegmentAtIndex:i];
	
	[super recieveQueryResultType:type withResult:result];
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	[filter release];
	[caseAdder release];
	[super dealloc];
}

@end
