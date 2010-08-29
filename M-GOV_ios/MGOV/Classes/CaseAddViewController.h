//
//  CaseAddViewController.h
//  MGOV
//
//  Created by Shou on 2010/8/25.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "typesViewController.h"
#import "TypeSelectorDelegateProtocol.h"

@interface CaseAddViewController : UITableViewController <TypeSelectorDelegateProtocol, UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>  {
	NSString *selectedTypeTitle;
	NSInteger qid;
	UIButton *photoButton;
	BOOL didSelectPhoto;
}

@property (retain, nonatomic) NSString *selectedTypeTitle;
@property (nonatomic) NSInteger qid;
@property (nonatomic, retain) UIButton *photoButton;
@property (nonatomic) BOOL didSelectPhoto;

- (BOOL)submitCase;
- (void)photoDialogAction;


@end
