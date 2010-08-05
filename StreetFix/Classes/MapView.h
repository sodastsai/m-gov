//
//  MapView.h
//  StreetFix
//
//  Created by Eric Liou on 7/30/10.
//  Copyright 2010 SAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>


@interface MapView : UIViewController <MKMapViewDelegate>
{
	IBOutlet MKMapView *map;
}

@end
