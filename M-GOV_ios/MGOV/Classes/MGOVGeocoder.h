//
//  MGOVGeocoder.h
//  MGOV
//
//  Created by Shou on 2010/8/26.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"

@interface MGOVGeocoder : NSObject {
	
	CLLocationManager *locationManager;
	
}

@property (nonatomic, retain) CLLocationManager *locationManager;

+ (MGOVGeocoder *)sharedVariable;
+ (NSString *) returnFullAddress:(CLLocationCoordinate2D)coordinate;
+ (NSString *) returnRegion:(CLLocationCoordinate2D)coordinate;

@end
