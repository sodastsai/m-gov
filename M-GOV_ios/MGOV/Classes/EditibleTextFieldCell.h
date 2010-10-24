/*
 * 
 * EditibleTextFieldCell.h
 * 2010/10/3
 * sodas
 * 
 * UITableViewCell with editible text field
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
