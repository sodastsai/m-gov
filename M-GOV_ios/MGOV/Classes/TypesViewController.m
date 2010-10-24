/*
 * 
 * TypesViewController.m
 * 2010/8/11
 * sodas
 * 
 * A table which will provide all case types
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

#import "TypesViewController.h"
#import "DetailViewController.h"

@implementation TypesViewController

@synthesize delegate;

#pragma mark -
#pragma mark Lifecycle

- (void)viewDidLoad {
	NSString *path;
	
	// Section
	path = [[NSBundle mainBundle] pathForResource:@"reportSections" ofType:@"plist"];
	sectionDict = [[NSDictionary alloc] initWithContentsOfFile:path];
	
	// Type
	path = [[NSBundle mainBundle] pathForResource:@"reportTypes" ofType:@"plist"];
	typeDict = [[NSDictionary alloc] initWithContentsOfFile:path];
	
	// Detail
	path = [[NSBundle mainBundle] pathForResource:@"reportDetails" ofType:@"plist"];
	detailDict = [[NSDictionary alloc] initWithContentsOfFile:path];
	
	path = nil;
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sectionDict count];
}

// Section names
- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
	return [sectionDict valueForKey:[NSString stringWithFormat:@"Section%d", section]];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[typeDict objectForKey:[NSString stringWithFormat:@"Section%d", section]] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	
	// Open the plist
	NSString *sectionId = [NSString stringWithFormat:@"Section%d", indexPath.section];
	NSString *typeString = [NSString stringWithFormat:@"Type%d", indexPath.row];
	
	cell.textLabel.text = [[typeDict objectForKey:sectionId] valueForKey:typeString];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	sectionId = nil;
	typeString = nil;
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// Record for qid
	finalSectionId = indexPath.section;
	finalTypeId = indexPath.row;
	
	// Check if 1-level only
	// Open plist
	NSString *sectionId = [NSString stringWithFormat:@"Section%d", finalSectionId];
	NSString *typeId = [NSString stringWithFormat:@"Type%d", finalTypeId];

	// Title
	NSString *selectedTitle = [[typeDict objectForKey:sectionId] valueForKey:typeId];
	
	// Check detail
    if([[[detailDict objectForKey:sectionId] objectForKey:typeId] count]){
		// 2-level or more
		DetailViewController *details = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
		// Record
		details.finalSectionId = finalSectionId;
		details.finalTypeId = finalTypeId; 
		details.title = selectedTitle;
		details.delegate = self.delegate;
				
		// Pass the selected object to the new view controller.
		[self.navigationController pushViewController:details animated:YES];
		[details release];
		
	} else {
		// 1-level only
		// Generate qid
		// Merge names
		NSString *qidPath = [[NSBundle mainBundle] pathForResource:@"reportQid" ofType:@"plist"];
		// Open the qid plist
		NSInteger qid = [[[[NSDictionary dictionaryWithContentsOfFile:qidPath] objectForKey:sectionId] valueForKey:typeId] intValue];
				
		// Switch back
		[delegate typeSelectorDidSelectWithTitle:selectedTitle andQid:qid];
		
		qidPath = nil;
	}
	
	typeId = nil;
	sectionId = nil;
	selectedTitle = nil;
	
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
	UIBarButtonItem *backBuuton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:delegate action:@selector(leaveSelectorWithoutTitleAndQid)];
	self.navigationItem.leftBarButtonItem = backBuuton;
	[backBuuton release];
	self.title = @"請選擇案件種類";
}

- (void)dealloc {
	[sectionDict release];
	[typeDict release];
	[detailDict release];
    [super dealloc];
}

@end
