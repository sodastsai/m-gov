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

@interface CaseAddViewController : UITableViewController <TypeSelectorDelegateProtocol, UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>  {
	NSString *selectedTypeTitle;
	NSInteger qid;
	UITextField *emailField;
	UIAlertView *alertEmailInput;
	NSString *alertRequestEmailTitle;
	NSString *alertRequestEmailPlaceholder;
	NSString *nameFieldPlaceholder;
}

@property (retain, nonatomic) NSString *selectedTypeTitle;
@property (nonatomic) NSInteger qid;
@property (nonatomic, retain) UIButton *photoButton;

- (BOOL)submitCase;
- (void)photoDialogAction;


@end
