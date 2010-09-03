//
//  QueryViewController.h
//  MGOV
//
//  Created by iphone on 2010/9/2.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "typesViewController.h"

@interface QueryViewController : UIViewController <UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate, TypeSelectorDelegateProtocol> {
	NSString *selectedTypeTitle;
	NSInteger qid;
	MKMapView *mapView;
	UITableView *listView;
	UIButton *infoButton;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) IBOutlet UITableView *listView;
@property (retain, nonatomic) NSString *selectedTypeTitle;
@property (nonatomic) NSInteger qid;

- (IBAction)openPhotoDialogAction;
- (void)backToCurrentLocation;
- (void)modeChange;
- (void)typeSelect;

@end
