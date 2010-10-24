/*
 * 
 * LocationSelectorViewController.h
 * 2010/8/30
 * Shou
 * 
 * Address Selector with MapView
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
#import "AppMKAnnotation.h"

@protocol LocationSelectorViewControllerDelegate

@required
- (void)userDidSelectCancel;
- (void)userDidSelectDone:(CLLocationCoordinate2D)coordinate;

@end

@interface LocationSelectorViewController : UIViewController <MKMapViewDelegate> {
	id<LocationSelectorViewControllerDelegate> delegate;
	MKMapView *mapView;
	CLLocationCoordinate2D selectedCoord;
	UIToolbar *bottomBar;
	UIImage *caseImage;
	NSString *annotationAddress;
}

@property (nonatomic, retain) id<LocationSelectorViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIToolbar *bottomBar;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocationCoordinate2D selectedCoord;
@property (nonatomic, retain) NSString *annotationAddress;
@property (nonatomic, retain) UIImage *caseImage;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andImage:(UIImage *)image;
- (void) updatingAddress:(AppMKAnnotation *)annotation;
- (void) transformCoordinate;
- (void) showAnnotationCallout;

@end
