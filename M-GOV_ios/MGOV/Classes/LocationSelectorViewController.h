//
//  LocationSelectorViewController.h
//  MGOV
//
//  Created by Shou on 2010/8/30.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "JSON.h"


@interface LocationSelectorViewController : UIViewController <UITableViewDataSource>{

	MKMapView *mapView;
	UITableView *topBar;
	UISearchBar *searchBar;
	UITableViewCell *searchBarCell;
	UITableViewCell *titleCell;
	UILabel *selectedAddress;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UITableView *topBar;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UITableViewCell *searchBarCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *titleCell;
@property (nonatomic, retain) IBOutlet UILabel *selectedAddress;

-(void) selectCancel;
-(void) selectDone;
-(void) updatingAddress:(CLLocationCoordinate2D)coordinate;

@end
