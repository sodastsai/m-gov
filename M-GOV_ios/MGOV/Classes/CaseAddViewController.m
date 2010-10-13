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
@synthesize qid, userName;
@synthesize selectedImage;
@synthesize myCase;

#pragma mark -
#pragma mark CaseAddMethod

- (void)submitCase {
	// If this is the First time to Submit, We should ask user's email.
	if (![[PrefAccess readPrefByKey:@"User Email"] length]) {
		alertEmailPopupBox = [[UIAlertView alloc] initWithTitle:@"請輸入您的E-Mail" message:[NSString stringWithFormat:@"路見不平會使用E-Mail記錄您的案件\n\n\n"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
		alertEmailPopupBox.tag = 3000;
		// Email Text Field
		alertEmailInputField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 75.0, 260.0, 30.0)];
		alertEmailInputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		alertEmailInputField.delegate = self;
		alertEmailInputField.borderStyle = UITextBorderStyleRoundedRect;
		alertEmailInputField.keyboardType = UIKeyboardTypeEmailAddress;
		alertEmailInputField.returnKeyType = UIReturnKeyDone;
		alertEmailInputField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		alertEmailInputField.placeholder = @"someone@example.com";
		[alertEmailInputField becomeFirstResponder];
		// Show view
		[alertEmailPopupBox addSubview:alertEmailInputField];
		[alertEmailPopupBox show];
		[alertEmailPopupBox release];
	} else if ([[PrefAccess readPrefByKey:@"User Email"] length] && qid != 0) {
		[PrefAccess writePrefByKey:@"NetworkIsAlerted" andObject:[NSNumber numberWithBool:NO]];
		if ([NetWorkChecking checkNetwork]) {
			UIAlertView *submitConfirm = [[UIAlertView alloc] initWithTitle:@"送出案件" message:@"確定要送出此案件至1999?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定", nil];
			submitConfirm.tag = 2000;
			[submitConfirm show];
			[submitConfirm release];
		}
	} else if (qid == 0){
		UIAlertView *typeSelect = [[UIAlertView alloc] initWithTitle:@"尚未選擇案件種類" message:@"案件種類為必填選項，請確認是否已選填！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
		typeSelect.tag = 4000;
		[typeSelect show];
		[typeSelect release];
	}
}

#pragma mark -
#pragma mark ASIHTTPRequest

- (void)requestFinished:(ASIHTTPRequest *)request {
	[indicatorView finishedLoad];
	[indicatorView removeFromSuperview];
	[indicatorView release];
	[myCase refreshDataSource];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	[indicatorView finishedLoad];
	[indicatorView removeFromSuperview];
	[indicatorView release];
	UIAlertView *uploadFailed = [[UIAlertView alloc] initWithTitle:@"資料上傳失敗" message:@"資料上傳失敗，請重新上傳！" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
	[uploadFailed show];
	[uploadFailed release];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 6;
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
	} else if (indexPath.section == 5 ){
		return 44;
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
	} else if (indexPath.section == 5) {
		// Do nothing since this is a normal cell.
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
	
	if (indexPath.section == 5) {
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.text = @"清除所有欄位";
	}
		
	return cell;
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
		[typeAndDetailSelector release];
		[typesView release];
	}
	if (indexPath.section==5 && indexPath.row==0) {
		UIAlertView *resetAlert = [[UIAlertView alloc] initWithTitle:@"確定要重設所有欄位？" message:@"此動作會清除所有欄位的資料" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定", nil];
		resetAlert.tag = 1000;
		[resetAlert show];
		[resetAlert release];
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
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:tempPlistPathInAppDocuments];
	NSData *data = UIImagePNGRepresentation(selectedImage);
	[dict setObject:data forKey:@"Photo"];
	[dict writeToFile:tempPlistPathInAppDocuments atomically:YES];
	[dict release];
	
	// Close Picker,Reload Data, and Call Location Selector
	[picker dismissModalViewControllerAnimated:YES];
	[self.tableView reloadData];
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(openLocationSelector) userInfo:nil repeats:NO];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	// End editing
	if (textField.superview.tag==3000) {
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
	if (alertView.tag==2000) {
		if (buttonIndex) {
			indicatorView = [[LoadingOverlayView alloc] initAtViewCenter:self.navigationController.view];
			[self.navigationController.view addSubview:indicatorView];
			indicatorView.loading.text = @"正在送出...";
			[indicatorView startedLoad];
			
			// If this is the First time to Submit, We should ask user's email.
			// Check plist
			NSString *tempPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"CaseAddTempInformation.plist"];
			NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:tempPlistPathInAppDocuments];
			
			// Convert Byte Data to Photo From Plist
			NSString *filename = [NSString stringWithFormat:@"%@-%d.png", [PrefAccess readPrefByKey:@"User Email"], [[NSDate date] timeIntervalSince1970]];
			
			// Post the submt data to App Engine
			ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://ntu-ecoliving.appspot.com/case/add?method=upload"]];
			request.delegate = self;
			[request setFile:[dict objectForKey:@"Photo"] withFileName:filename andContentType:@"image/png" forKey:@"photo"];
			[request setPostValue:[[MGOVGeocoder returnRegion:selectedCoord]objectAtIndex:0] forKey:@"h_admit_name"];
			[request setPostValue:[[MGOVGeocoder returnRegion:selectedCoord]objectAtIndex:1] forKey:@"h_admiv_name"];
			[request setPostValue:[NSString stringWithFormat:@"%d", qid] forKey:@"typeid"];
			[request setPostValue:descriptionCell.descriptionField.text forKey:@"h_summary"];
			[request setPostValue:[PrefAccess readPrefByKey:@"User Email"] forKey:@"email"];
			[request setPostValue:nameFieldCell.nameField.text forKey:@"name"];
			[request setPostValue:[NSString stringWithFormat:@"%f", selectedCoord.longitude] forKey:@"coordx"];
			[request setPostValue:[NSString stringWithFormat:@"%f", selectedCoord.latitude] forKey:@"coordy"];
			[request setPostValue:[MGOVGeocoder returnFullAddress:selectedCoord] forKey:@"address"];
			[request startAsynchronous];
			
			[PrefAccess writePrefByKey:@"Name" andObject:nameFieldCell.nameField.text];
			
			// After submit case, clean the temp infomation
			[dict setObject:[NSData data] forKey:@"Photo"];
			[dict setObject:[NSNumber numberWithDouble:0.0] forKey:@"Latitude"];
			[dict setObject:[NSNumber numberWithDouble:0.0] forKey:@"Longitude"];
			[dict setValue:@"" forKey:@"Description"];
			descriptionCell.descriptionField.text = @"";
			nameFieldCell.nameField.text = [PrefAccess readPrefByKey:@"Name"];
			[dict setValue:@"" forKey:@"TypeTitle"];
			[dict setObject:[NSNumber numberWithInt:0] forKey:@"TypeID"];
			[dict writeToFile:tempPlistPathInAppDocuments atomically:YES];
			[dict release];
			
		}
	}
	if (alertView.tag==1000) {
		if (buttonIndex) {
			NSString *tempPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"CaseAddTempInformation.plist"];
			NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:tempPlistPathInAppDocuments];

			[dict setObject:[NSData data] forKey:@"Photo"];
			[dict setObject:[NSNumber numberWithDouble:0.0] forKey:@"Latitude"];
			[dict setObject:[NSNumber numberWithDouble:0.0] forKey:@"Longitude"];
			[dict setValue:@"" forKey:@"Description"];
			descriptionCell.descriptionField.text = @"";
			nameFieldCell.nameField.text = [PrefAccess readPrefByKey:@"Name"];
			[dict setValue:@"" forKey:@"TypeTitle"];
			[dict setObject:[NSNumber numberWithInt:0] forKey:@"TypeID"];
			[dict writeToFile:tempPlistPathInAppDocuments atomically:YES];
			
			MGOVGeocoder *shared = [MGOVGeocoder sharedVariable];
			selectedCoord = shared.locationManager.location.coordinate;
			[locationCell updatingCoordinate:selectedCoord];
			[dict release];
			
			[self viewWillAppear:YES];
		} else {
			[self.tableView reloadData];
		}

	}
	if (alertView.tag==3000) {
		if (buttonIndex) {
			if ([alertEmailInputField.text length]) {
				NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z0-9.-]";
				NSRange r;
				r = [alertEmailInputField.text rangeOfString:emailRegex options:NSRegularExpressionSearch];
				if (r.location != NSNotFound) {
					// Write email to plist
					[PrefAccess writePrefByKey:@"User Email" andObject:alertEmailInputField.text];
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
	if (alertView.tag==4000) {
		typesViewController *typesView = [[typesViewController alloc] init];
		UINavigationController *typeAndDetailSelector = [[UINavigationController alloc] initWithRootViewController:typesView];
		// Show the view
		typesView.delegate = self;
		[self presentModalViewController:typeAndDetailSelector animated:YES];
		[typeAndDetailSelector release];
		[typesView release];
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
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:tempPlistPathInAppDocuments];
	[dict setObject:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"Longitude"];
	[dict setObject:[NSNumber numberWithDouble:coordinate.latitude] forKey:@"Latitude"];
	[dict writeToFile:tempPlistPathInAppDocuments atomically:YES];
	[dict release];
	
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
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:tempPlistPathInAppDocuments];
	[dict setObject:[NSNumber numberWithInt:q] forKey:@"TypeID"];
	[dict setValue:t forKey:@"TypeTitle"];
	[dict writeToFile:tempPlistPathInAppDocuments atomically:YES];
	[dict release];
	
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
		// Set keyboard bar
		// Prepare Keyboard
		UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, -44, 320, 44)];
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
		[doneEditing release];
		[flexibleItem release];
		[optionalHint release];
		
		keyboard = [[[[[UIApplication sharedApplication] windows] objectAtIndex:1] subviews] objectAtIndex:0];
		[keyboard addSubview:keyboardToolbar];
		[keyboardToolbar release];
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
	
	// Set the title
	self.title = @"報案";
	
	// Add submit button
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
	selectedImage = nil;
	
	selectedCoord = shared.locationManager.location.coordinate;
	shared = nil;
	userName = [PrefAccess readPrefByKey:@"Name"];
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
	[photoCell.photoButton setTitle:@"按一下以加入照片..." forState:UIControlStateNormal];
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
	nameFieldCell.nameField.text = userName;
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
	if (![descriptionCell.descriptionField.text isEqualToString:@"請輸入描述及建議"]) [dict setValue:descriptionCell.descriptionField.text forKey:@"Description"];
	[dict writeToFile:tempPlistPathInAppDocuments atomically:YES];	
	userName = nameFieldCell.nameField.text;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[selectedTypeTitle release];
	[alertEmailInputField release];
	[photoCell release];
	[locationCell release];
	[nameFieldCell release];
	[descriptionCell release];
    [super dealloc];
}

@end

