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
#import "AppMKAnnotation.h"
#import "LoadingView.h"


@protocol LocationSelectorViewControllerDelegate

@required
- (void)userDidSelectCancel;
- (void)userDidSelectDone:(CLLocationCoordinate2D)coordinate;

@end


@interface LocationSelectorViewController : UIViewController <MKMapViewDelegate> {
	id<LocationSelectorViewControllerDelegate> delegate;
	MKMapView *mapView;
	UINavigationBar *titleBar;
	UILabel *selectedAddress;
	UILabel *barTitle;
	CLLocationCoordinate2D selectedCoord;
	UIToolbar *bottomBar;
	UIImage *caseImage;
	NSString *annotationAddress;
	LoadingView *loading;
}

@property (nonatomic, retain) id<LocationSelectorViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIToolbar *bottomBar;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UINavigationBar *titleBar;
@property (nonatomic, retain) IBOutlet UILabel *selectedAddress;
@property (nonatomic, retain) IBOutlet UILabel *barTitle;
@property (nonatomic) CLLocationCoordinate2D selectedCoord;
@property (nonatomic, retain) NSString *annotationAddress;
@property (nonatomic, retain) LoadingView *loading;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andImage:(UIImage *)image;
- (void) updatingAddress:(AppMKAnnotation *)annotation;
- (void) transformCoordinate;
- (void) showAnnotationCallout;


@end
