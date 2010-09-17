//
//  DescriptionTableCell.h
//  MGOV
//
//  Created by sodas on 2010/8/31.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kDescriptionFieldCellHeight 160

@interface DescriptionTableCell : UITableViewCell <UITextViewDelegate> {
	UITextView *descriptionField;
	BOOL textViewPlaceholder;
}

@property (nonatomic, retain) UITextView *descriptionField;

+ (CGFloat)cellHeight;
- (void)setPlaceholder:(NSString *)s;

@end
