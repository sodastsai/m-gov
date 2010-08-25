//
//  CaseAddViewController.m
//  MGOV
//
//  Created by Shou on 2010/8/25.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "CaseAddViewController.h"

#define kTextFieldHeight 30.0
#define kTextFieldWidth 290.0

@implementation CaseAddViewController

#pragma mark -
#pragma mark CaseAddMethod

- (BOOL) submitCase {
	
	[self.navigationController popViewControllerAnimated:YES];
	return YES;
	
}

- (void)action:(id)sender
{
	NSLog(@"UIButton was clicked");
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"報案";
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"送出" style:UIBarButtonItemStylePlain target:self action:@selector(submitCase)];
	self.navigationItem.rightBarButtonItem = submitButton;
	[submitButton release];
	
	
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
    if (!section) {
		return 2;
	}
	return 1;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0) {
		return @"照片及地址";
	}
	//else if (section == 1 ){
	//	return @"案件種類";
	//}
	else if (section == 2 ){
		return @"報案者姓名";
	}
	else if (section == 3 ){
		return @"描述及建議";
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	
    if (indexPath.section == 0) {
		return 100;
	}
	else if (indexPath.section == 1 ){
		return 45;
	}
	else if (indexPath.section == 2 ){
		return 40;
	}
	else if (indexPath.section == 3 ){
		return 190;
	}
	return 40;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = nil;
	
	if (indexPath.row == 0) {
		static NSString *Cell1Identifier = @"Cell1";
		cell = [tableView dequeueReusableCellWithIdentifier:Cell1Identifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell1Identifier] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		if (indexPath.section == 0) {
			
		}
		else if (indexPath.section == 1) {
			cell.textLabel.text = @"案件種類";
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		else if (indexPath.section == 2) {
			UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(8.0, 8.0, kTextFieldWidth, kTextFieldHeight)];
			nameField.placeholder = @"請輸入您的姓名";
			//nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
			nameField.autocorrectionType = UITextAutocorrectionTypeNo;
			[cell.contentView addSubview:nameField];
			[nameField release];
		}
		else {
			
			/*UITextField *descriptionField = [[UITextField alloc] initWithFrame:CGRectMake(8.0, 8.0, kTextFieldWidth, kTextFieldHeight*5)];
			//descriptionField.placeholder = @"描述及建議";
			descriptionField.clearButtonMode = UITextFieldViewModeWhileEditing;
			descriptionField.autocorrectionType = UITextAutocorrectionTypeNo;
			[cell.contentView addSubview:descriptionField];
			[descriptionField release];*/
			
			UITextView *descriptionField = [[UITextView alloc] initWithFrame:CGRectMake(8.0, 8.0, kTextFieldWidth, 180)];
			descriptionField.font = [UIFont systemFontOfSize:18.0];
			//descriptionField.text = @"請描述案件情況";
			[cell.contentView addSubview:descriptionField];
			[descriptionField release];
		}

	}
	else {
		static NSString *Cell2Identifier = @"Cell2";
		cell = [tableView dequeueReusableCellWithIdentifier:Cell2Identifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell2Identifier] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		
		
	}
	
	return cell;
}


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
    [super dealloc];
	// Test
}


@end

