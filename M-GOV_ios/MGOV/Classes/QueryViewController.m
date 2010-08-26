//
//  QueryViewController.m
//  MGOV
//
//  Created by iphone on 2010/8/25.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "QueryViewController.h"
#import "typesViewController.h"

@implementation QueryViewController

#pragma mark -
#pragma mark QueryViewController Method

- (BOOL)submitQuery {
	NSLog(@"submitQuery");
	return YES;
	
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"送出" style:UIBarButtonItemStylePlain target:self action:@selector(submitQuery)];
	self.navigationItem.rightBarButtonItem = submitButton;
	[submitButton release];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
	// Set the height according to the edit area size
    if (indexPath.section == 0) {
		return 200;
	} else if (indexPath.section == 1 ){
		return 45;
	}
	return 40;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// TODO: location (use mapView)
    if (indexPath.section == 0) {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	else {
		// Check plist
		NSString *typeSelectorStatusPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"TypeSelectorStatus.plist"];
		NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:typeSelectorStatusPlistPathInAppDocuments];
		// Decide placeholder or selected result to show
		if ( [plistDict valueForKey:@"queryReadable"] && [[plistDict valueForKey:@"Invoker"] isEqualToString:@"query"] )
			cell.textLabel.text = [plistDict valueForKey:@"queryContent"];
		else
			cell.textLabel.text = @"請按此選擇案件種類";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section==1 && indexPath.row==0) {
		typesViewController *typesView = [[typesViewController alloc] init];
		typesView.title = @"請選擇案件種類";
		UINavigationController *typeAndDetailSelector = [[UINavigationController alloc] initWithRootViewController:typesView];
		// Show the view
		typesView.delegate = self;
		[self presentModalViewController:typeAndDetailSelector animated:YES];
		// Add Back button
		UIBarButtonItem *backBuuton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:typesView action:@selector(backToPreviousView)];
		typesView.navigationItem.leftBarButtonItem = backBuuton;
		[backBuuton release];
		[typesView release];
		
		// Record to plist
		NSString *typeSelectorStatusPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"TypeSelectorStatus.plist"];
		NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:typeSelectorStatusPlistPathInAppDocuments];
		[dict setValue:@"query" forKey:@"Invoker"];
		[dict setValue:0 forKey:@"queryReadable"];
		[dict writeToFile:typeSelectorStatusPlistPathInAppDocuments atomically:YES];
	}
}

#pragma mark -
#pragma mark TypeSelectorDelegateProtocol

- (void)backToPreviousView {
	// Dismiss the view
	[self dismissModalViewControllerAnimated:YES];
	// Reload tableview after selected
	[self.tableView reloadData];
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
