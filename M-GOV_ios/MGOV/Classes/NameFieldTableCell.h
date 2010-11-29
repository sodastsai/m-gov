/*
 * 
 * NameFieldTableCell.h
 * 2010/8/31
 * sodas
 * 
 * Cell which let user type in thier name
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

#define kNameFieldCellHeight 44

@interface NameFieldTableCell : UITableViewCell <UITextFieldDelegate> {
	UITextField *nameField;
}

@property (nonatomic, retain) UITextField *nameField;

+ (CGFloat)cellHeight;
- (void)finishEditing;

@end
