//
//  CaseViewerViewController.m
//  MGOV
//
//  Created by sodas on 2010/9/2.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "CaseViewerViewController.h"


@implementation CaseViewerViewController

@synthesize caseData;

#pragma mark -
#pragma mark CaseViewerViewController Method

- (id)initWithCaseID:(NSString *)cid {
	if ([self initWithStyle:UITableViewStyleGrouped]) {
		caseID = cid;
	}
	return self;
}

#pragma mark -
#pragma mark QueryGAEReciever

- (void)recieveQueryResultType:(DataSourceGAEReturnTypes)type withResult:(id)result {
	if (type == DataSourceGAEReturnByNSDictionary) {
		self.caseData = result;
	}
	CLLocationCoordinate2D coordinate;
	coordinate.longitude = [[[caseData objectForKey:@"coordinates"] objectAtIndex:0] doubleValue];
	coordinate.latitude = [[[caseData objectForKey:@"coordinates"] objectAtIndex:1] doubleValue];
	locationCell = [[LocationSelectorTableCell alloc] initWithHeight:200 andCoordinate:coordinate actionTarget:nil setAction:nil];
	NSString *str = [[caseData objectForKey:@"image"] objectAtIndex:0];
	str = [str stringByReplacingOccurrencesOfString:@"GET_SHOW_PHOTO.CFM?photo_filename=" withString:@"photo/"];
	photoView = [[UIImageView alloc] initWithImage:[[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]] fitToSize:CGSizeMake(300, 200)]];
	photoView.layer.cornerRadius = 10.0;
	photoView.layer.masksToBounds = YES;
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"案件資料";
	
	QueryGoogleAppEngine *qGAE = [QueryGoogleAppEngine requestQuery];
	qGAE.conditionType = DataSourceGAEQueryByID;
	qGAE.queryCondition = caseID;
	qGAE.indicatorTargetView = self.navigationController.view;
	qGAE.resultTarget = self;
	[qGAE startQuery];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) return 3;
	else if (section == 1) return 2;
	else if (section == 2 || section == 3) return 1;
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
	if (indexPath.section == 2) return 200; // Photo
	else if (indexPath.section == 3) return 200; // Location
	
	return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section==0) return @"基本資料";
	else if (section == 1) return @"案件種類與描述";
	else if (section == 2) return @"案件照片";
	else if(section == 3) return @"案件地點";
	
	return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
	if (!caseData) {
		UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
		return cell;
	}

	if (indexPath.section == 3) return locationCell;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		if (indexPath.section == 0) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			if (indexPath.row == 0) {
				cell.textLabel.text = @"案件編號";
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [caseData objectForKey:@"key"]];				

			} else if (indexPath.row ==1) {
				cell.textLabel.text = @"報案日期";
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [caseData objectForKey:@"date"]];
			} else {
				cell.textLabel.text = @"處理狀態";
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [caseData objectForKey:@"status"]];
			}

		} else if (indexPath.section == 1) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			if (indexPath.row == 0) {
				// Fetch type from plist
				NSString *caseType = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"QidToType" ofType:@"plist"]] valueForKey:[caseData objectForKey:@"typeid"]];
				
				cell.textLabel.text = @"案件種類";
				cell.detailTextLabel.text = caseType;
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
	[photoView release];
    [super dealloc];
}

@end
