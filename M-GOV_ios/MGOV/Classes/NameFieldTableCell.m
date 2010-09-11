//
//  NameFieldTableCell.m
//  MGOV
//
//  Created by sodas on 2010/8/31.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

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
