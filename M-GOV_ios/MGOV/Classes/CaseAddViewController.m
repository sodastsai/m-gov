//
//  CaseAddViewController.m
//  MGOV
//
//  Created by Shou on 2010/8/25.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "CaseAddViewController.h"
#import "AppMKAnnotation.h"

#pragma mark Basic constants

@implementation CaseAddViewController

#pragma mark -
#pragma mark Synthesize

@synthesize selectedTypeTitle;
@synthesize qid;

#pragma mark -
#pragma mark CaseAddMethod

- (BOOL)submitCase {
	
	// If this is the First time to Submit, We should ask user's email.
	// Check plist
	NSString *plistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"UserInformation.plist"];
	NSMutableDictionary *dictUserInformation = [NSMutableDictionary dictionaryWithContentsOfFile:plistPathInAppDocuments];
	
	if (![[dictUserInformation valueForKey:@"User Email"] length]) {
		alertEmailPopupBox = [[UIAlertView alloc] initWithTitle:alertRequestEmailTitle message:alertRequestEmailPlaceholder delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
		// Email Text Field
		alertEmailInputField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
		alertEmailInputField.delegate = self;
		alertEmailInputField.borderStyle = UITextBorderStyleRoundedRect;
		alertEmailInputField.keyboardType = UIKeyboardTypeEmailAddress;
		alertEmailInputField.returnKeyType = UIReturnKeyDone;
		alertEmailInputField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		alertEmailInputField.placeholder = alertRequestEmailPlaceholder;
		[alertEmailInputField becomeFirstResponder];
		// Show view
		[alertEmailPopupBox addSubview:alertEmailInputField];
		[alertEmailPopupBox show];
	}
	
	if ([[dictUserInformation valueForKey:@"User Email"] length]) {
		// Return to MyCase
		[self.navigationController popViewControllerAnimated:YES];
		return YES;
	}
	
	return NO;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	// The number has been discussed before.
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return @"照片及地址";
	} else if(section == 1) {
		return nil;
	} else if (section == 2 ){
		return @"案件種類";
	} else if (section == 3 ){
		return @"報案者姓名";
	} else if (section == 4 ){
		return @"描述及建議";
	}
	
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
	// Set the height according to the edit area size
    if (indexPath.section == 0) {
		return 250;
	} else if (indexPath.section == 1) {
		return 100;
	} else if (indexPath.section == 2 ){
		return 45;
	} else if (indexPath.section == 3 ){
		return 40;
	} else if (indexPath.section == 4 ){
		return 156;
	}
	
	return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// Read Custom Cell
	if (indexPath.section == 0) {
		return photoCell;
	} else if (indexPath.section == 1) {
		return locationCell;
	} else if (indexPath.section == 2) {
		// Do nothing since this is a normal cell.
	} else if (indexPath.section == 3) {
		return nameFieldCell;
	} else if (indexPath.section == 4) {
		return descriptionCell;
	}
	
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		// Default Cell Style
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	if (indexPath.section == 2) {
		if ([selectedTypeTitle length]) cell.textLabel.text = selectedTypeTitle;
		else cell.textLabel.text = @"請按此選擇案件種類";
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
		
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section==2 && indexPath.row==0) {
		typesViewController *typesView = [[typesViewController alloc] init];
		typesView.title = @"請選擇案件種類";
		UINavigationController *typeAndDetailSelector = [[UINavigationController alloc] initWithRootViewController:typesView];
		// Show the view
		typesView.delegate = self;
		[self presentModalViewController:typeAndDetailSelector animated:YES];
		// Add Back button
		UIBarButtonItem *backBuuton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:typesView.delegate action:@selector(leaveSelectorWithoutTitleAndQid)];
		typesView.navigationItem.leftBarButtonItem = backBuuton;
		[backBuuton release];
		[typesView release];
	}
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	// Get New photo
	selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	
	// Process for New photo
	if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
		// Scale
		if (selectedImage.size.width >= selectedImage.size.height) {
			selectedImage = [selectedImage scaleProportionlyToWidth:1024];
		} else {
			selectedImage = [selectedImage scaleProportionlyToHeight:1024];
		}
		// Save to Camera Roll
		UIImageWriteToSavedPhotosAlbum(selectedImage, self, nil, nil);
	}
	
	// Fit the Button
	[photoCell.photoButton setImage:[selectedImage fitToSize:CGSizeMake(300, 250)] forState:UIControlStateNormal];
	[photoCell.photoButton setTitle:@"" forState:UIControlStateNormal];		
	
	// Close Picker and Reload Data
	[picker dismissModalViewControllerAnimated:YES];
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	// End editing
	if (textField.placeholder == alertRequestEmailPlaceholder) {
		// Call pre-close method
		[self alertView:alertEmailPopupBox clickedButtonAtIndex:1];
		alertEmailPopupBox.message = textField.text;
		// close the alert
		[alertEmailPopupBox dismissWithClickedButtonIndex:0 animated:YES];
		[self submitCase];
		return NO;
	}
	return YES;
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([alertView.title isEqualToString:alertRequestEmailTitle]) {
		if (buttonIndex) {
			if ([alertEmailInputField.text length]) {
				// Write email to plist
				NSString *plistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"UserInformation.plist"];
				NSMutableDictionary *dictUserInformation = [NSMutableDictionary dictionaryWithContentsOfFile:plistPathInAppDocuments];
				[dictUserInformation setValue:alertEmailInputField.text forKey:@"User Email"];
				// Write to File
				[dictUserInformation writeToFile:plistPathInAppDocuments atomically:YES];
				[self submitCase];
			} else {
				UIAlertView *emptyEmail = [[UIAlertView alloc] initWithTitle:@"E-Mail為必填項目" message:@"請輸入您的E-Mail，否則無法報案！" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
				[emptyEmail show];
				[emptyEmail release];
			}
		} else {
			// User does not enter his email. Close the Alert
		}
		// Maintain the responder chain
		[alertEmailInputField removeFromSuperview];
	}
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	
	if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
		if (buttonIndex == 0) {
			picker.sourceType = UIImagePickerControllerSourceTypeCamera;
			[self presentModalViewController:picker animated:YES];
		} else if ( buttonIndex == 1 ){
			picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			[self presentModalViewController:picker animated:YES];
		}
	} else {
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[self presentModalViewController:picker animated:YES];
	}
	
	[picker release];	
}

#pragma mark -
#pragma mark PhotoPickerTableCellDelegate

- (void)openPhotoDialogAction {
	UIActionSheet *actionSheet;
	if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
		actionSheet = [[UIActionSheet alloc] initWithTitle:@"請選擇照片來源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍攝新的照片", @"選擇現有的照片", nil];
		actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
		// Cannot use [actionSheet showInView:self.view]! This will be affected by the UITabBar 
		[actionSheet showInView:self.parentViewController.tabBarController.view];
	} else {
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"請選擇照片來源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"選擇現有的照片", nil];
		actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
		// Cannot use [actionSheet showInView:self.view]! This will be affected by the UITabBar 
		[actionSheet showInView:self.parentViewController.tabBarController.view];
	}
	[actionSheet release];
}

#pragma mark -
#pragma mark LocationSelectorTableCellDelegate

- (void)openLocationSelector {
	LocationSelectorViewController *locationSelector = [[LocationSelectorViewController alloc] initWithCoordinate:selectedCoord];
	locationSelector.delegate = self;
	[self presentModalViewController:locationSelector animated:YES];
	[locationSelector release];
}

#pragma mark -
#pragma mark LocationSelectorViewControllerDelegate

- (void)userDidSelectCancel {
	// Do nothing
	// Dismiss the view
	[self dismissModalViewControllerAnimated:YES];
}

- (void)userDidSelectDone:(CLLocationCoordinate2D)coordinate {
	// Dismiss the view
	[locationCell updatingCoordinate:coordinate];
	// Set Geo information
	selectedCoord = coordinate;
	[self.tableView reloadData];
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark typesViewControllerDelegate

- (void)typeSelectorDidSelectWithTitle:(NSString *)t andQid:(NSInteger)q {
	self.selectedTypeTitle = t;
	self.qid = q;
	// Dismiss the view
	[self dismissModalViewControllerAnimated:YES];
	// Reload tableview after selected
	[self.tableView reloadData];
}

- (void)leaveSelectorWithoutTitleAndQid {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Keyboard Toolbar

- (void)keyboardWillShow:(NSNotification *)note {
	// Add keyboard toolbar
	if ([nameFieldCell.nameField isFirstResponder] || [descriptionCell.descriptionField isFirstResponder]) {
		keyboard = [[[[[UIApplication sharedApplication] windows] objectAtIndex:1] subviews] objectAtIndex:0];
		[keyboard addSubview:keyboardToolbar];
	}
}

- (void)endEditingText {
	// Remove Toolbar From Keyboard
	[[[keyboard subviews] lastObject] removeFromSuperview];
	// Hide the keyboard
	[nameFieldCell.nameField resignFirstResponder];
	[descriptionCell.descriptionField resignFirstResponder];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"報案";
	
	UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"送出案件" style:UIBarButtonItemStylePlain target:self action:@selector(submitCase)];
	self.navigationItem.rightBarButtonItem = submitButton;
	[submitButton release];
	
	// Add Component
	photoCell = [[PhotoPickerTableCell alloc] init];
	photoCell.delegate = self;
	locationCell = [[LocationSelectorTableCell alloc] initWithHeight:100];
	locationCell.delegate = self;
	nameFieldCell = [[NameFieldTableCell alloc] init];
	descriptionCell = [[DescriptionTableCell alloc] init];
	
	selectedTypeTitle = @"";
	alertRequestEmailTitle = @"歡迎使用烏賊車";
	alertRequestEmailPlaceholder = @"請輸入您的E-Mail";
	
	// Set keyboard bar
	// Prepare Keyboard
	keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, -44, 320, 44)];
	keyboardToolbar.barStyle = UIBarStyleBlack;
	keyboardToolbar.translucent = YES;
	
	// Prepare Buttons
	UIBarButtonItem *doneEditing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(endEditingText)];
	UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	// Prepare Labels
	UILabel *optionalHint = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, 250, 16)];
	optionalHint.text = @"本欄為選項性欄位，可不填";
	optionalHint.backgroundColor = [UIColor clearColor];
	optionalHint.textColor = [UIColor whiteColor];
	optionalHint.font = [UIFont boldSystemFontOfSize:16.0];
	[keyboardToolbar addSubview:optionalHint];
	
	// Add buttons to keyboard
	[keyboardToolbar setItems:[NSArray arrayWithObjects:flexibleItem, doneEditing, nil] animated:YES];
	[flexibleItem release];
	[optionalHint release];
	
	MGOVGeocoder *shared = [MGOVGeocoder sharedVariable];
	selectedCoord = shared.locationManager.location.coordinate;
	shared = nil;
	[shared release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	// Modify Keyboard
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	// Stop monitor keyboard
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[selectedTypeTitle release];
	[photoCell release];
	[locationCell release];
	[nameFieldCell release];
	[descriptionCell release];
    [super dealloc];
}

@end

