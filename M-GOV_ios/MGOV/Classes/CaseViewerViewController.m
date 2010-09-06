//
//  CaseViewerViewController.m
//  MGOV
//
//  Created by sodas on 2010/9/2.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "CaseViewerViewController.h"


@implementation CaseViewerViewController

#pragma mark -
#pragma mark CaseViewerViewController Method

- (id)initWithCaseID:(NSString *)cid {
	if ([self initWithStyle:UITableViewStyleGrouped]) {
		caseID = cid;
	}
	return self;
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSString *str = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ntu-ecoliving.appspot.com/ecoliving/get_id/%@", caseID]] encoding:NSUTF8StringEncoding error:nil];
	caseData = [[NSDictionary alloc] initWithDictionary:[str JSONValue]];
	str = [caseData objectForKey:@"coordinates"];
	locationCell = [[LocationSelectorTableCell alloc] initWithHeight:200 andCoordinate:[MGOVGeocoder convertCommaSeperatedCoordinate:str] actionTarget:nil setAction:nil];
	str = [caseData objectForKey:@"image"];
	str = [str stringByReplacingOccurrencesOfString:@"GET_SHOW_PHOTO.CFM?photo_filename=" withString:@"photo/"];
	photoView = [[UIImageView alloc] initWithImage:[[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]] fitToSize:CGSizeMake(300, 200)]];
	photoView.layer.cornerRadius = 10.0;
	photoView.layer.masksToBounds = YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0 || section == 1) return 2;
	else if (section == 2 || section == 3) return 1;
	
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
	if (indexPath.section == 2) return 200; // Photo
	else if (indexPath.section == 3) return 200; // Location
	
	return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 2) return @"案件照片";
	else if(section == 3) return @"案件地點";
	
	return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 3) return locationCell;
    	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		if (indexPath.section == 0) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			if (indexPath.row == 0) {
				cell.textLabel.text = @"案件編號";
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [caseData objectForKey:@"key"]];
			} else {
				cell.textLabel.text = @"處理狀態";
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [caseData objectForKey:@"state"]];
			}
		} else if (indexPath.section == 1) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			if (indexPath.row == 0) {
				cell.textLabel.text = @"案件種類";
				cell.detailTextLabel.text = @"";
			} else {
				cell.textLabel.text = @"案件描述";
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [caseData objectForKey:@"detail"]];
			}

		} else if (indexPath.section == 2) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.backgroundView = photoView;
		}
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

- (void)viewDidUnload {
}

- (void)dealloc {
	[caseID release];
	[caseData release];
	[locationCell release];
    [super dealloc];
}

@end
