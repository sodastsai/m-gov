//
//  PrefViewController.h
//  MGOV
//
//  Created by sodas on 2010/10/2.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditibleTextFieldCell.h"
#import "WritePrefDelegate.h"
#import "PrefAccess.h"
#import "MyCaseViewController.h"

@interface PrefViewController : UITableViewController <WritePrefDelegate> {
	NSString *originalEmail;
}

@property (nonatomic, retain) NSString *originalEmail;

- (void)postScriptAfterSaveKey:(NSString *)key andObject:(id)value;
- (BOOL)preScriptBeforeSaveKey:(NSString *)key andObject:(id)value;
- (void)alertWhileFailToWriteWithTitle:(NSString *)alertTitle andContent:(NSString *)alertContent;

@end
