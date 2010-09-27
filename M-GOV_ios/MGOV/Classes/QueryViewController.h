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
#import "LoadingView.h"

#define kDataSectorSize 10

@interface QueryViewController : CaseSelectorViewController <CaseSelectorDelegate, CaseSelectorDataSource,  QueryGAEReciever, UIActionSheetDelegate, TypeSelectorDelegateProtocol> {
	NSArray *queryCaseSource;
	int queryTotalLength;
	LoadingView *loading;
	
	NSInteger typeID;
	NSRange queryRange;
	UILabel *queryTypeLabel;
	UILabel *numberDisplayLabel;
	UIView *queryConditionBar;
}

@property (retain, nonatomic) NSArray *queryCaseSource;
@property (nonatomic) NSInteger typeID;
@property int queryTotalLength;

- (void)setQueryCondition;
- (void)nextCase;
- (void)lastCase;
- (void)setLoadingView;

@end
