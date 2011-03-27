/*
 * 
 * CaseViewerViewController.h
 * 2010/9/2
 * sodas
 * 
 * The main layout of Case Viewer which shows detail info of a case
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

#import "CaseViewerViewController.h"

@implementation CaseViewerViewController

@synthesize caseData;
@synthesize query_caseID;
@synthesize resetFlag;

#pragma mark -
#pragma mark Query

- (void)startToQueryCase {
	if (query_caseID==nil) return;
	shouldAppear = NO;
	resetFlag = NO;
	QueryGoogleAppEngine *qGAE = [QueryGoogleAppEngine requestQuery];
	qGAE.conditionType = DataSourceGAEQueryByID;
	qGAE.queryCondition = query_caseID;
	qGAE.indicatorTargetView = self.navigationController.view;
	qGAE.resultTarget = self;
	[qGAE startQuery];
}

- (void)cleanTableView {

	resetFlag = YES;
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark QueryGAEReciever

- (void)recieveQueryResultType:(DataSourceGAEReturnTypes)type withResult:(id)result {
	if (type == DataSourceGAEReturnByNSDictionary)
		self.caseData = result;
	
	CLLocationCoordinate2D coordinate;
	coordinate.longitude = [[[caseData objectForKey:@"coordinates"] objectAtIndex:0] doubleValue];
	coordinate.latitude = [[[caseData objectForKey:@"coordinates"] objectAtIndex:1] doubleValue];
	if (locationCell==nil) locationCell = [[LocationSelectorTableCell alloc] initWithHeight:200 andCoordinate:coordinate actionTarget:nil setAction:nil];
	else [locationCell updatingCoordinate:coordinate];
    
    //if did receive FB response
    if (fbCommentCell==nil)
        fbCommentCell = [[FBCommentTableCell alloc] initWithLike:@"4" andComment:@"1"];
    //
	
	if ([[caseData objectForKey:@"image"] count]>0) {
		NSString *str = [[caseData objectForKey:@"image"] objectAtIndex:0];
		str = [str stringByReplacingOccurrencesOfString:@"GET_SHOW_PHOTO.CFM?photo_filename=" withString:@"photo/"];
        //NSLog(@"photo string:%@", str);

		// Could not fetch the photo
        NSData *imageData = nil;
		
        ASIHTTPRequest *imgRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
		[imgRequest startSynchronous];
		if (![imgRequest error]){
			imageData = [imgRequest responseData];
        }
		
		if (!imageData)
			photoView = nil;
		else {
            //NSLog(@"image size:%u", [imageData length]);
			photoView = [[UIImageView alloc] initWithImage:[[UIImage imageWithData:imageData] fitToSize:CGSizeMake(300, 200)]];
			photoView.layer.cornerRadius = 10.0;
			photoView.layer.masksToBounds = YES;	
		}
	} else {
		photoView = nil;
	}
	
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Update the child cell of facebook cell

- (void)updateFBData {
    if (shouldAppear){
        shouldAppear = NO;
    }
    else {
        shouldAppear = YES;
    }
    //NSArray *toBeAdd = [NSArray arrayWithObjects:@"la", @"bkj2", nil];
    
    //[self.tableView beginUpdates];
    //[self.tableView reloadRowsAtIndexPaths:toBeAdd withRowAnimation:UITableViewRowAnimationFade];
    //[self.tableView endUpdates];
    //[self.tableView beginUpdates];
    //[self.tableView insertRowsAtIndexPaths:toBeAdd withRowAnimation:UITableViewRowAnimationFade];
    //[self.tableView endUpdates];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"案件資料";
    shouldAppear = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
	[self cleanTableView];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) return 3;
	else if (section == 1) return 2;
	else if (section == 3 || section == 4) return 1;
    else if (section == 2) {
        if (shouldAppear)
            return 3;
        else
            return 1;
    }
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
	if (indexPath.section == 2) {
        if (shouldAppear){
            if (indexPath.row==0)   return 30;
            else    return 50;
        }
        else{
            return 30;
        }
    }
    if (indexPath.section == 3) {
		if (photoView) return 200; // Photo
		return 0;
	}
	else if (indexPath.section == 4) return 200; // Location
	
	return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section==0) return @"基本資料";
	else if (section == 1) return @"案件種類與描述";
    else if (section == 2) return @"塗鴉牆";
	else if (section == 3) return @"案件照片";
	else if (section == 4) return @"案件地點";
	
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (photoView == nil && section == 3) return 200;
	if (section == 4) return 44;
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if (section == 4) return [caseData valueForKey:@"address"];
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	
	if (photoView == nil && section == 3) {
		UIView *emptyPhoto = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)] autorelease];
		emptyPhoto.backgroundColor = [UIColor clearColor];
		// Text Label
		UILabel *emptyPhotoHint = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
		emptyPhotoHint.backgroundColor = [UIColor clearColor];
		emptyPhotoHint.text = @"此案件無照片！";
		emptyPhotoHint.textAlignment = UITextAlignmentCenter;
		emptyPhotoHint.textColor = [UIColor colorWithRed:0.298 green:0.337 blue:0.424 alpha:1];
		
		[emptyPhoto addSubview:emptyPhotoHint];
		[emptyPhotoHint release];
		return emptyPhoto;
	} else return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"%@", indexPath);
	
    static NSString *CellIdentifier1 = @"EmptyCell";
    static NSString *CellIdentifier2 = @"NormalCell";
    static NSString *CellIdentifier3 = @"FBdataCell";
	static NSString *CellIdentifier4 = @"casePhotoCell";
    
	if (!caseData) {
		UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier1] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;
	}
    if (indexPath.section == 0 || indexPath.section == 1) {//|| indexPath.section == 3) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier2] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		/*
		else {
			//cell.backgroundView = ;
			cell.textLabel.text = @"";
			cell.detailTextLabel.text = @"";
		}
		 */

		if (indexPath.section==0) {
			if (indexPath.row == 0) {
				cell.textLabel.text = @"案件編號";
				if(!resetFlag) cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [caseData objectForKey:@"key"]];				
				else cell.detailTextLabel.text = @"";
			} else if (indexPath.row ==1) {
				cell.textLabel.text = @"報案日期";
				if(!resetFlag) cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [caseData objectForKey:@"date"]];
				else cell.detailTextLabel.text = @"";
			} else {
				cell.textLabel.text = @"處理狀態";
				if(!resetFlag) cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [caseData objectForKey:@"status"]];
				else cell.detailTextLabel.text = @"";
			}
		} else if (indexPath.section==1) {
			if (indexPath.row == 0) {
				// Fetch type from plist
				NSString *caseType = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"QidToType" ofType:@"plist"]] valueForKey:[caseData objectForKey:@"typeid"]];
				cell.textLabel.text = @"案件種類";
				if(!resetFlag) cell.detailTextLabel.text = caseType;
				else cell.detailTextLabel.text = @"";
			} else {
				cell.textLabel.text = @"案件描述";
				if(!resetFlag) cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [caseData objectForKey:@"detail"]];
				else cell.detailTextLabel.text = @"";
				cell.detailTextLabel.numberOfLines = 1;
				cell.detailTextLabel.minimumFontSize = 12.0;
				cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
			}
		} /*else if (indexPath.section==3) {
			if(!resetFlag) cell.backgroundView = photoView;
			else cell.backgroundView = nil;
		}
		   */
		return cell;
	}
    
    if (indexPath.section == 2) {
        if(indexPath.row == 0)
            return fbCommentCell;
        else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier3] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }
    }
	if (indexPath.section==3) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier4] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		
		if(!resetFlag) cell.backgroundView = photoView;
		else cell.backgroundView = nil;
		
		return cell;
	}
	
	if (indexPath.section == 4) return locationCell;
	
	return nil;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==2 && indexPath.row==0) {
        [self updateFBData];
    }
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[photoView release];
	[locationCell release];
    [fbCommentCell release];
	[caseData release];
    [super dealloc];
}

@end
