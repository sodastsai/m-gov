//
//  QueryViewController.h
//  MGOV
//
//  Created by Shou on 2010/8/25.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TypeSelectorDelegateProtocol.h"
#import "AppMKAnnotation.h"
#import "LocationSelectorViewController.h"
#import "typesViewController.h"
#import "LocationSelectorTableCell.h"
#import "LocationSelectorViewController.h"

@interface QueryViewController : UITableViewController <TypeSelectorDelegateProtocol, LocationSelectorTableCellDelegate, LocationSelectorViewControllerDelegate> {
	NSString *selectedTypeTitle;
	NSInteger qid;
	
	// Component Cells
	LocationSelectorTableCell *locationCell;
}

@property (retain, nonatomic) NSString *selectedTypeTitle;
@property (nonatomic) NSInteger qid;

- (BOOL)submitQuery;

@end
