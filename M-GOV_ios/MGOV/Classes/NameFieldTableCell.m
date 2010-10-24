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
        nameField = [[UITextField alloc] initWithFrame:CGRectMake(8.0, 8.0, 284, kNameFieldCellHeight-14)];
		nameField.tag = 100;
		nameField.placeholder = @"請輸入您的姓名";
		nameField.autocorrectionType = UITextAutocorrectionTypeNo;
		nameField.delegate = self;
		nameField.keyboardType = UIKeyboardTypeDefault;
		nameField.returnKeyType = UIReturnKeyDone;
		nameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
		
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
	if (textField.tag==100)
		[textField resignFirstResponder];
	
	return YES;
}

@end
