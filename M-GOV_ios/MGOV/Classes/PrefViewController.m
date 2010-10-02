//
//  PrefViewController.m
//  MGOV
//
//  Created by sodas on 2010/10/2.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "PrefViewController.h"


@implementation PrefViewController

@synthesize dictUserInformation;

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
		if (kDevelopPreview) return [NSString stringWithFormat:@"路見不平 %@\n%@ Develop Preview %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"], kStableReleaseVersion, kDevelopPreviewVersion];
		else if (kBetaRelease) return [NSString stringWithFormat:@"路見不平 %@\n%@ Beta Release %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"], kStableReleaseVersion, kBetaReleaseVersion];
		else if (kStableRelease) return [NSString stringWithFormat:@"路見不平 %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
		else return nil;
	else return nil;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier1 = @"DefaultCell";
	static NSString *CellIdentifier2 = @"Value2Cell";
    
	UITableViewCell *cell;
	if (indexPath.section==0) 
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
	else 
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];

    if (cell == nil) {
		if (indexPath.section==0) 
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier2] autorelease];
		else 
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
    }
	
	if (indexPath.section==0) {
		cell.textLabel.text = @"E-Mail";
		cell.detailTextLabel.text = [dictUserInformation valueForKey:@"User Email"];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
	NSString *plistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"UserInformation.plist"];
	self.dictUserInformation = [NSDictionary dictionaryWithContentsOfFile:plistPathInAppDocuments];
}

- (void)viewDidUnload {
}

- (void)dealloc {
    [super dealloc];
}

@end

