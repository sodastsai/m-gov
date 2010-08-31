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


@interface LocationSelectorViewController : UIViewController {

	MKMapView *mapView;
	UINavigationBar *titleBar;
	UISearchBar *searchBar;
	UILabel *selectedAddress;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UINavigationBar *titleBar;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UILabel *selectedAddress;

-(void) selectCancel;
-(void) selectDone;
-(void) updatingAddress:(CLLocationCoordinate2D)coordinate;

@end
