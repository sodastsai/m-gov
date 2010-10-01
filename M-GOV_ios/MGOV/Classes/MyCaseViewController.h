//
//  MyCaseViewController.h
//  MGOV
//
//  Created by sodas on 2010/9/9.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseSelectorViewController.h"
#import "CaseAddViewController.h"
#import "QueryGoogleAppEngine.h"
#import "CaseSelectorCell.h"
#import "CaseViewerViewController.h"
#import "AppMKAnnotation.h"


@interface MyCaseViewController : CaseSelectorViewController <CaseAddViewControllerDelegate, HybridViewDelegate, HybridViewDataSource,  QueryGAEReciever, MKMapViewDelegate> {
	NSArray *myCaseSource;
	NSDictionary *dictUserInformation;
	UIView *myCaseFilter;
	
	NSString *caseID;
	UIViewController *childViewController;
}

@property (nonatomic, retain) NSArray *myCaseSource;
@property (nonatomic, retain) NSDictionary *dictUserInformation;

- (void)addCase;
- (void)queryGAEwithConditonType:(DataSourceGAEQueryTypes)conditionType andCondition:(id)condition;

@end
