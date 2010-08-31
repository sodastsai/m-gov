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
		firstShowHideKeyboard = YES;
		descriptionField = [[UITextView alloc] initWithFrame:CGRectMake(8.0, 8.0, kTextFieldWidth, 100)];
		descriptionField.font = [UIFont systemFontOfSize:18.0];
		descriptionField.delegate = self;
		//descriptionField.text = @"請描述案件情況";
		[self.contentView addSubview:descriptionField];

		self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)hideKeyboard {
	[descriptionField resignFirstResponder];
}

- (void)dealloc {
    [descriptionField release];
	[super dealloc];
}

#pragma mark -
#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
	if (firstShowHideKeyboard) {
		// Close Keyboard Button
		closeKeyboard = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		closeKeyboard.frame = CGRectMake(193.0, 115.0, 100, 30);
		[closeKeyboard setTitle:@"輸入完成" forState:UIControlStateNormal];
		[closeKeyboard addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:closeKeyboard];
	} else {
		closeKeyboard.hidden = NO;
	}
	
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	closeKeyboard.hidden = YES;
	if (firstShowHideKeyboard) firstShowHideKeyboard = NO;
}

@end
