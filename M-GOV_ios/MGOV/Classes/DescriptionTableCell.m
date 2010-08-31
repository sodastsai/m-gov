//
//  DescriptionTableCell.m
//  MGOV
//
//  Created by sodas on 2010/8/31.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "DescriptionTableCell.h"

@implementation DescriptionTableCell

@synthesize descriptionField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		descriptionField = [[UITextView alloc] initWithFrame:CGRectMake(8.0, 8.0, kTextFieldWidth, 140)];
		descriptionField.font = [UIFont systemFontOfSize:18.0];
		descriptionField.delegate = self;
		[self.contentView addSubview:descriptionField];

		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		// Set keyboard bar
		// Prepare Keyboard
		keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, -44, 320, 44)];
		keyboardToolbar.barStyle = UIBarStyleBlack;
		keyboardToolbar.translucent = YES;
		
		// Prepare Buttons
		UIBarButtonItem *doneEditing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(endEditingTextView)];
		UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		
		// Prepare Labels
		UILabel *optionalHint = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, 250, 16)];
		optionalHint.text = @"本欄為選項性欄位，可不填";
		optionalHint.backgroundColor = [UIColor clearColor];
		optionalHint.textColor = [UIColor whiteColor];
		optionalHint.font = [UIFont boldSystemFontOfSize:16.0];
		[keyboardToolbar addSubview:optionalHint];
		
		// Add buttons to keyboard
		NSArray *toolbarItems = [NSArray arrayWithObjects:flexibleItem, doneEditing, nil];
		[keyboardToolbar setItems:toolbarItems animated:YES];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    [descriptionField release];
	[super dealloc];
}

#pragma mark -
#pragma mark UITextViewDelegate and Keyboard Toolbar

- (void)textViewDidBeginEditing:(UITextView *)textView {
	// Monitor the keyboard
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)note {
	// locate keyboard view from window
	keyboard = [[[[[UIApplication sharedApplication] windows] objectAtIndex:1] subviews] objectAtIndex:0];
	[keyboard addSubview:keyboardToolbar];
}

- (void)endEditingTextView {
	// Remove Toolbar From Keyboard
	[[[keyboard subviews] lastObject] removeFromSuperview];
	// Stop monitor keyboard
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	// Hide the keyboard
	[descriptionField resignFirstResponder];
}

@end
