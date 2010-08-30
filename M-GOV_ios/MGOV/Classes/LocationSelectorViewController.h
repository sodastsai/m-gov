//
//  LocationSelectorViewController.h
//  MGOV
//
//  Created by iphone on 2010/8/30.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface LocationSelectorViewController : UIViewController {

	MKMapView *mapView;
	UINavigationBar *navigationBar;
	UISearchBar *searchBar;
	UINavigationItem *backButton;
	UIBarButtonItem *test;
	
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UINavigationItem *backButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *test;


@end
