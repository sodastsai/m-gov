//
//  CaseAddViewController.m
//  MGOV
//
//  Created by Shou on 2010/8/25.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "CaseAddViewController.h"
#import "AppMKAnnotation.h"

@implementation CaseAddViewController

@synthesize selectedTypeTitle;
@synthesize qid;
@synthesize delegate;
@synthesize selectedImage;

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
		
		indicatorView = [[LoadingOverlayView alloc] initAtViewCenter:self.view];
		[self.view addSubview:indicatorView];
		indicatorView.loading.text = @"正在送出...";
		[indicatorView startedLoad];
		
		NSString *tempPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"CaseAddTempInformation.plist"];
		NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:tempPlistPathInAppDocuments];
		
		// Convert Byte Data to Photo From Plist
		NSString *filename = [NSString stringWithFormat:@"%@-%d.png", [dictUserInformation valueForKey:@"User Email"], [[NSDate date] timeIntervalSince1970]];
		
		// Post the submt data to App Engine
		ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://ntu-ecoliving.appspot.com/case?method=upload"]];
		request.delegate = self;
		[request setFile:[dict objectForKey:@"Photo"] withFileName:filename andContentType:@"image/png" forKey:@"photo"];
		[request setPostValue:[[MGOVGeocoder returnRegion:selectedCoord]objectAtIndex:0] forKey:@"h_admit_name"];
		[request setPostValue:[[MGOVGeocoder returnRegion:selectedCoord]objectAtIndex:1] forKey:@"h_admiv_name"];
		[request setPostValue:[NSString stringWithFormat:@"%d", qid] forKey:@"typeid"];
		[request setPostValue:descriptionCell.descriptionField.text forKey:@"h_summary"];
		[request setPostValue:[dictUserInformation valueForKey:@"User Email"] forKey:@"email"];
		[request setPostValue:[NSString stringWithFormat:@"%f", selectedCoord.longitude] forKey:@"coordx"];
		[request setPostValue:[NSString stringWithFormat:@"%f", selectedCoord.latitude] forKey:@"coordy"];
		[request startAsynchronous];
		
		// After submit case, clean the temp infomation
		[dict setObject:[NSData data] forKey:@"Photo"];
		[dict setObject:[NSNumber numberWithDouble:0.0] forKey:@"Latitude"];
		[dict setObject:[NSNumber numberWithDouble:0.0] forKey:@"Longitude"];
		[dict setValue:@"" forKey:@"Name"];
		[dict setValue:@"" forKey:@"Description"];
		descriptionCell.descriptionField.text = @"";
		nameFieldCell.nameField.text = @"";
		[dict setValue:@"" forKey:@"TypeTitle"];
		[dict setObject:[NSNumber numberWithInt:0] forKey:@"TypeID"];
		[dict writeToFile:tempPlistPathInAppDocuments atomically:YES];
		
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
		return [PhotoPickerTableCell cellHeight];
	} else if (indexPath.section == 1) {
		return 100;
	} else if (indexPath.section == 2 ){
		return 44;
	} else if (indexPath.section == 3 ){
		return [NameFieldTableCell cellHeight];
	} else if (indexPath.section == 4 ){
		return [DescriptionTableCell cellHeight];
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
#pragma mark ASIHTTPRequest

- (void)requestFinished:(ASIHTTPRequest *)request {
	[indicatorView finishedLoad];
	[indicatorView removeFromSuperview];
	[indicatorView release];
	[self.navigationController popViewControllerAnimated:YES];
	[delegate refreshData];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	[indicatorView finishedLoad];
	[indicatorView removeFromSuperview];
	[indicatorView release];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section==2 && indexPath.row==0) {
		typesViewController *typesView = [[typesViewController alloc] init];
		UINavigationController *typeAndDetailSelector = [[UINavigationController alloc] initWithRootViewController:typesView];
		// Show the view
		typesView.delegate = self;
		[self presentModalViewController:typeAndDetailSelector animated:YES];
		[typesView release];
	}
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	// Get New photo
	// Use property for retain
	self.selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	// Scale
	if (selectedImage.size.width >= selectedImage.size.height) {
		selectedImage = [selectedImage scaleProportionlyToWidth:kPhotoScale];
	} else {
		selectedImage = [selectedImage scaleProportionlyToHeight:kPhotoScale];
	}	
	// Save to Camera Roll
	if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
		UIImageWriteToSavedPhotosAlbum(selectedImage, self, nil, nil);

	// Fit the Button
	[photoCell.photoButton setImage:[selectedImage fitToSize:CGSizeMake(300, [PhotoPickerTableCell cellHeight])] forState:UIControlStateNormal];
	[photoCell.photoButton setTitle:@"" forState:UIControlStateNormal];
	
	NSString *tempPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"CaseAddTempInformation.plist"];
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:tempPlistPathInAppDocuments];
	NSData *data = UIImagePNGRepresentation(selectedImage);
	[dict setObject:data forKey:@"Photo"];
	[dict writeToFile:tempPlistPathInAppDocuments atomically:YES];	
	
	// Close Picker,Reload Data, and Call Location Selector
	[picker dismissModalViewControllerAnimated:YES];
	[self.tableView reloadData];
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(openLocationSelector) userInfo:nil repeats:NO];
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
				NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z0-9.-]";
				NSRange r;
				r = [alertEmailInputField.text rangeOfString:emailRegex options:NSRegularExpressionSearch];
				if (r.location != NSNotFound) {
					// Write email to plist
					NSString *plistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"UserInformation.plist"];
					NSMutableDictionary *dictUserInformation = [NSMutableDictionary dictionaryWithContentsOfFile:plistPathInAppDocuments];
					[dictUserInformation setValue:alertEmailInputField.text forKey:@"User Email"];
					// Write to File
					[dictUserInformation writeToFile:plistPathInAppDocuments atomically:YES];
					[self submitCase];
				} else {
					UIAlertView *errorEmail = [[UIAlertView alloc] initWithTitle:@"E-Mail格式錯誤" message:@"請輸入正確的E-Mail！" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
					[errorEmail show];
					[errorEmail release];
				}
			} else {
				UIAlertView *emptyEmail = [[UIAlertView alloc] initWithTitle:@"E-Mail為必填項目" message:@"請輸入您的E-Mail，否則無法報案！" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
				[emptyEmail show];
				[emptyEmail release];
			}
		} else {
			// User does not enter his email. Close the Alert
		}
		// Maintain the responder chain
		[alertEmailInputField resignFirstResponder];
	}
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
		if (buttonIndex == 0) {
			UIImagePickerController *picker = [[UIImagePickerController alloc] init];
			picker.delegate = self;
			picker.sourceType = UIImagePickerControllerSourceTypeCamera;
			[self presentModalViewController:picker animated:YES];
			[picker release];
		} else if ( buttonIndex == 1 ) {
			UIImagePickerController *picker = [[UIImagePickerController alloc] init];
			picker.delegate = self;
			picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			[self presentModalViewController:picker animated:YES];
			[picker release];	
		}
	} else {
		if (buttonIndex == 0) {
			UIImagePickerController *picker = [[UIImagePickerController alloc] init];
			picker.delegate = self;
			picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			[self presentModalViewController:picker animated:YES];
			[picker release];
		}
	}
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
		actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
		// Cannot use [actionSheet showInView:self.view]! This will be affected by the UITabBar 
		[actionSheet showFromTabBar:self.parentViewController.tabBarController.tabBar];
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
	
	// Temporary store the coordinate selected by user to CaseAddTempInformation.plist
	NSString *tempPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"CaseAddTempInformation.plist"];
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:tempPlistPathInAppDocuments];
	[dict setObject:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"Longitude"];
	[dict setObject:[NSNumber numberWithDouble:coordinate.latitude] forKey:@"Latitude"];
	[dict writeToFile:tempPlistPathInAppDocuments atomically:YES];
	
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
	
	// Temporary store the typeid & typetitle info. to CaseAddTempInformation.plist
	NSString *tempPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"CaseAddTempInformation.plist"];
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:tempPlistPathInAppDocuments];
	[dict setObject:[NSNumber numberWithInt:q] forKey:@"TypeID"];
	[dict setValue:t forKey:@"TypeTitle"];
	[dict writeToFile:tempPlistPathInAppDocuments atomically:YES];
	
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
	MGOVGeocoder *shared = [MGOVGeocoder sharedVariable];
	locationCell = [[LocationSelectorTableCell alloc] initWithHeight:100 andCoordinate:shared.locationManager.location.coordinate actionTarget:self setAction:@selector(openLocationSelector)];
	locationCell.delegate = self;
	nameFieldCell = [[NameFieldTableCell alloc] init];
	nameFieldCell.nameField.delegate = self;
	descriptionCell = [[DescriptionTableCell alloc] init];
	
	selectedTypeTitle = @"";
	alertRequestEmailTitle = @"歡迎使用烏賊車";
	alertRequestEmailPlaceholder = @"請輸入您的E-Mail";
	selectedImage = nil;
	
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
	
	selectedCoord = shared.locationManager.location.coordinate;
	shared = nil;
	[shared release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	// Modify Keyboard
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
	
	// Fetch the data user key in last time
	NSString *tempPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"CaseAddTempInformation.plist"];
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:tempPlistPathInAppDocuments];
	UIImage *image = [UIImage imageWithData:[dict objectForKey:@"Photo"]];
	[photoCell.photoButton setImage:[image fitToSize:CGSizeMake(300, [PhotoPickerTableCell cellHeight])] forState:UIControlStateNormal];
	if (image != nil) {
		[photoCell.photoButton setTitle:@"" forState:UIControlStateNormal];
	}
	self.qid = [[dict objectForKey:@"TypeID"] intValue];
	self.selectedTypeTitle = [dict valueForKey:@"TypeTitle"];
	if ([[dict objectForKey:@"Latitude"] doubleValue]!=0 && [[dict objectForKey:@"Longitude"] doubleValue]!=0) {
		selectedCoord.latitude = [[dict objectForKey:@"Latitude"] doubleValue];
		selectedCoord.longitude = [[dict objectForKey:@"Longitude"] doubleValue];
		[locationCell updatingCoordinate:selectedCoord];
	}
	nameFieldCell.nameField.text = [dict valueForKey:@"Name"];
	[descriptionCell setPlaceholder:[dict valueForKey:@"Description"]];
	
	[self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	// Stop monitor keyboard
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	// Temporary store the name & description info. to CaseAddTempInformation.plist
	NSString *tempPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"CaseAddTempInformation.plist"];
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:tempPlistPathInAppDocuments];
	[dict setValue:nameFieldCell.nameField.text forKey:@"Name"];
	if (![descriptionCell.descriptionField.text isEqualToString:@"請輸入描述及建議"]) [dict setValue:descriptionCell.descriptionField.text forKey:@"Description"];
	[dict writeToFile:tempPlistPathInAppDocuments atomically:YES];	
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

