/*
 * 
 * NameFieldTableCell.m
 * 2010/8/31
 * sodas
 * 
 * Cell which let user type in thier name
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
#import "NameFieldTableCell.h"

@implementation NameFieldTableCell

@synthesize nameField;

+ (CGFloat)cellHeight {
	return kNameFieldCellHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        nameField = [[UITextField alloc] initWithFrame:CGRectMake(8.0, 10.0, 284, kNameFieldCellHeight-14)];
		nameField.tag = 100;
		nameField.placeholder = @"請輸入您的姓名";
		nameField.autocorrectionType = UITextAutocorrectionTypeNo;
		nameField.delegate = self;
		nameField.keyboardType = UIKeyboardTypeDefault;
		nameField.returnKeyType = UIReturnKeyDone;
		nameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
		
		// Set keyboard bar
		// Prepare Keyboard
		UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, -44, 320, 44)];
		keyboardToolbar.barStyle = UIBarStyleBlack;
		keyboardToolbar.translucent = YES;
		
		// Prepare Buttons
		UIBarButtonItem *doneEditing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nameField action:@selector(resignFirstResponder)];
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
		
		nameField.inputAccessoryView = keyboardToolbar;
		[keyboardToolbar release];
		
		[self.contentView addSubview:nameField];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
	[nameField release];
	[super dealloc];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

@end
