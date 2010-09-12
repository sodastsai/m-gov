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
#import "AppClassExtension.h"

@interface MyCaseViewController : CaseSelectorViewController <CaseAddViewControllerDelegate, CaseSelectorDelegate, CaseSelectorDataSource,  QueryGAEReciever> {
	NSArray *myCaseSource;
}

@property (nonatomic, retain) NSArray *myCaseSource;

- (void)addCase;

@end
