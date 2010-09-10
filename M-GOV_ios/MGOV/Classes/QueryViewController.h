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

@interface QueryViewController : CaseSelectorViewController <CaseSelectorDelegate, CaseSelectorDataSource,  QueryGAEReciever, UIActionSheetDelegate> {
	NSArray *queryCaseSource;
}

@property (retain, nonatomic) NSArray *queryCaseSource;

- (void)setQueryCondition;

@end
