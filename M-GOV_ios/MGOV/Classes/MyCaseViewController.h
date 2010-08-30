//
//  MyCaseViewController.h
//  MGOV
//
//  Created by Shou 2010/8/24.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseAddViewController.h"

@interface MyCaseViewController : UITableViewController {
	NSString *userEmail;
	UITableViewCell *firstRunCell;
}

@property (retain, nonatomic) IBOutlet UITableViewCell *firstRunCell;

- (void) addCase;

@end
