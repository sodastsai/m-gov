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
#import "AppClassExtension.h"

@interface CaseViewerViewController : UITableViewController {
	NSString *ID;
	NSDictionary *caseData;
	UIImageView *photoView;
	
	LocationSelectorTableCell *locationCell;
}

- (id)initWithCaseID:(NSString *)caseID;

@end
