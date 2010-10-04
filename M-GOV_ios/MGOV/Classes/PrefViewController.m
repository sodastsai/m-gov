//
//  PrefViewController.m
//  MGOV
//
//  Created by sodas on 2010/10/2.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "PrefViewController.h"

@implementation PrefViewController

#pragma mark -
#pragma mark WritePrefDelegate

- (void)writeToPrefWithKey:(NSString *)key andObject:(id)value {
	if (![self preScriptBeforeSaveKey:key]) return;
	[PrefAccess writePrefByKey:key andObject:value];
	[self.tableView reloadData];
	// Run post action
	[self postScriptAfterSaveKey:key];
}

#pragma mark -
#pragma mark Method

- (BOOL)preScriptBeforeSaveKey:(NSString *)key {
	// TODO: check email format
	// Return NO if format is not correct, or return YES while email format is correct.
	return YES;
}

- (void)postScriptAfterSaveKey:(NSString *)key {
	if ([key isEqualToString:@"User Email"]) {
		if ([self.parentViewController.parentViewController isKindOfClass:[UITabBarController class]]) {
			UITabBarController *mainBar = (UITabBarController *)self.parentViewController.parentViewController;
			NSEnumerator *enumerator = [mainBar.viewControllers objectEnumerator];
			id eachViewController;
			while (eachViewController = [enumerator nextObject])
				if([eachViewController isKindOfClass:[MyCaseViewController class]])
					[eachViewController refreshDataSource];
		}
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section==0) return 1;
	else return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section==0) return @"個人資訊";
	else return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	// Last section
	if (section == [self numberOfSectionsInTableView:tableView]-1) 
		if ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"Release State"]!=nil)
			return [NSString stringWithFormat:@"路見不平 %@\n%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Release State"]];
		else return [NSString stringWithFormat:@"路見不平 %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
	else return nil;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier1 = @"DefaultCell";
	static NSString *CellIdentifier2 = @"EditibleTextFieldCell";
	
	if (indexPath.section==0) {
		EditibleTextFieldCell *editibleCell = (EditibleTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
		if (editibleCell == nil)
			editibleCell = [[[EditibleTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];
		if (indexPath.section==0) {
			editibleCell.delegate = self;
			editibleCell.prefKey = @"User Email";
			editibleCell.titleField.text = @"E-Mail";
			editibleCell.contentField.text = [PrefAccess readPrefByKey:@"User Email"];
			editibleCell.contentField.placeholder = @"請輸入您的E-Mail帳號";
			editibleCell.contentField.keyboardType = UIKeyboardTypeEmailAddress;
			editibleCell.contentField.autocorrectionType = UITextAutocorrectionTypeNo;
			editibleCell.contentField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		}
		editibleCell.selectionStyle = UITableViewCellSeparatorStyleNone;
		return (UITableViewCell *)editibleCell;
	} else {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
		if (cell == nil)
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
		return cell;
	}
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark -
#pragma mark Lifecycle

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
}

- (void)viewDidUnload {
}

- (void)dealloc {
    [super dealloc];
}

@end

