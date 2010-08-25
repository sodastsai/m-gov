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

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Open plist - First class
	NSString *path = [[NSBundle mainBundle] pathForResource:@"reportSecondDetails" ofType:@"plist"];
	NSDictionary *sectionDict = [NSDictionary dictionaryWithContentsOfFile:path];
	// Open Dictionary - Second class
	NSString *sectionId = [NSString stringWithFormat:@"Section%d", finalSectionId];
	NSDictionary *typeDict = [sectionDict objectForKey:sectionId];
	// Open Dictionary - Third class
	NSString *typeId = [NSString stringWithFormat:@"Type%d", finalTypeId];
	NSDictionary *detailDict = [typeDict objectForKey:typeId];
	// Open Dictionary - Fouth class
	NSString *detailId = [NSString stringWithFormat:@"Detail%d", finalDetailId];
	NSDictionary *secondDetailDict = [detailDict objectForKey:detailId];
	
    return [secondDetailDict count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    // Open plist - First class
	NSString *path = [[NSBundle mainBundle] pathForResource:@"reportSecondDetails" ofType:@"plist"];
	NSDictionary *sectionDict = [NSDictionary dictionaryWithContentsOfFile:path];
	// Open Dictionary - Second class
	NSString *sectionId = [NSString stringWithFormat:@"Section%d", finalSectionId];
	NSDictionary *typeDict = [sectionDict objectForKey:sectionId];
	// Open Dictionary - Third class
	NSString *typeId = [NSString stringWithFormat:@"Type%d", finalTypeId];
	NSDictionary *detailDict = [typeDict objectForKey:typeId];
	// Open Dictionary - Fouth class
	NSString *detailId = [NSString stringWithFormat:@"Detail%d", finalDetailId];
	NSDictionary *secondDetailDict = [detailDict objectForKey:detailId];
	
	NSString *secondDetailId = [NSString stringWithFormat:@"SecondDetail%d", indexPath.row];
	cell.textLabel.text = [secondDetailDict valueForKey:secondDetailId];
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
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
	NSDictionary *sectionDict = [dict objectForKey:sectionId];
	NSDictionary *typeDict = [sectionDict objectForKey:typeId];
	NSDictionary *detailDict = [typeDict objectForKey:detailId];
	NSString *qid = [detailDict valueForKey:secondDetailId];
	
	// Title
	NSString *finalSection = [NSString stringWithFormat:@"Section%d", finalSectionId];
	NSString *finalType = [NSString stringWithFormat:@"Type%d", finalTypeId];
	NSString *finalDetail = [NSString stringWithFormat:@"Detail%d", finalDetailId];
	// Open the plist - First class
	NSString *titlePath=[[NSBundle mainBundle] pathForResource:@"reportDetails" ofType:@"plist"];
	NSDictionary *titleSectionDict=[NSDictionary dictionaryWithContentsOfFile:titlePath];
	// Open the plist - Second class
	NSDictionary *titleTypeDict = [titleSectionDict objectForKey:finalSection];
	NSDictionary *titleDetailDict = [titleTypeDict objectForKey:finalType];
	NSString *selectedTitle = [titleDetailDict valueForKey:finalDetail];
	
	// Write to plist
	NSString *typeSelectorStatusPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"TypeSelectorStatus.plist"];
	NSMutableDictionary *plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:typeSelectorStatusPlistPathInAppDocuments];
	[plistDict setValue:selectedTitle forKey:@"submitContent"];
	[plistDict setValue:qid forKey:@"submitQid"];
	[plistDict setValue:@"1" forKey:@"submitReadable"];
	[plistDict writeToFile:typeSelectorStatusPlistPathInAppDocuments atomically:YES];
	
	// Switch back
	[self dismissModalViewControllerAnimated:YES];
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

