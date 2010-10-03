//
//  EditibleTextFieldCell.m
//  MGOV
//
//  Created by sodas on 2010/10/3.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "EditibleTextFieldCell.h"

@implementation EditibleTextFieldCell
@synthesize title, content;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        title = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 66, 21)];
		title.font = [UIFont boldSystemFontOfSize:17.0];
		title.minimumFontSize = 14.0;
		title.adjustsFontSizeToFitWidth = YES;
		title.numberOfLines = 1;
		title.backgroundColor = [UIColor clearColor];
		title.textColor = [UIColor blackColor];
		title.textAlignment = UITextAlignmentLeft;
		
		content = [[UITextField alloc] initWithFrame:CGRectMake(94, 7, 206, 31)];
		content.font = [UIFont systemFontOfSize:17.0];
		content.minimumFontSize = 12.0;
		content.adjustsFontSizeToFitWidth = YES;
		content.backgroundColor = [UIColor clearColor];
		content.textColor = [UIColor colorWithHue:0.6083 saturation:0.59 brightness:0.53 alpha:1];
		content.textAlignment = UITextAlignmentLeft;
		content.borderStyle = UITextBorderStyleNone;
		content.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		content.clearButtonMode = UITextFieldViewModeWhileEditing;
		content.keyboardType = UIKeyboardTypeDefault;
		content.returnKeyType = UIReturnKeyDone;
		content.delegate = self;
		
		[self addSubview:title];
		[self addSubview:content];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
	[title release];
	[content release];
    [super dealloc];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

@end
