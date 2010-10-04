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
#import "PrefReader.h"
#import "MyCaseViewController.h"

@interface PrefViewController : UITableViewController <WritePrefDelegate> {
	NSMutableDictionary *prefDict;
	NSString *plistPathInAppDocuments;
}

@property (nonatomic, retain) NSString *plistPathInAppDocuments;

- (void)postScriptAfterSaveKey:(NSString *)key;
- (BOOL)preScriptBeforeSaveKey:(NSString *)key;

@end
