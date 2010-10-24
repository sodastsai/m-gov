/*
 * 
 * TypesViewController.h
 * 2010/8/11
 * sodas
 * 
 * A table which will provide all case types
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
#import "TypeSelectorDelegateProtocol.h"

@interface TypesViewController : UITableViewController {
	// Record Question Type
	NSInteger finalSectionId;
	NSInteger finalTypeId;
	id<TypeSelectorDelegateProtocol> delegate;
	
	// Data source
	NSDictionary *sectionDict;
	NSDictionary *typeDict;
	NSDictionary *detailDict;
}

@property (nonatomic, retain) id<TypeSelectorDelegateProtocol> delegate;

@end
