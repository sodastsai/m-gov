/*
 * 
 * DetailViewController.h
 * 2010/8/11
 * sodas
 * 
 * A table which will provide detail info of each case type
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

@interface DetailViewController : UITableViewController {
	NSInteger finalSectionId;
	NSInteger finalTypeId;
	NSInteger finalDetailId;
	id<TypeSelectorDelegateProtocol> delegate;
	
	// Data source
	NSDictionary *detailDict;
	NSDictionary *secondDetailDict;
}

@property (nonatomic) NSInteger finalSectionId;
@property (nonatomic) NSInteger finalTypeId;
@property (nonatomic) NSInteger finalDetailId;
@property (nonatomic, retain) id<TypeSelectorDelegateProtocol> delegate;

@end
