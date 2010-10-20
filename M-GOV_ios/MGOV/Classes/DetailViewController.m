//
//  DetailViewController.m
//  MGOV
//
//  Created by sodas on 2010/8/11.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "DetailViewController.h"
#import "SecondDetailViewController.h"

@implementation DetailViewController

@synthesize finalSectionId;
@synthesize finalTypeId;
@synthesize finalDetailId;
@synthesize delegate;

#pragma mark -
#pragma mark Lifecycle

- (void)viewDidLoad {
	NSString *path;
	
	// Detail
	path = [[NSBundle mainBundle] pathForResource:@"reportDetails" ofType:@"plist"];
	detailDict = [[NSDictionary alloc] initWithContentsOfFile:path];
	
	// Second Detail Dict
	path = [[NSBundle mainBundle] pathForResource:@"reportSecondDetails" ofType:@"plist"];
	secondDetailDict = [[NSDictionary alloc] initWithContentsOfFile:path];
	
	path = nil;
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

    return [[[detailDict objectForKey:sectionId] objectForKey:typeId] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Open plist
	NSString *sectionId = [NSString stringWithFormat:@"Section%d", finalSectionId];
	NSString *typeId = [NSString stringWithFormat:@"Type%d", finalTypeId];
	NSString *detailId = [NSString stringWithFormat:@"Detail%d", indexPath.row];
		
	cell.textLabel.text = [[[detailDict objectForKey:sectionId] objectForKey:typeId] valueForKey:detailId];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
	
	sectionId = nil;
	typeId = nil;
	detailId = nil;
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Record
	finalDetailId = indexPath.row;
	
	// Check second detail
	// Open plist
	NSString *sectionId = [NSString stringWithFormat:@"Section%d", finalSectionId];
	NSString *typeId = [NSString stringWithFormat:@"Type%d", finalTypeId];
	NSString *detailId = [NSString stringWithFormat:@"Detail%d", indexPath.row];

	// Title
	// Open the plist
	NSString *selectedTitle = [[[detailDict objectForKey:sectionId] objectForKey:typeId] valueForKey:detailId];
	
	if ([[[[secondDetailDict objectForKey:sectionId] objectForKey:typeId] objectForKey:detailId] count]) {
		// Navigation logic may go here. Create and push another view controller.
		SecondDetailViewController *secondDetail = [[SecondDetailViewController alloc] initWithNibName:@"SecondDetailViewController" bundle:nil];
		
		secondDetail.finalSectionId = finalSectionId;
		secondDetail.finalTypeId = finalTypeId;
		secondDetail.finalDetailId = finalDetailId;
		secondDetail.title = selectedTitle;
		secondDetail.delegate = self.delegate;
		
		// Pass the selected object to the new view controller.
		[self.navigationController pushViewController:secondDetail animated:YES];
		[secondDetail release];
	} else {
		// Generate qid
		// Merge names
		NSString *qidPath = [[NSBundle mainBundle] pathForResource:@"reportQid" ofType:@"plist"];
		NSString *sectionId = [NSString stringWithFormat:@"Section%d", finalSectionId];
		NSString *typeId = [NSString stringWithFormat:@"Type%d", finalTypeId];
		NSString *detailId = [NSString stringWithFormat:@"Detail%d", finalDetailId];
		// Open the qid plist
		NSInteger qid = [[[[[NSDictionary dictionaryWithContentsOfFile:qidPath] objectForKey:sectionId] objectForKey:typeId] valueForKey:detailId] intValue];
		
		// Switch back
		[delegate typeSelectorDidSelectWithTitle:selectedTitle andQid:qid];
		
		qidPath = nil;
		sectionId = nil;
		typeId = nil;
		detailId = nil;
	}
	
	sectionId = nil;
	typeId = nil;
	detailId = nil;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[detailDict release];
	[secondDetailDict release];
    [super dealloc];
}

@end
