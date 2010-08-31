//
//  MyCaseViewController.m
//  MGOV
//
//  Created by Shou 2010/8/24.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "MyCaseViewController.h"
#import "GlobalVariable.h"
#import "FirstRunCellViewController.h"

@implementation MyCaseViewController

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
	
	if (![userEmail length]) self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (![userEmail length]) {
		// The full cell height including a navigation bar and a tabbar
		return 372;
	}
	// Default Height is 44.
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (![userEmail length]) {
		// FirstRun Guide
		FirstRunCellViewController *firstCell = [[[FirstRunCellViewController alloc] init] autorelease];
		return (UITableViewCell *)firstCell.view;
	} else {
		// Show cases
		static NSString *CellIdentifier = @"Cell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		return cell;
	}
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
