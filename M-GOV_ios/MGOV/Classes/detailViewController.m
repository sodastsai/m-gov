//
//  detailViewController.m
//  MGOV
//
//  Created by sodas on 2010/8/11.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "detailViewController.h"
#import "secondDetailViewController.h"

@implementation detailViewController

@synthesize finalSectionId;
@synthesize finalTypeId;
@synthesize finalDetailId;
@synthesize delegate;

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Open plist
	NSString *path = [[NSBundle mainBundle] pathForResource:@"reportDetails" ofType:@"plist"];
	NSString *sectionId = [NSString stringWithFormat:@"Section%d", finalSectionId];
	NSString *typeId = [NSString stringWithFormat:@"Type%d", finalTypeId];

    return [[[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:sectionId] objectForKey:typeId] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Open plist
	NSString *path = [[NSBundle mainBundle] pathForResource:@"reportDetails" ofType:@"plist"];
	NSString *sectionId = [NSString stringWithFormat:@"Section%d", finalSectionId];
	NSString *typeId = [NSString stringWithFormat:@"Type%d", finalTypeId];
	NSString *detailId = [NSString stringWithFormat:@"Detail%d", indexPath.row];
		
	cell.textLabel.text = [[[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:sectionId] objectForKey:typeId] valueForKey:detailId];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Record
	finalDetailId = indexPath.row;
	
	// Check second detail
	// Open plist
	NSString *path = [[NSBundle mainBundle] pathForResource:@"reportSecondDetails" ofType:@"plist"];
	NSString *sectionId = [NSString stringWithFormat:@"Section%d", finalSectionId];
	NSString *typeId = [NSString stringWithFormat:@"Type%d", finalTypeId];
	NSString *detailId = [NSString stringWithFormat:@"Detail%d", indexPath.row];

	// Title
	// Open the plist
	NSString *titlePath=[[NSBundle mainBundle] pathForResource:@"reportDetails" ofType:@"plist"];
	NSString *selectedTitle = [[[[NSDictionary dictionaryWithContentsOfFile:titlePath] objectForKey:sectionId] objectForKey:typeId] valueForKey:detailId];
	
	if ([[[[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:sectionId] objectForKey:typeId] objectForKey:detailId] count]) {
		// Navigation logic may go here. Create and push another view controller.
		secondDetailViewController *secondDetail = [[secondDetailViewController alloc] initWithNibName:@"secondDetailViewController" bundle:nil];
		
		secondDetail.finalSectionId = finalSectionId;
		secondDetail.finalTypeId = finalTypeId;
		secondDetail.finalDetailId = finalDetailId;
		secondDetail.title = selectedTitle;
		secondDetail.delegate = self.delegate;
		
		// Pass the selected object to the new view controller.
		[self pushViewController:secondDetail animated:YES];
		[secondDetail release];
	} else {
		// Generate qid
		// Merge names
		NSString *path = [[NSBundle mainBundle] pathForResource:@"reportQid" ofType:@"plist"];
		NSString *sectionId = [NSString stringWithFormat:@"Section%d", finalSectionId];
		NSString *typeId = [NSString stringWithFormat:@"Type%d", finalTypeId];
		NSString *detailId = [NSString stringWithFormat:@"Detail%d", finalDetailId];
		// Open the qid plist
		NSInteger qid = [[[[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:sectionId] objectForKey:typeId] valueForKey:detailId] intValue];
		
		// Switch back
		[delegate typeSelectorDidSelectWithTitle:selectedTitle andQid:qid];
	}
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
