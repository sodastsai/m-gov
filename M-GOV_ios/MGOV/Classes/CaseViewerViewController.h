/*
 * 
 * CaseViewerViewController.h
 * 2010/9/2
 * sodas
 * 
 * The main layout of Case Viewer which shows detail info of a case
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
#import <QuartzCore/QuartzCore.h>
#import "LocationSelectorTableCell.h"
#import "QueryGoogleAppEngine.h"
#import "ASIHTTPRequest.h"

@interface CaseViewerViewController : UITableViewController <QueryGAEReciever> {
	NSString *query_caseID;
	NSDictionary *caseData;
	UIImageView *photoView;
	BOOL resetFlag;
	
	LocationSelectorTableCell *locationCell;
}

@property (nonatomic, retain) NSDictionary *caseData;
@property (nonatomic, retain) NSString *query_caseID;
@property (nonatomic) BOOL resetFlag;

- (void)startToQueryCase;
- (void)cleanTableView;

@end
