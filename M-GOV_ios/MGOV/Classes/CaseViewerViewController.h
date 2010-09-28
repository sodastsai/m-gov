//
//  CaseViewerViewController.h
//  MGOV
//
//  Created by sodas on 2010/9/2.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JSON.h"
#import "LocationSelectorTableCell.h"
#import "QueryGoogleAppEngine.h"

@interface CaseViewerViewController : UITableViewController <QueryGAEReciever> {
	NSString *caseID;
	NSDictionary *caseData;
	UIImageView *photoView;
	
	LocationSelectorTableCell *locationCell;
}

@property (nonatomic, retain) NSDictionary *caseData;

- (id)initWithCaseID:(NSString *)cid;

@end
