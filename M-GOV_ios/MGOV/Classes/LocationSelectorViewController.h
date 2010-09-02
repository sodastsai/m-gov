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

@protocol LocationSelectorViewControllerDelegate

@required
- (void)userDidSelectCancel;
- (void)userDidSelectDone:(CLLocationCoordinate2D)coordinate;

@end


@interface LocationSelectorViewController : UIViewController <MKMapViewDelegate> {
	id<LocationSelectorViewControllerDelegate> delegate;
	MKMapView *mapView;
	UINavigationBar *titleBar;
	UILabel *selectedAddress, *barTitle;
	CLLocationCoordinate2D selectedCoord;
	UIToolbar *bottomBar;
}
@property (nonatomic, retain) id<LocationSelectorViewControllerDelegate> delegate;

@property (nonatomic, retain) IBOutlet UIToolbar *bottomBar;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UINavigationBar *titleBar;
@property (nonatomic, retain) IBOutlet UILabel *selectedAddress, *barTitle;
@property (nonatomic) CLLocationCoordinate2D selectedCoord;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (void) updatingAddress:(id <MKAnnotation>)annotation;
- (void) transformCoordinate;


@end
