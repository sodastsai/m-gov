/*
 * 
 * CaseAddViewController.h
 * 2010/8/25
 * Shou
 * 
 * The main layout of Case Adder
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

#import "CaseAddViewController.h"
#import "AppMKAnnotation.h"

@implementation CaseAddViewController

@synthesize selectedTypeTitle;
@synthesize qid, userName;
@synthesize selectedImage;
@synthesize myCase;
@synthesize columnSaving;
@synthesize ableToUpdateLocationCell;

#pragma mark -
#pragma mark View lifecycle

- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		ableToUpdateLocationCell = YES;
		// Set the title
		self.title = @"報案";
		
		selectedTypeTitle = @"";
		selectedImage = nil;
		self.userName = [[NSUserDefaults standardUserDefaults] stringForKey:@"Name"];
		locationSelectorDidChangeLocation = NO;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Add submit button
	UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"送出案件" style:UIBarButtonItemStylePlain target:self action:@selector(submitCase)];
	self.navigationItem.rightBarButtonItem = submitButton;
	[submitButton release];
	
	// Add Component
	if (photoCell==nil)
		photoCell = [[PhotoPickerTableCell alloc] init];
	photoCell.delegate = self;
	
	MGOVGeocoder *shared = [MGOVGeocoder sharedVariable];
	if (locationCell==nil)
		locationCell = [[LocationSelectorTableCell alloc] initWithHeight:100 andCoordinate:shared.locationManager.location.coordinate actionTarget:self setAction:@selector(openLocationSelector)];
	locationCell.delegate = self;
	originalLocation = shared.locationManager.location.coordinate;
	selectedCoord = shared.locationManager.location.coordinate;
	
	if (nameFieldCell==nil)
		nameFieldCell = [[NameFieldTableCell alloc] init];
	nameFieldCell.nameField.delegate = self;
	
	if (descriptionCell==nil)
		descriptionCell = [[DescriptionTableCell alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// Fetch the data user key in last time
	NSString *tempPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"CaseAddTempInformation.plist"];
	self.columnSaving = [NSMutableDictionary dictionaryWithContentsOfFile:tempPlistPathInAppDocuments];
	
	// Photo Cell
	UIImage *image = [UIImage imageWithData:[self.columnSaving objectForKey:@"Photo"]];
	[photoCell.photoButton setImage:[image fitToSize:CGSizeMake(300, [PhotoPickerTableCell cellHeight])] forState:UIControlStateNormal];
	[photoCell.photoButton setTitle:@"按一下以加入照片..." forState:UIControlStateNormal];
	if (image != nil)
		[photoCell.photoButton setTitle:@"" forState:UIControlStateNormal];
	
	// Location Cell
	if ([[self.columnSaving objectForKey:@"Latitude"] doubleValue]!=0 && [[self.columnSaving objectForKey:@"Longitude"] doubleValue]!=0) {
		selectedCoord.latitude = [[self.columnSaving objectForKey:@"Latitude"] doubleValue];
		selectedCoord.longitude = [[self.columnSaving objectForKey:@"Longitude"] doubleValue];
		[locationCell updatingCoordinate:selectedCoord];
	} else {
		if (ableToUpdateLocationCell) {
			MGOVGeocoder *shared = [MGOVGeocoder sharedVariable];
			[locationCell updatingCoordinate:shared.locationManager.location.coordinate];
			selectedCoord = shared.locationManager.location.coordinate;
		}
	}
	
	// Type Cell
	self.qid = [[self.columnSaving objectForKey:@"TypeID"] intValue];
	self.selectedTypeTitle = [self.columnSaving valueForKey:@"TypeTitle"];
	
	// Name Cell
	nameFieldCell.nameField.text = userName;
	
	// Description Cell
	[descriptionCell setPlaceholder:[self.columnSaving valueForKey:@"Description"]];
	
	[self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	// Temporary store the name & description info. to CaseAddTempInformation.plist
	NSString *tempPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"CaseAddTempInformation.plist"];
	if (![descriptionCell.descriptionField.text isEqualToString:@"請輸入描述及建議"]) [self.columnSaving setValue:descriptionCell.descriptionField.text forKey:@"Description"];
	[self.columnSaving writeToFile:tempPlistPathInAppDocuments atomically:YES];
	
	userName = nameFieldCell.nameField.text;
}

#pragma mark -
#pragma mark Google Analytics

- (void)sendGoogleAnalyticInfoWithSubmitStatus:(BOOL)status {
	NSString *statusLabel;
	
	if (status) {
		[GoogleAnalytics trackAction:GANActionAddCaseSuccess withLabel:nil andTimeStamp:NO andUDID:NO];
		statusLabel = @"Success Submit";
	} else {
		[GoogleAnalytics trackAction:GANActionAddCaseFailed withLabel:nil andTimeStamp:NO andUDID:NO];
		statusLabel = @"Failed Submit";
	}
	
	// Will User take a photo? And will take photo cause a fail submit?
	if ([[self.columnSaving objectForKey:@"Photo"] isEqual:[NSData data]] || [self.columnSaving objectForKey:@"Photo"]==nil)
		[GoogleAnalytics trackAction:GANActionAddCaseWithoutPhoto withLabel:statusLabel andTimeStamp:NO andUDID:NO];
	else 
		[GoogleAnalytics trackAction:GANActionAddCaseWithPhoto withLabel:statusLabel andTimeStamp:NO andUDID:NO];
	
	// Will User change their location? Or, will GPS always give user correct location?
	if (locationSelectorDidChangeLocation && status)
		[GoogleAnalytics trackAction:GANActionAddCaseLocationSelectorChanged withLabel:[NSString stringWithFormat:@"Delta=(lat:%f,lon:%f)", latDelta, lonDelta] andTimeStamp:NO andUDID:NO];
	
	// Find which type is most populate
	if (status)
		[GoogleAnalytics trackAction:GANActionAddCaswWithType withLabel:[NSString stringWithFormat:@"%d", qid] andTimeStamp:NO andUDID:NO];
	
	// Will User enter their name? (Success Submit)
	if (![nameFieldCell.nameField.text isEqualToString:@""] && status)
		[GoogleAnalytics trackAction:GANActionAddCaseWithName withLabel:nil andTimeStamp:NO andUDID:NO];
	
	// Will User enter description? (Success Submit)
	if (![descriptionCell.descriptionField.text isEqualToString:@" "] && ![descriptionCell.descriptionField.text isEqualToString:@"請輸入描述及建議"] && status)
		[GoogleAnalytics trackAction:GANActionAddCaseWithDescription withLabel:nil andTimeStamp:NO andUDID:NO];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    self.tableView.delegate = self;
	self.tableView.dataSource = self;
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
		cell.textLabel.textAlignment = UITextAlignmentLeft;
		
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
		TypesViewController *typesView = [[TypesViewController alloc] init];
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
#pragma mark Content for submit

- (void)cleanAllField {
	NSString *tempPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"CaseAddTempInformation.plist"];
	[self.columnSaving setObject:[NSData data] forKey:@"Photo"];
	[self.columnSaving setObject:[NSNumber numberWithDouble:0.0] forKey:@"Latitude"];
	[self.columnSaving setObject:[NSNumber numberWithDouble:0.0] forKey:@"Longitude"];
	[self.columnSaving setValue:@"" forKey:@"Description"];
	descriptionCell.descriptionField.text = @"";
	nameFieldCell.nameField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"Name"];
	[self.columnSaving setValue:@"" forKey:@"TypeTitle"];
	[self.columnSaving setObject:[NSNumber numberWithInt:0] forKey:@"TypeID"];
	[self.columnSaving writeToFile:tempPlistPathInAppDocuments atomically:YES];
	
	MGOVGeocoder *shared = [MGOVGeocoder sharedVariable];
	selectedCoord = shared.locationManager.location.coordinate;
	[locationCell updatingCoordinate:selectedCoord];
	ableToUpdateLocationCell = YES;
}

- (void)submitCase {
	// If this is the First time to Submit, We should ask user's email.
	if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"User Email"] length]) {
		alertEmailPopupBox = [[UIAlertView alloc] initWithTitle:@"請輸入您的E-Mail" message:[NSString stringWithFormat:@"路見不平會使用E-Mail追蹤您的案件\n\n\n"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
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
	} else if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"User Email"] length] && qid != 0) {
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"NetworkIsAlerted"];
		if ([NetworkChecking checkNetwork]) {
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
#pragma mark Checked & Submit/Reject

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	// Reset all field
	if (alertView.tag==1000) {
		if (buttonIndex) {
			[self cleanAllField];
			[self viewWillAppear:YES];
		} else {
			[self.tableView reloadData];
		}
		
	}
	
	// It's ok to submit
	if (alertView.tag==2000) {
		if (buttonIndex) {
			indicatorView = [[LoadingOverlayView alloc] initAtViewCenter:self.navigationController.view];
			[self.navigationController.view addSubview:indicatorView];
			indicatorView.loading.text = @"正在送出...";
			[indicatorView startedLoad];
			
			// Convert Byte Data to Photo From Plist
			NSString *filename = [NSString stringWithFormat:@"%@-%d.png", [[NSUserDefaults standardUserDefaults] stringForKey:@"User Email"], [[NSDate date] timeIntervalSince1970]];
			
			// Process Description
			NSString *descriptionString;
			if ([descriptionCell.descriptionField.text isEqualToString:@"請輸入描述及建議"]) descriptionString = @" ";
			else descriptionString = descriptionCell.descriptionField.text;
			
			// Post the submt data to App Engine
			ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://ntu-ecoliving.appspot.com/case/add"]];
			request.delegate = self;
			[request setFile:[self.columnSaving objectForKey:@"Photo"] withFileName:filename andContentType:@"image/png" forKey:@"photo"];
			[request setPostValue:[[MGOVGeocoder returnRegion:selectedCoord]objectAtIndex:0] forKey:@"h_admit_name"];
			[request setPostValue:[[MGOVGeocoder returnRegion:selectedCoord]objectAtIndex:1] forKey:@"h_admiv_name"];
			[request setPostValue:[NSString stringWithFormat:@"%d", qid] forKey:@"typeid"];
			[request setPostValue:descriptionString forKey:@"h_summary"];
			[request setPostValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"User Email"] forKey:@"email"];
			[request setPostValue:nameFieldCell.nameField.text forKey:@"name"];
			[request setPostValue:[NSString stringWithFormat:@"%f", selectedCoord.longitude] forKey:@"coordx"];
			[request setPostValue:[NSString stringWithFormat:@"%f", selectedCoord.latitude] forKey:@"coordy"];
			[request setPostValue:[MGOVGeocoder returnFullAddress:selectedCoord] forKey:@"address"];
			
			if (![[[[NSBundle mainBundle] infoDictionary] objectForKey:@"Develop Mode"] boolValue])
				[request setPostValue:@"send" forKey:@"send"];
			
			QueryGoogleAppEngine *qGAE = [QueryGoogleAppEngine requestQuery];
			qGAE.conditionType = DataSourceGAEQueryByID;
			qGAE.queryCondition = @"000";
			qGAE.resultTarget = nil;
			qGAE.indicatorTargetView = nil;
			[qGAE startQuery];
			
			[request setTimeOutSeconds:90];
			[request startAsynchronous];
		}
	}
	
	// Input Email at first submit
	if (alertView.tag==3000) {
		if (buttonIndex) {
			if ([alertEmailInputField.text length]) {
				NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z0-9.-]";
				NSRange r;
				r = [alertEmailInputField.text rangeOfString:emailRegex options:NSRegularExpressionSearch];
				if (r.location != NSNotFound) {
					// Write email to plist
					[[NSUserDefaults standardUserDefaults] setObject:alertEmailInputField.text forKey:@"User Email"];
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
	
	// Submit with no type selected
	if (alertView.tag==4000) {
		TypesViewController *typesView = [[TypesViewController alloc] init];
		UINavigationController *typeAndDetailSelector = [[UINavigationController alloc] initWithRootViewController:typesView];
		// Show the view
		typesView.delegate = self;
		[self presentModalViewController:typeAndDetailSelector animated:YES];
		[typeAndDetailSelector release];
		[typesView release];
	}
}

#pragma mark -
#pragma mark Submit Result (ASIHTTPRequest Delegate)

- (void)requestFinished:(ASIHTTPRequest *)request {
	[self sendGoogleAnalyticInfoWithSubmitStatus:YES];
	
	if ([[[[NSBundle mainBundle] infoDictionary] objectForKey:@"Develop Mode"] boolValue])
		NSLog(@"%@", [request responseString]);
	
	[indicatorView finishedLoad];
	[indicatorView removeFromSuperview];
	[indicatorView release];
	
	[[NSUserDefaults standardUserDefaults] setObject:nameFieldCell.nameField.text forKey:@"Name"];
	
	[self cleanAllField];
	
	[self.navigationController popViewControllerAnimated:YES];
	[myCase refreshDataSource];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	[self sendGoogleAnalyticInfoWithSubmitStatus:NO];
	
	if ([[[[NSBundle mainBundle] infoDictionary] objectForKey:@"Develop Mode"] boolValue]) {
		NSLog(@"%@", [request responseString]);
		NSLog(@"ASIHttpRequest Error Code: %d", [[request error] code]);
	}
	
	[indicatorView finishedLoad];
	[indicatorView removeFromSuperview];
	[indicatorView release];
	UIAlertView *uploadFailed = [[UIAlertView alloc] initWithTitle:@"案件傳送失敗" message:@"案件傳送失敗，請重新傳送！" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
	[uploadFailed show];
	[uploadFailed release];
}

#pragma mark -
#pragma mark Cell Methods

#pragma mark -
#pragma mark Add Photo

- (void)openPhotoDialogAction {
	UIActionSheet *actionSheet = nil;
	if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
		actionSheet = [[UIActionSheet alloc] initWithTitle:@"請選擇照片來源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍攝新的照片", @"選擇現有的照片", nil];
		actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
		// Cannot use [actionSheet showInView:self.view]! This will be affected by the UITabBar 
		[actionSheet showInView:self.parentViewController.tabBarController.view];
	} else {
		actionSheet = [[UIActionSheet alloc] initWithTitle:@"請選擇照片來源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"選擇現有的照片", nil];
		actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
		// Cannot use [actionSheet showInView:self.view]! This will be affected by the UITabBar 
		[actionSheet showFromTabBar:self.parentViewController.tabBarController.tabBar];
	}
	[actionSheet release];
}

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
	NSData *data = UIImagePNGRepresentation(selectedImage);
	[self.columnSaving setObject:data forKey:@"Photo"];
	[self.columnSaving writeToFile:tempPlistPathInAppDocuments atomically:YES];
	data = nil;
	
	// Close Picker,Reload Data, and Call Location Selector
	[picker dismissModalViewControllerAnimated:YES];
	[self.tableView reloadData];
	[NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(openLocationSelector) userInfo:nil repeats:NO];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	BOOL cameraAvailibility = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
	
	// Cancel
	if (cameraAvailibility) {
		if (buttonIndex == 2) return;
	} else {
		if (buttonIndex == 1) return;
	}
	
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	
	if (cameraAvailibility)
		if (buttonIndex == 0)
			picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		else if ( buttonIndex == 1 )
			picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	else
		if (buttonIndex == 0)
			picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	
	[self presentModalViewController:picker animated:YES];
	[picker release];
}

#pragma mark -
#pragma mark Location Selector

- (void)openLocationSelector {
	LocationSelectorViewController *locationSelector = [[LocationSelectorViewController alloc] initWithCoordinate:selectedCoord];
	locationSelector.delegate = self;
	[self presentModalViewController:locationSelector animated:YES];
	[locationSelector release];
}

- (void)userDidSelectCancel {
	// Do nothing
	// Dismiss the view
	[self dismissModalViewControllerAnimated:YES];
}

- (void)userDidSelectDone:(CLLocationCoordinate2D)coordinate {
	
	// Temporary store the coordinate selected by user to CaseAddTempInformation.plist
	NSString *tempPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"CaseAddTempInformation.plist"];
	[self.columnSaving setObject:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"Longitude"];
	[self.columnSaving setObject:[NSNumber numberWithDouble:coordinate.latitude] forKey:@"Latitude"];
	[self.columnSaving writeToFile:tempPlistPathInAppDocuments atomically:YES];
	
	// Dismiss the view
	[locationCell updatingCoordinate:coordinate];
	// Set Geo information
	selectedCoord = coordinate;
	[self.tableView reloadData];
	[self dismissModalViewControllerAnimated:YES];
	
	if (coordinate.latitude!=originalLocation.latitude || coordinate.longitude!=originalLocation.longitude) {
		locationSelectorDidChangeLocation = YES;
		latDelta = coordinate.latitude - originalLocation.latitude;
		lonDelta = coordinate.longitude - originalLocation.longitude;
		ableToUpdateLocationCell = NO;
	}
}

#pragma mark -
#pragma mark Type Selector

- (void)typeSelectorDidSelectWithTitle:(NSString *)t andQid:(NSInteger)q {
	self.selectedTypeTitle = t;
	self.qid = q;
	
	// Temporary store the typeid & typetitle info. to CaseAddTempInformation.plist
	NSString *tempPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"CaseAddTempInformation.plist"];
	[self.columnSaving setObject:[NSNumber numberWithInt:q] forKey:@"TypeID"];
	[self.columnSaving setValue:t forKey:@"TypeTitle"];
	[self.columnSaving writeToFile:tempPlistPathInAppDocuments atomically:YES];
	tempPlistPathInAppDocuments = nil;
	
	// Dismiss the view
	[self dismissModalViewControllerAnimated:YES];
	// Reload tableview after selected
	[self.tableView reloadData];
}

- (void)leaveSelectorWithoutTitleAndQid {
	[self dismissModalViewControllerAnimated:YES];
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

@end
