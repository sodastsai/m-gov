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

@interface QueryViewController : CaseSelectorViewController <QueryGAEReciever, UIActionSheetDelegate, TypeSelectorDelegateProtocol> {
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

@end
