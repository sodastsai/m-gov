//
//  QueryViewController.h
//  MGOV
//
//  Created by sodas on 2010/9/9.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseSelectorViewController.h"
#import "CaseViewerViewController.h"
#import "QueryGoogleAppEngine.h"
#import "CaseSelectorCell.h"
#import "MGOVGeocoder.h"
#import "typesViewController.h"
#import "ASIHTTPRequest.h"

#define kDataSectorSize 10

@interface QueryViewController : CaseSelectorViewController <HybridViewDelegate, HybridViewDataSource,  QueryGAEReciever, UIActionSheetDelegate, TypeSelectorDelegateProtocol> {
	NSArray *queryCaseSource;
	int queryTotalLength;
	
	NSInteger typeID;
	NSRange queryRange;
	
	UILabel *queryTypeLabel;
	UILabel *numberDisplayLabel;
	UIButton *nextButton;
	UIButton *lastButton;
	UIView *queryConditionBar;
	
	NSString *caseID;
	UIViewController *childViewController;
}

@property (retain, nonatomic) NSArray *queryCaseSource;
@property (nonatomic) NSInteger typeID;
@property int queryTotalLength;

- (void)setQueryCondition;
- (void)nextCase;
- (void)lastCase;
- (void)queryGAEwithConditonType:(DataSourceGAEQueryTypes)conditionType andCondition:(id)condition;

@end
