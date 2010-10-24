/*
 * 
 * EditibleTextFieldCell.m
 * 2010/10/3
 * sodas
 * 
 * UITableViewCell with editible text field
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

#import "EditibleTextFieldCell.h"

@implementation EditibleTextFieldCell
@synthesize titleField, contentField, prefKey;
@synthesize delegate;
@synthesize originalValue;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        titleField = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 66, 21)];
		titleField.font = [UIFont boldSystemFontOfSize:17.0];
		titleField.minimumFontSize = 14.0;
		titleField.adjustsFontSizeToFitWidth = YES;
		titleField.numberOfLines = 1;
		titleField.backgroundColor = [UIColor clearColor];
		titleField.textColor = [UIColor blackColor];
		titleField.textAlignment = UITextAlignmentLeft;
		
		contentField = [[UITextField alloc] initWithFrame:CGRectMake(94, 7, 206, 31)];
		contentField.font = [UIFont systemFontOfSize:17.0];
		contentField.minimumFontSize = 12.0;
		contentField.adjustsFontSizeToFitWidth = YES;
		contentField.backgroundColor = [UIColor clearColor];
		contentField.textColor = [UIColor colorWithHue:0.6083 saturation:0.59 brightness:0.53 alpha:1];
		contentField.textAlignment = UITextAlignmentLeft;
		contentField.borderStyle = UITextBorderStyleNone;
		contentField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		contentField.clearButtonMode = UITextFieldViewModeWhileEditing;
		contentField.keyboardType = UIKeyboardTypeDefault;
		contentField.returnKeyType = UIReturnKeyDone;
		contentField.delegate = self;
	
		prefKey = nil;
		
		[self addSubview:titleField];
		[self addSubview:contentField];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
	[titleField release];
	[contentField release];
    [super dealloc];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	self.originalValue = textField.text;
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	if (prefKey!=nil && ![textField.text isEqual:originalValue]) 
		[delegate writeToPrefWithKey:prefKey andObject:textField.text];
	return YES;
}

@end
