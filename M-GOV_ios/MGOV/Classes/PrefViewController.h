//
//  PrefViewController.h
//  MGOV
//
//  Created by sodas on 2010/10/2.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditibleTextFieldCell.h"

@interface PrefViewController : UITableViewController {
	NSMutableDictionary *dictUserInformation;
}

@property (nonatomic, retain) NSMutableDictionary *dictUserInformation;

@end
