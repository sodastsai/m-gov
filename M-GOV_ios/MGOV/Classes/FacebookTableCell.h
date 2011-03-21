//
//  FacebookTableCell.h
//  MGOV
//
//  Created by Kate Hsiao on 3/20/11.
//  Copyright 2011 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kDescriptionFieldCellHeight 110

@interface FacebookTableCell : UITableViewCell <UITextViewDelegate> {
	UITextView *descriptionField;
	BOOL textViewPlaceholder;
}

@property (nonatomic, retain) UITextView *descriptionField;

+ (CGFloat)cellHeight;
- (void)setPlaceholder:(NSString *)s;

@end
