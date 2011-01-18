/*
 * 
 * PrefViewController.h
 * 2010/10/2
 * sodas
 * 
 * Preference table view
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

#import <UIKit/UIKit.h>
#import "EditibleTextFieldCell.h"
#import "WritePrefDelegate.h"
#import "MyCaseViewController.h"
#import "IconCell.h"
#import "GoogleAnalytics.h"

@interface PrefViewController : UITableViewController <WritePrefDelegate> {
	NSString *originalEmail;
}

@property (nonatomic, retain) NSString *originalEmail;

- (void)postScriptAfterSaveKey:(NSString *)key andObject:(id)value;
- (BOOL)preScriptBeforeSaveKey:(NSString *)key andObject:(id)value;
- (void)alertWhileFailToWriteWithTitle:(NSString *)alertTitle andContent:(NSString *)alertContent;

@end
