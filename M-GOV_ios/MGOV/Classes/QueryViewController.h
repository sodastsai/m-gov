/*
 * 
 * QueryViewController.h
 * 2010/9/9
 * sodas
 * 
 * The Main View Controller of Query Case
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
#import "CaseSelectorViewController.h"
#import "CaseViewerViewController.h"
#import "QueryGoogleAppEngine.h"
#import "CaseSelectorCell.h"
#import "MGOVGeocoder.h"
#import "TypesViewController.h"
#import "ASIHTTPRequest.h"

#define kDataSectorSize 10

@interface QueryViewController : CaseSelectorViewController <UIActionSheetDelegate, TypeSelectorDelegateProtocol> {
	int queryTotalLength;
	
	NSInteger typeID;
	
	// Query Condition in Information Bar
	UILabel *queryTypeLabel;
	UILabel *numberDisplayLabel;
	UIButton *nextButton;
	UIButton *lastButton;
}

@property (nonatomic) NSInteger typeID;
@property int queryTotalLength;

- (void)setQueryCondition;
- (void)nextCase;
- (void)lastCase;
- (void)queryGAEwithConditonType:(DataSourceGAEQueryTypes)conditionType andCondition:(id)condition;
- (void)queryAfterSetRangeAndType;

@end
