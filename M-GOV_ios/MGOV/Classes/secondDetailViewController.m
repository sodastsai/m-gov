//
//  secondDetailViewController.m
//  MGOV
//
//  Created by sodas on 2010/8/11.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "secondDetailViewController.h"

@implementation secondDetailViewController

@synthesize finalSectionId;
@synthesize finalTypeId;
@synthesize finalDetailId;
@synthesize finalSecondDetailId;
@synthesize delegate;

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Open plist
	NSString *path = [[NSBundle mainBundle] pathForResource:@"reportSecondDetails" ofType:@"plist"];
	NSString *sectionId = [NSString stringWithFormat:@"Section%d", finalSectionId];
	NSString *typeId = [NSString stringWithFormat:@"Type%d", finalTypeId];
	NSString *detailId = [NSString stringWithFormat:@"Detail%d", finalDetailId];

    return [[[[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:sectionId] objectForKey:typeId] objectForKey:detailId] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
     // Open plist - First class
	NSString *path = [[NSBundle mainBundle] pathForResource:@"reportSecondDetails" ofType:@"plist"];
	NSString *sectionId = [NSString stringWithFormat:@"Section%d", finalSectionId];
	NSString *typeId = [NSString stringWithFormat:@"Type%d", finalTypeId];
	NSString *detailId = [NSString stringWithFormat:@"Detail%d", finalDetailId];
	NSString *secondDetailId = [NSString stringWithFormat:@"SecondDetail%d", indexPath.row];
		
	cell.textLabel.text = [[[[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:sectionId] objectForKey:typeId] objectForKey:detailId] valueForKey:secondDetailId];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	path = nil;
	sectionId = nil;
	typeId = nil;
	detailId = nil;
	secondDetailId = nil;
	
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
	NSString *titlePlistPath=[[NSBundle mainBundle] pathForResource:@"reportSecondDetails" ofType:@"plist"];
	NSString *finalSection = [NSString stringWithFormat:@"Section%d", finalSectionId];
	NSString *finalType = [NSString stringWithFormat:@"Type%d", finalTypeId];
	NSString *finalDetail = [NSString stringWithFormat:@"Detail%d", finalDetailId];
	NSString *finalSecondDetail = [NSString stringWithFormat:@"SecondDetail%d", finalSecondDetailId];
	
	NSString *selectedTitle = [[[[[NSDictionary dictionaryWithContentsOfFile:titlePlistPath] objectForKey:finalSection] objectForKey:finalType] objectForKey:finalDetail] valueForKey:finalSecondDetail];
	
	// Switch back
	[delegate typeSelectorDidSelectWithTitle:selectedTitle andQid:qid];
	
	path = nil;
	sectionId = nil;
	typeId = nil;
	detailId = nil;
	secondDetailId = nil;
	titlePlistPath = nil;
	finalSection = nil;
	finalType = nil;
	finalDetail = nil;
	finalSecondDetail = nil;
	selectedTitle = nil;
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

