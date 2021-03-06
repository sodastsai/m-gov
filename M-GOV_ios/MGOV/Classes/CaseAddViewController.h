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

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "TypesViewController.h"
#import "TypeSelectorDelegateProtocol.h"
#import "PhotoPickerTableCell.h"
#import "LocationSelectorTableCell.h"
#import "NameFieldTableCell.h"
#import "DescriptionTableCell.h"
#import "FacebookTableCell.h"
#import "LocationSelectorViewController.h"
#import "ASIFormDataRequest.h"
#import "LoadingOverlayView.h"
#import "CaseSelectorViewController.h"
#import "NetworkChecking.h"
#import "GoogleAnalytics.h"
#import "FBConnect.h"

#define kPhotoScale 640

@interface CaseAddViewController : UITableViewController <TypeSelectorDelegateProtocol, UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, PhotoPickerTableCellDelegate, LocationSelectorTableCellDelegate, LocationSelectorViewControllerDelegate, ASIHTTPRequestDelegate, FBSessionDelegate, FBRequestDelegate, FBDialogDelegate>  {
	
    NSString *selectedTypeTitle;
	NSInteger qid;
	UITextField *alertEmailInputField;
	UIAlertView *alertEmailPopupBox;
	CLLocationCoordinate2D selectedCoord;
	
	// Component Cells
	PhotoPickerTableCell *photoCell;
	LocationSelectorTableCell *locationCell;
	NameFieldTableCell *nameFieldCell;
	DescriptionTableCell *descriptionCell;
    FacebookTableCell *facebookTextCell;
	
	LoadingOverlayView *indicatorView;
	NSMutableDictionary *columnSaving;
	
	// Update Information
	BOOL ableToUpdateLocationCell;
	
	// Save for goolge analytics
	CLLocationCoordinate2D originalLocation;
	float latDelta;
	float lonDelta;
	BOOL locationSelectorDidChangeLocation;
	
	// Parent
	CaseSelectorViewController *myCase;
    
    // Facebook component
    Facebook *facebook;
    NSString *postItemId;
    NSString *likeCount;
    NSString *commentCount;
    NSInteger switchIsSet;
    UISwitch *facebookSwitch;
}

@property (nonatomic) BOOL ableToUpdateLocationCell;
@property (retain, nonatomic) NSString *selectedTypeTitle;
@property (nonatomic) NSInteger qid;
@property (retain, nonatomic) CaseSelectorViewController *myCase;
@property (nonatomic, retain) NSMutableDictionary *columnSaving;

//Facebook
@property (readonly) Facebook *facebook;
@property (nonatomic, retain) NSString *postItemId;
@property (nonatomic, retain) NSString *likeCount;
@property (nonatomic, retain) NSString *commentCount;
@property (nonatomic) NSInteger switchIsSet;

- (void)submitCase;
- (void)cleanAllField;
- (void)sendGoogleAnalyticInfoWithSubmitStatus:(BOOL)status;

@end
