/*
 * 
 * MGOVGeocoder.h
 * 2010/8/26
 * Shou
 * 
 * Google Map API Geocoder Service
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

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "JSONKit.h"

@interface MGOVGeocoder : NSObject {
	CLLocationManager *locationManager;
}

@property (nonatomic, retain) CLLocationManager *locationManager;

+ (MGOVGeocoder *)sharedVariable;
+ (NSString *) returnFullAddress:(CLLocationCoordinate2D)coordinate;
+ (NSArray *) returnRegion:(CLLocationCoordinate2D)coordinate;
+ (NSString *) returnFullAddressWithCommaSperatedCoordinate:(NSString *)coord;
+ (CLLocationCoordinate2D) convertCommaSeperatedCoordinate:(NSString *)coord;

@end
