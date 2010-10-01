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

@interface CaseSelectorViewController : HybridViewController <HybridViewDelegate, HybridViewDataSource> {
	NSArray *caseSource;
	// Data Range
	NSRange queryRange;
	// Case Viewer
	NSString *caseID;
	UIViewController *childViewController;
	UIView *informationBar;
}

@property (nonatomic, retain) NSArray *caseSource;

- (void)queryGAEwithConditonType:(DataSourceGAEQueryTypes)conditionType andCondition:(id)condition;

@end
