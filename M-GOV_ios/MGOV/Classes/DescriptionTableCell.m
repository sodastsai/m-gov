/*
 * 
 * DescriptionTableCell.h
 * 2010/8/31
 * sodas
 * 
 * Cell which let user type in case description
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

#import "DescriptionTableCell.h"

@implementation DescriptionTableCell

@synthesize descriptionField;

+ (CGFloat)cellHeight {
	return kDescriptionFieldCellHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		textViewPlaceholder = YES;
		
		descriptionField = [[UITextView alloc] initWithFrame:CGRectMake(8.0, 8.0, 284, kDescriptionFieldCellHeight-14)];
		if (textViewPlaceholder) {
			descriptionField.contentInset = UIEdgeInsetsMake(-7,-7,-7,-7);
			descriptionField.text = @"請輸入描述及建議";
			descriptionField.textColor = [UIColor lightGrayColor];
		}
		descriptionField.tag = 99;
		descriptionField.font = [UIFont systemFontOfSize:17.0];
		descriptionField.delegate = self;
		[self.contentView addSubview:descriptionField];

		self.selectionStyle = UITableViewCellSelectionStyleNone;
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
#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	descriptionField.contentInset = UIEdgeInsetsMake(-7,-7,-7,-7);
	if (textViewPlaceholder) {
		textView.text = @"";
		textView.textColor = [UIColor blackColor];
		textViewPlaceholder = NO;
	}
	return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
	if ([textView.text isEqualToString:@""]) {
		descriptionField.contentInset = UIEdgeInsetsMake(-7,-7,-7,-7);
		descriptionField.text = @"請輸入描述及建議";
		descriptionField.textColor = [UIColor lightGrayColor];
		textViewPlaceholder = YES;
	} else {
		descriptionField.contentInset = UIEdgeInsetsMake(0,-7,-7,-7);
		[textView scrollRangeToVisible:NSMakeRange(0, 1)];
	}
	return YES;
}

- (void)setPlaceholder:(NSString *)s {
	descriptionField.contentInset = UIEdgeInsetsMake(-7,-7,-7,-7);
	if ([s isEqualToString:@""] || [s isEqualToString:@"請輸入描述及建議"]) {
		descriptionField.text = @"請輸入描述及建議";
		descriptionField.textColor = [UIColor lightGrayColor];
		textViewPlaceholder = YES;
	} else {
		descriptionField.text = s;
		descriptionField.textColor = [UIColor blackColor];
		textViewPlaceholder = NO;
	}
}

@end
