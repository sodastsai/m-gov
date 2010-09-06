//
//  LocationSelectorTableCell.h
//  MGOV
//
//  Created by sodas on 2010/8/31.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MGOVGeocoder.h"
#import "AppMKAnnotation.h"
#import "LocationSelectorViewController.h"

@protocol LocationSelectorTableCellDelegate

@required
- (void)openLocationSelector;

@end


@interface LocationSelectorTableCell : UITableViewCell {
	CGFloat mapViewHeight;
	MKMapView *mapView;
	AppMKAnnotation *casePlace;
	id<LocationSelectorTableCellDelegate> delegate;
	SEL mapButtonAction;
	id mapButtonTarget;
	CLLocationCoordinate2D mapCoordinate;
}

@property (retain, nonatomic) id<LocationSelectorTableCellDelegate> delegate;

- (id)initWithHeight:(CGFloat)h andCoordinate:(CLLocationCoordinate2D)coord actionTarget:(id)perfomer setAction:(SEL)action;
- (void)updatingCoordinate:(CLLocationCoordinate2D)coordinate;

@end
