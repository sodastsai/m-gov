//
//  CaseAddViewController.m
//  MGOV
//
//  Created by Shou on 2010/8/25.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "CaseAddViewController.h"
#import "AppMKAnnotation.h"

#define kTextFieldHeight 30.0
#define kTextFieldWidth 290.0
#define kMapViewHeight 120.0
#define kPhotoViewHeight 225.0

@implementation CaseAddViewController

@synthesize selectedTypeTitle;
@synthesize qid;
@synthesize photoButton;
@synthesize didSelectPhoto;

#pragma mark -
#pragma mark CaseAddMethod

- (BOOL)submitCase {
	[self.navigationController popViewControllerAnimated:YES];
	return YES;
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void) photoDialogAction {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"請選擇照片來源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍攝照片", @"選擇照片", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
	// Cannot use [actionSheet showInView:self.view]! This will be affected by the UITabBar 
	[actionSheet showInView:self.parentViewController.tabBarController.view];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	
	if (buttonIndex == 0) {
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		[self presentModalViewController:picker animated:YES];
	} else if ( buttonIndex == 1 ){
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[self presentModalViewController:picker animated:YES];
	}
	
	[picker release];	
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

// TODO: picker localization

/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	
	//photo = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	[picker dismissModalViewControllerAnimated:YES];
	
	//[self.tableView reloadData];
	
}
*/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
	[photoButton setBackgroundImage:image forState:UIControlStateNormal];
	[picker dismissModalViewControllerAnimated:YES];
	self.didSelectPhoto = YES;
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"報案";
	
	UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"送出案件" style:UIBarButtonItemStylePlain target:self action:@selector(submitCase)];
	self.navigationItem.rightBarButtonItem = submitButton;
	[submitButton release];
	
	selectedTypeTitle = @"";
	didSelectPhoto = NO;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	// The number has been discussed before.
    if (!section) {
		return 2;
	}
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return @"照片及地址";
	} else if (section == 1 ){
		return @"案件種類";
	} else if (section == 2 ){
		return @"報案者姓名";
	} else if (section == 3 ){
		return @"描述及建議";
	}
	
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
	// Set the height according to the edit area size
    if (indexPath.section == 0) {
		if (!indexPath.row) {
			return kPhotoViewHeight;
		} else {
			return kMapViewHeight;
		}
	} else if (indexPath.section == 1 ){
		return 45;
	} else if (indexPath.section == 2 ){
		return 40;
	} else if (indexPath.section == 3 ){
		return 190;
	}
	
	return 40;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = nil;
	
	static NSString *Cell1Identifier = @"Cell";
	cell = [tableView dequeueReusableCellWithIdentifier:Cell1Identifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell1Identifier] autorelease];
		// Default Cell Style
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	// Style by each cell
	if (indexPath.section == 0) {
		if ( indexPath.row == 0 ) {
			// TODO: photo scale
			// TODO: round corner
			#pragma mark PhotoPicker
			if (!didSelectPhoto) {
				photoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, kPhotoViewHeight)];
				
				[photoButton setTitle:@"按一下以加入照片..." forState:UIControlStateNormal];
				photoButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
				[photoButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
				
				photoButton.showsTouchWhenHighlighted = YES;
				[photoButton addTarget:self action:@selector(photoDialogAction) forControlEvents:UIControlEventTouchUpInside];
				[cell.contentView addSubview:photoButton];
			} else {
				[photoButton setTitle:@"" forState:UIControlStateNormal];
			}
		}
		if (indexPath.row == 1) {
			#pragma mark Address MapView
			MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, kTextFieldWidth+10, kMapViewHeight)];
			mapView.mapType = MKMapTypeStandard;
			GlobalVariable *shared = [GlobalVariable sharedVariable];
			[mapView setCenterCoordinate:shared.locationManager.location.coordinate animated:YES];
			MKCoordinateRegion region;
			region.center = shared.locationManager.location.coordinate;
			MKCoordinateSpan span;
			span.latitudeDelta = 0.004;
			span.longitudeDelta = 0.004;
			region.span = span;
			[mapView setRegion:region];
			
			// TODO: correct the title: 現在位置or照片位置
			// TODO: correct the subtitle: 地址
			AppMKAnnotation *casePlace = [[AppMKAnnotation alloc] initWithCoordinate:region.center andTitle:@"Title test" andSubtitle:@"科科"];
			[mapView addAnnotation:casePlace];
			[casePlace release];

			// TODO: fix the bound to round.
			// TODO: fix the map in normal view		
			[cell.contentView addSubview:mapView];
			[mapView release];
		}
	} else if (indexPath.section == 1) {
		#pragma mark Type Selector
		// Decide placeholder or selected result to show
		if ([selectedTypeTitle length])
			cell.textLabel.text = selectedTypeTitle;
		else
			cell.textLabel.text = @"請按此選擇案件種類";
		// Other style
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	} else if (indexPath.section == 2) {
		#pragma mark Name field
		UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(8.0, 8.0, kTextFieldWidth, kTextFieldHeight)];
		nameField.placeholder = @"請輸入您的姓名";
		nameField.autocorrectionType = UITextAutocorrectionTypeNo;
		nameField.delegate = self;
		nameField.keyboardType = UIKeyboardTypeDefault;
		nameField.returnKeyType = UIReturnKeyDone;
		nameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
		
		[cell.contentView addSubview:nameField];
		[nameField release];
	} else {
		#pragma mark Descritption
		// TODO: change to other UI element
		UITextView *descriptionField = [[UITextView alloc] initWithFrame:CGRectMake(8.0, 8.0, kTextFieldWidth, 180)];
		descriptionField.font = [UIFont systemFontOfSize:18.0];
		//descriptionField.text = @"請描述案件情況";
		[cell.contentView addSubview:descriptionField];
		[descriptionField release];
	}
	
	return cell;
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	// End editing
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section==1 && indexPath.row==0) {
		typesViewController *typesView = [[typesViewController alloc] init];
		typesView.title = @"請選擇案件種類";
		UINavigationController *typeAndDetailSelector = [[UINavigationController alloc] initWithRootViewController:typesView];
		// Show the view
		typesView.delegate = self;
		[self presentModalViewController:typeAndDetailSelector animated:YES];
		// Add Back button
		UIBarButtonItem *backBuuton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:typesView action:@selector(backToPreviousView)];
		typesView.navigationItem.leftBarButtonItem = backBuuton;
		[backBuuton release];
		[typesView release];
		
		// Record to plist
		NSString *typeSelectorStatusPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"TypeSelectorStatus.plist"];
		NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:typeSelectorStatusPlistPathInAppDocuments];
		[dict setValue:@"submit" forKey:@"Invoker"];
		[dict setValue:0 forKey:@"submitReadable"];
		[dict writeToFile:typeSelectorStatusPlistPathInAppDocuments atomically:YES];
	}
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

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[selectedTypeTitle release];
	[photoButton release];
    [super dealloc];
}

@end

