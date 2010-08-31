//
//  DescriptionTableCell.h
//  MGOV
//
//  Created by sodas on 2010/8/31.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kTextFieldWidth 284.0

@interface DescriptionTableCell : UITableViewCell <UITextViewDelegate> {
	UITextView *descriptionField;
	UIToolbar *keyboardToolbar;
	UIView *keyboard;
}

@property (nonatomic, retain) UITextView *descriptionField;

- (void)keyboardWillShow:(NSNotification *)note;
- (void)endEditingTextView;

@end
