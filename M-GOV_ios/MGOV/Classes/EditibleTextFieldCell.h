//
//  EditibleTextFieldCell.h
//  MGOV
//
//  Created by sodas on 2010/10/3.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WritePrefDelegate.h"

@interface EditibleTextFieldCell : UITableViewCell <UITextFieldDelegate> {
	UILabel *titleField;
	UITextField *contentField;
	
	id<WritePrefDelegate> delegate;
	NSString *prefKey;
	NSString *originalValue;
}

@property (nonatomic, retain) UILabel *titleField;
@property (nonatomic, retain) UITextField *contentField;
@property (nonatomic, retain) id<WritePrefDelegate> delegate;
@property (nonatomic, retain) NSString *prefKey;
@property (nonatomic, retain) NSString *originalValue;

@end
