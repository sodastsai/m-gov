/*
 * 
 * LocationSelectorTableCell.h
 * 2010/8/31
 * sodas
 * 
 * Cell which will show selected location and open location selector
 *
 * Copyright 2010 NTU CSIE Mobile & HCI Lab
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

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
