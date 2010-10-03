//
//  EditibleTextFieldCell.h
//  MGOV
//
//  Created by sodas on 2010/10/3.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditibleTextFieldCell : UITableViewCell <UITextFieldDelegate> {
	UILabel *title;
	UITextField *content;
}

@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UITextField *content;

@end
