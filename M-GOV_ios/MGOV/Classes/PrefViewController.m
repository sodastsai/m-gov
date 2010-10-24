/*
 * 
 * PrefViewController.m
 * 2010/10/2
 * sodas
 * 
 * Preference table view
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

#import "PrefViewController.h"

@implementation PrefViewController

@synthesize originalEmail;

#pragma mark -
#pragma mark WritePrefDelegate

- (void)writeToPrefWithKey:(NSString *)key andObject:(id)value {
	if (![self preScriptBeforeSaveKey:key andObject:value]) {
		[self alertWhileFailToWriteWithTitle:@"E-Mail格式錯誤" andContent:@"請輸入正確的E-Mail！"];
		[self.tableView reloadData];
	} else {
		[PrefAccess writePrefByKey:key andObject:value];
		[self.tableView reloadData];
		// Run post action
		[self postScriptAfterSaveKey:key andObject:value];
	}
}

#pragma mark -
#pragma mark Method

- (void)alertWhileFailToWriteWithTitle:(NSString *)alertTitle andContent:(NSString *)alertContent {
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertContent delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
}

- (BOOL)preScriptBeforeSaveKey:(NSString *)key andObject:(id)value {
	if ([key isEqualToString:@"User Email"]) {
		// Check Email Format
		if (![value length]) {
			[self alertWhileFailToWriteWithTitle:@"已清除您的E-Mail帳號" andContent:@"如果要查詢以前報過的案件，請再次輸入您的E-Mail帳號即可。"];
			return YES; 
		}
		NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z0-9.-]";
		NSRange r = [value rangeOfString:emailRegex options:NSRegularExpressionSearch];
		if (r.location != NSNotFound) return YES;
		else return NO;
		
		emailRegex = nil;
	} else {
		// Nothing to check
		return YES;
	}
}

- (void)postScriptAfterSaveKey:(NSString *)key andObject:(id)value {
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
	if (section==0) return 2;
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
		if (indexPath.section==0 && indexPath.row==0) {
			editibleCell.delegate = self;
			editibleCell.prefKey = @"User Email";
			editibleCell.titleField.text = @"E-Mail";
			editibleCell.contentField.text = [PrefAccess readPrefByKey:@"User Email"];
			editibleCell.contentField.placeholder = @"請輸入您的E-Mail帳號";
			editibleCell.contentField.keyboardType = UIKeyboardTypeEmailAddress;
			editibleCell.contentField.autocorrectionType = UITextAutocorrectionTypeNo;
			editibleCell.contentField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		} else if (indexPath.section==0 && indexPath.row==1) {
			editibleCell.delegate = self;
			editibleCell.prefKey = @"Name";
			editibleCell.titleField.text = @"姓名";
			editibleCell.contentField.text = [PrefAccess readPrefByKey:@"Name"];
			editibleCell.contentField.placeholder = @"請輸入您的姓名";
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

- (void)dealloc {
    [super dealloc];
}

@end

