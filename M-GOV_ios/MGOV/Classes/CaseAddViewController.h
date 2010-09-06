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

#import "AppClassExtension.h"

@protocol CaseAddViewControllerProtocol

- (void)refreshData;

@end



@interface CaseAddViewController : UITableViewController <TypeSelectorDelegateProtocol, UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, PhotoPickerTableCellDelegate, LocationSelectorTableCellDelegate, LocationSelectorViewControllerDelegate>  {
	NSString *selectedTypeTitle;
	NSInteger qid;
	UITextField *alertEmailInputField;
	UIAlertView *alertEmailPopupBox;
	NSString *alertRequestEmailTitle;
	NSString *alertRequestEmailPlaceholder;
	NSString *nameFieldPlaceholder;
	CLLocationCoordinate2D selectedCoord;
	UIImage *selectedImage;
	
	// Component Cells
	PhotoPickerTableCell *photoCell;
	LocationSelectorTableCell *locationCell;
	NameFieldTableCell *nameFieldCell;
	DescriptionTableCell *descriptionCell;
	
	UIToolbar *keyboardToolbar;
	UIView *keyboard;
	id<CaseAddViewControllerProtocol> delegate;
}

@property (retain, nonatomic) id<CaseAddViewControllerProtocol> delegate;
@property (retain, nonatomic) NSString *selectedTypeTitle;
@property (nonatomic) NSInteger qid;

- (BOOL)submitCase;
- (void)keyboardWillShow:(NSNotification *)note;
- (void)endEditingText;

@end
