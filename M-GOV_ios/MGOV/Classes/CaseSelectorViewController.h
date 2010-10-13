//
//  CaseSelectorViewController.h
//  MGOV
//
//  Created by sodas on 2010/10/1.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryGoogleAppEngine.h"
#import "HybridViewController.h"
#import "CaseSelectorCell.h"

@interface CaseSelectorViewController : HybridViewController <QueryGAEReciever, HybridViewDelegate, HybridViewDataSource> {
	NSMutableArray *caseSource;
	// Data Range
	NSRange queryRange;
	// Case Viewer
	NSString *caseID;
	CaseViewerViewController *childViewController;
	UIView *informationBar;
	// Current condition
	id currentCondition;
	DataSourceGAEQueryTypes currentConditionType;
}

@property (nonatomic, retain) NSArray *caseSource;
@property (nonatomic, retain) id currentCondition;
@property (nonatomic) DataSourceGAEQueryTypes currentConditionType;

- (void)queryGAEwithConditonType:(DataSourceGAEQueryTypes)conditionType andCondition:(id)condition;
- (void)refreshDataSource;
- (NSUInteger)convertStatusStringToStatusCode:(NSString *)status;

@end
