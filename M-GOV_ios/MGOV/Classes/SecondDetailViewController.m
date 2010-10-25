/*
 * 
 * SecondDetailViewController.h
 * 2010/8/11
 * sodas
 * 
 * A table which will provide more detail info of some type detail
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

#import "SecondDetailViewController.h"

@implementation SecondDetailViewController

@synthesize finalSectionId;
@synthesize finalTypeId;
@synthesize finalDetailId;
@synthesize finalSecondDetailId;
@synthesize delegate;

#pragma mark -
#pragma mark Lifecycle

- (void)viewDidLoad {
	// Second Detail Dict
	NSString *path = [[NSBundle mainBundle] pathForResource:@"reportSecondDetails" ofType:@"plist"];
	secondDetailDict = [[NSDictionary alloc] initWithContentsOfFile:path];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Open plist
	NSString *sectionId = [NSString stringWithFormat:@"Section%d", finalSectionId];
	NSString *typeId = [NSString stringWithFormat:@"Type%d", finalTypeId];
	NSString *detailId = [NSString stringWithFormat:@"Detail%d", finalDetailId];

    return [[[[secondDetailDict objectForKey:sectionId] objectForKey:typeId] objectForKey:detailId] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
     // Open plist - First class
	NSString *sectionId = [NSString stringWithFormat:@"Section%d", finalSectionId];
	NSString *typeId = [NSString stringWithFormat:@"Type%d", finalTypeId];
	NSString *detailId = [NSString stringWithFormat:@"Detail%d", finalDetailId];
	NSString *secondDetailId = [NSString stringWithFormat:@"SecondDetail%d", indexPath.row];
		
	cell.textLabel.text = [[[[secondDetailDict objectForKey:sectionId] objectForKey:typeId] objectForKey:detailId] valueForKey:secondDetailId];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	finalSecondDetailId = indexPath.row;
	// Generate qid
	// Merge names
	NSString *path = [[NSBundle mainBundle] pathForResource:@"reportQid" ofType:@"plist"];
	NSString *sectionId = [NSString stringWithFormat:@"Section%d", finalSectionId];
	NSString *typeId = [NSString stringWithFormat:@"Type%d", finalTypeId];
	NSString *detailId = [NSString stringWithFormat:@"Detail%d", finalDetailId];
	NSString *secondDetailId = [NSString stringWithFormat:@"SecondDetail%d", finalSecondDetailId];
	// Open the qid plist
	NSInteger qid = [[[[[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:sectionId] objectForKey:typeId] objectForKey:detailId] valueForKey:secondDetailId] intValue];
	
	// Title
	NSString *finalSection = [NSString stringWithFormat:@"Section%d", finalSectionId];
	NSString *finalType = [NSString stringWithFormat:@"Type%d", finalTypeId];
	NSString *finalDetail = [NSString stringWithFormat:@"Detail%d", finalDetailId];
	NSString *finalSecondDetail = [NSString stringWithFormat:@"SecondDetail%d", finalSecondDetailId];
	
	NSString *selectedTitle = [[[[secondDetailDict objectForKey:finalSection] objectForKey:finalType] objectForKey:finalDetail] valueForKey:finalSecondDetail];
	
	// Switch back
	[delegate typeSelectorDidSelectWithTitle:selectedTitle andQid:qid];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[secondDetailDict release];
    [super dealloc];
}


@end

