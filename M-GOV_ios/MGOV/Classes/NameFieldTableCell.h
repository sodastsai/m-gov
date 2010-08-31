//
//  NameFieldTableCell.h
//  MGOV
//
//  Created by sodas on 2010/8/31.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTextFieldHeight 30.0
#define kTextFieldWidth 284.0

@interface NameFieldTableCell : UITableViewCell <UITextFieldDelegate> {
	UITextField *nameField;
}

@property (nonatomic, retain) UITextField *nameField;

@end
