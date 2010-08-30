//
//  MyCaseViewController.m
//  MGOV
//
//  Created by Shou 2010/8/24.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "MyCaseViewController.h"
#import "GlobalVariable.h"

@implementation MyCaseViewController

@synthesize firstRunCell;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	
    [super viewDidLoad];
	// Add Case Button
	UIBarButtonItem *addCaseButton = [[UIBarButtonItem alloc] initWithTitle:@"新增案件" style:UIBarButtonItemStylePlain target:self action:@selector(addCase)];
	self.navigationItem.rightBarButtonItem = addCaseButton;
	[addCaseButton release];
	
	NSString *plistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"UserInformation.plist"];
	userEmail = [[NSDictionary dictionaryWithContentsOfFile:plistPathInAppDocuments] valueForKey:@"User Email"];
}

- (void) addCase {
	// Call the add case view
	CaseAddViewController *caseAdder = [[CaseAddViewController alloc] initWithStyle:UITableViewStyleGrouped];
	[self.navigationController pushViewController:caseAdder animated:YES];	
	[caseAdder release];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (![userEmail length]) {
		// FirstRun
		return 1;
	}
	// MyCase
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (![userEmail length]) {
		// FirstRun
		return 1;
	}
	// MyCase
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // To call the case viewer
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}

- (void)dealloc {
    [super dealloc];
}

@end
