//
//  QueryViewController.h
//  MGOV
//
//  Created by Shou on 2010/9/2.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "typesViewController.h"
#import "CaseDisplayView.h"
#import "CaseDisplayTableCell.h"

@interface QueryViewController : UIViewController <UIActionSheetDelegate, TypeSelectorDelegateProtocol, CaseDisplayDelegate, UITableViewDataSource> {
	NSString *selectedTypeTitle;
	NSInteger qid;
	CaseDisplayView *caseDisplayView;
	UIBarButtonItem *caseTypeSelector;
	
	NSArray *caseData;
}

@property (retain, nonatomic) NSString *selectedTypeTitle;
@property (nonatomic) NSInteger qid;

- (IBAction)openSearchDialogAction;
- (void)backToCurrentLocation;
- (void)modeChange;
- (void)typeSelect;

@end
