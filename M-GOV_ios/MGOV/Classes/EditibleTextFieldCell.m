//
//  EditibleTextFieldCell.m
//  MGOV
//
//  Created by sodas on 2010/10/3.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "EditibleTextFieldCell.h"

@implementation EditibleTextFieldCell
@synthesize titleField, contentField, prefKey;
@synthesize delegate;

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
	originalValue = textField.text;
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	if (prefKey!=nil && ![textField.text isEqual:originalValue]) 
		[delegate writeToPrefWithKey:prefKey andObject:textField.text];
	return YES;
}

@end
