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

- (id)initWithCaseID:(NSString *)caseID {
	if ([self initWithStyle:UITableViewStyleGrouped]) {
		ID = caseID;
	}
	return self;
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSString *str = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ntu-ecoliving.appspot.com/ecoliving/get_id/%@", ID]] encoding:NSUTF8StringEncoding error:nil];
	caseData = [[NSDictionary alloc] initWithDictionary:[str JSONValue]];
	str = [caseData objectForKey:@"coordinates"];
	locationCell = [[LocationSelectorTableCell alloc] initWithHeight:200 andCoordinate:[MGOVGeocoder convertCommaSeperatedCoordinate:str] actionTarget:nil setAction:nil];
	str = [caseData objectForKey:@"image"];
	str = [str stringByReplacingOccurrencesOfString:@"GET_SHOW_PHOTO.CFM?photo_filename=" withString:@"photo/"];
	photoView = [[UIImageView alloc] initWithImage:[[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]] fitToSize:CGSizeMake(300, 200)]];
	photoView.layer.cornerRadius = 10.0;
	photoView.layer.masksToBounds = YES;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of rows in the section.
	if (section == 0 || section == 1) {
		return 2;
	}
	else if (section == 2 || section == 3) {
		return 1;
	}
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
	// Set the height according to the edit area size
    if (indexPath.section == 2) {
		// Photo
		return 200;
	} else if (indexPath.section == 3) {
		// Location
		return 200;
	}
	return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 2) {
		return @"案件照片";
	} else if(section == 3) {
		return @"案件地點";
	}
	return nil;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 3) {
		return locationCell;
	}
    	
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
    
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[ID release];
	[caseData release];
	[locationCell release];
    [super dealloc];
}


@end

