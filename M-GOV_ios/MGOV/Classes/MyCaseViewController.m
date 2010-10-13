//
//  MyCaseViewController.m
//  MGOV
//
//  Created by sodas on 2010/9/9.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "MyCaseViewController.h"

@implementation MyCaseViewController

#pragma mark -
#pragma mark Override

- (id)initWithMode:(HybridViewMenuMode)mode andTitle:(NSString *)title {
	UIBarButtonItem *addCaseButton = [[UIBarButtonItem alloc] initWithTitle:@"新增案件" style:UIBarButtonItemStyleBordered target:self action:@selector(addCase)];
	// Set Range length to 0 to fectch all data
	queryRange = NSRangeFromString(@"0,0");
	self = [self initWithMode:mode andTitle:title withRightBarButtonItem:addCaseButton];
	[addCaseButton release];
	return self;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
	UIViewController *popResult = [super popViewControllerAnimated:animated];
	if (![self myCaseDataAvailability]) informationBar.hidden = YES;
	[childViewController cleanTableView];
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
	if ([[PrefAccess readPrefByKey:@"User Email"] length]) {
		self.currentConditionType = DataSourceGAEQueryByEmail;
		self.currentCondition = [PrefAccess readPrefByKey:@"User Email"];
		[filter setSelectedSegmentIndex:0];
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

#pragma mark -
#pragma mark Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	// Update Datasource
	caseSourceDidLoaded = NO;
	if ([[PrefAccess readPrefByKey:@"User Email"] length])
		[self queryGAEwithConditonType:DataSourceGAEQueryByEmail andCondition:[PrefAccess readPrefByKey:@"User Email"]];
	else caseSourceDidLoaded = YES;
	
	// Add Filter
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
	[filter release];
	
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
	return (([[PrefAccess readPrefByKey:@"User Email"] length]!=0 && [caseSource count]!=0)||filter.selectedSegmentIndex!=0);
}

- (void)addCase {
	// Call the add case view
	CaseAddViewController *caseAdder = [[CaseAddViewController alloc] initWithStyle:UITableViewStyleGrouped];
	caseAdder.myCase = self;
	informationBar.hidden = YES;
	[self pushViewController:caseAdder animated:YES];
	[caseAdder release];
}

- (void)setCaseFilter:(UISegmentedControl *)segmentedControl {
	if (segmentedControl.selectedSegmentIndex != currentSegmentIndex) {
		// Defined a new case query condition
		NSArray *keyArray = [[NSArray alloc] initWithObjects:@"DataSourceGAEQueryByEmail", @"DataSourceGAEQueryByStatus", nil];
		// Set status by selected segment
		NSString *statusCondition;
		if (segmentedControl.selectedSegmentIndex==0) {
			[keyArray release];
			keyArray = [[NSArray alloc] initWithObjects:@"DataSourceGAEQueryByEmail", nil];
			statusCondition = nil;
		} else if (segmentedControl.selectedSegmentIndex==1) {
			statusCondition = [NSString stringWithFormat:@"%d", 1];
		} else if (segmentedControl.selectedSegmentIndex==2) {
			statusCondition = [NSString stringWithFormat:@"%d", 0];
		} else if (segmentedControl.selectedSegmentIndex==3) {
			statusCondition = [NSString stringWithFormat:@"%d", 2];
		}
		currentSegmentIndex = segmentedControl.selectedSegmentIndex;
		NSArray *valueArray = [[NSArray alloc] initWithObjects:[PrefAccess readPrefByKey:@"User Email"], statusCondition, nil];
		NSDictionary *conditionDictionary = [[NSDictionary alloc] initWithObjects:valueArray forKeys:keyArray];
		[self queryGAEwithConditonType:DataSourceGAEQueryByMultiConditons andCondition:conditionDictionary];
		[conditionDictionary release];
		[keyArray release];
		[valueArray release];
	}
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
	
	[self refreshViews];
	
	if ([self myCaseDataAvailability]) informationBar.hidden = NO;
	else informationBar.hidden = YES;
	
	self.topViewController.navigationItem.leftBarButtonItem.enabled = YES;
	self.topViewController.navigationItem.rightBarButtonItem.enabled = YES;
	for (NSUInteger i=0; i<filter.numberOfSegments; i++)
		if (i!=filter.selectedSegmentIndex)
			[filter setEnabled:YES forSegmentAtIndex:i];
	[super recieveQueryResultType:type withResult:result];
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	[super dealloc];
}

@end
