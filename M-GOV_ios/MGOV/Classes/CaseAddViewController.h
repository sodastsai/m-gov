//
//  CaseAddViewController.h
//  MGOV
//
//  Created by Shou on 2010/8/25.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "typesViewController.h"
#import "TypeSelectorDelegateProtocol.h"
#import "PhotoPickerTableCell.h"
#import "LocationSelectorTableCell.h"
#import "NameFieldTableCell.h"
#import "DescriptionTableCell.h"
#import "LocationSelectorViewController.h"
#import "JSON.h"
#import "ASIFormDataRequest.h"
#import "LoadingOverlayView.h"
#import "CaseSelectorViewController.h"
#import "PrefAccess.h"
#import "NetWorkChecking.h"

#define kPhotoScale 640

@interface CaseAddViewController : UITableViewController <TypeSelectorDelegateProtocol, UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, PhotoPickerTableCellDelegate, LocationSelectorTableCellDelegate, LocationSelectorViewControllerDelegate, ASIHTTPRequestDelegate>  {
	NSString *selectedTypeTitle;
	NSInteger qid;
	UITextField *alertEmailInputField;
	UIAlertView *alertEmailPopupBox;
	CLLocationCoordinate2D selectedCoord;
	UIImage *selectedImage;
	
	// Component Cells
	PhotoPickerTableCell *photoCell;
	LocationSelectorTableCell *locationCell;
	NameFieldTableCell *nameFieldCell;
	DescriptionTableCell *descriptionCell;
	
	UIToolbar *keyboardToolbar;
	UIView *keyboard;
	LoadingOverlayView *indicatorView;
	
	// Parent
	CaseSelectorViewController *myCase;
}

@property (retain, nonatomic) NSString *selectedTypeTitle;
@property (nonatomic) NSInteger qid;
@property (retain, nonatomic) UIImage *selectedImage;
@property (retain, nonatomic) CaseSelectorViewController *myCase;

- (void)submitCase;
- (void)keyboardWillShow:(NSNotification *)note;
- (void)endEditingText;

@end
