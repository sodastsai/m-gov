//
//  AppMKAnotation.h
//  MGOV
//
//  Created by sodas on 2010/8/27.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AppMKAnnotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *annotationTitle;
	NSString *annotationSubtitle;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coord andTitle:(NSString *)t;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coord andTitle:(NSString *)t andSubtitle:(NSString *)st;

@end
