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

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Open plist - First class
	NSString *path = [[NSBundle mainBundle] pathForResource:@"reportDetails" ofType:@"plist"];
	NSDictionary *sectionDict = [NSDictionary dictionaryWithContentsOfFile:path];
	// Open Dictionary - Second class
	NSString *sectionId = [NSString stringWithFormat:@"Section%d", finalSectionId];
	NSDictionary *typeDict = [sectionDict objectForKey:sectionId];
	// Open Dictionary - Third class
	NSString *typeId = [NSString stringWithFormat:@"Type%d", finalTypeId];
	NSDictionary *detailDict = [typeDict objectForKey:typeId];

    return [detailDict count];
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
	NSString *path = [[NSBundle mainBundle] pathForResource:@"reportDetails" ofType:@"plist"];
	NSDictionary *sectionDict = [NSDictionary dictionaryWithContentsOfFile:path];
	// Open Dictionary - Second class
	NSString *sectionId = [NSString stringWithFormat:@"Section%d", finalSectionId];
	NSDictionary *typeDict = [sectionDict objectForKey:sectionId];
	// Open Dictionary - Third class
	NSString *typeId = [NSString stringWithFormat:@"Type%d", finalTypeId];
	NSDictionary *detailDict = [typeDict objectForKey:typeId];
	
	NSString *detailId = [NSString stringWithFormat:@"Detail%d", indexPath.row];
	cell.textLabel.text = [detailDict valueForKey:detailId];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Record
	finalDetailId = indexPath.row;
	
	// Check second detail
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
	NSString *detailId = [NSString stringWithFormat:@"Detail%d", indexPath.row];
	NSDictionary *secondDetailDict = [detailDict objectForKey:detailId];

	// Title
	// Open the plist - First class
	NSString *titlePath=[[NSBundle mainBundle] pathForResource:@"reportDetails" ofType:@"plist"];
	NSDictionary *titleSectionDict=[NSDictionary dictionaryWithContentsOfFile:titlePath];
	// Open the plist - Second class
	NSDictionary *titleTypeDict = [titleSectionDict objectForKey:sectionId];
	// Open the plist - Third class
	NSDictionary *titleDetailDict = [titleTypeDict objectForKey:typeId];
	NSString *selectedTitle = [titleDetailDict valueForKey:detailId];
	
	if ([secondDetailDict count]) {
		// Navigation logic may go here. Create and push another view controller.
		secondDetailViewController *secondDetail = [[secondDetailViewController alloc] initWithNibName:@"secondDetailViewController" bundle:nil];
		
		secondDetail.finalSectionId = finalSectionId;
		secondDetail.finalTypeId = finalTypeId;
		secondDetail.finalDetailId = finalDetailId;
		
		secondDetail.title = selectedTitle;
		
		// Pass the selected object to the new view controller.
		[self.navigationController pushViewController:secondDetail animated:YES];
		[secondDetail release];
	} else {
		// Generate qid
		// Merge names
		NSString *path = [[NSBundle mainBundle] pathForResource:@"reportQid" ofType:@"plist"];
		NSString *sectionId = [NSString stringWithFormat:@"Section%d", finalSectionId];
		NSString *typeId = [NSString stringWithFormat:@"Type%d", finalTypeId];
		NSString *detailId = [NSString stringWithFormat:@"Detail%d", finalDetailId];
		// Open the qid plist
		NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
		NSDictionary *sectionDict = [dict objectForKey:sectionId];
		NSDictionary *typeDict = [sectionDict objectForKey:typeId];
		
		NSString *qid = [typeDict valueForKey:detailId];
		
		// Write to plist
		NSString *typeSelectorStatusPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"TypeSelectorStatus.plist"];
		NSMutableDictionary *plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:typeSelectorStatusPlistPathInAppDocuments];
		[plistDict setValue:selectedTitle forKey:@"submitContent"];
		[plistDict setValue:qid forKey:@"submitQid"];
		[plistDict setValue:@"1" forKey:@"submitReadable"];
		[plistDict writeToFile:typeSelectorStatusPlistPathInAppDocuments atomically:YES];
		
		[self dismissModalViewControllerAnimated:YES];
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
