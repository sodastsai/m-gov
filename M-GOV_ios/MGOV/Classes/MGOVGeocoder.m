//
//  MGOVGeocoder.m
//  MGOV
//
//  Created by Shou on 2010/8/26.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "MGOVGeocoder.h"

static MGOVGeocoder *sharedVariable = nil;

@implementation MGOVGeocoder

@synthesize locationManager;

#pragma mark -
#pragma mark Singleton Methods

+ (MGOVGeocoder *)sharedVariable {
	@synchronized(self) {
		if(sharedVariable == nil){
			sharedVariable = [[self alloc] init];
		}
	}
	return sharedVariable;
}

+ (BOOL)isNetworkAvailable {  
	
    static BOOL checkNetwork = YES;  
	static BOOL _isNetworkAvailable = NO;  
    if (checkNetwork) { // Since checking the reachability of a host can be expensive, cache the result and perform the reachability check once.  
        checkNetwork = NO;  
        Boolean success;  
        const char *host_name = "google.com"; //pretty reliable :)  
        SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);  
        SCNetworkReachabilityFlags flags;  
        success = SCNetworkReachabilityGetFlags(reachability, &flags);  
        _isNetworkAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);  
        CFRelease(reachability);  
    } 
	
    return _isNetworkAvailable;  
}  


+ (NSString *) returnFullAddress:(CLLocationCoordinate2D)coordinate {
	// Use Google API to transform Latitude & Longitude to the corresponding address
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?latlng=%f,%f&sensor=true&language=zh-TW", coordinate.latitude, coordinate.longitude]];
	NSString *str = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[str JSONValue]];
	[url release];
	if (![[dict objectForKey:@"status"] isEqual:@"OK"]) return nil;
	str = [[[dict objectForKey:@"results"] objectAtIndex:0] objectForKey:@"formatted_address"];
	return [NSString stringWithFormat:@"%@", str];
}
+ (NSString *) returnRegion:(CLLocationCoordinate2D)coordinate {
	// Use Google API to transform Latitude & Longitude to the corresponding address  
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?latlng=%f,%f&sensor=true&language=zh-TW", coordinate.latitude, coordinate.longitude]];
	NSString *str = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	NSDictionary *dict = [str JSONValue];	
	[url release];
	if (![[dict objectForKey:@"status"] isEqual:@"OK"]) return nil;
	[str release];	
	return [NSString stringWithFormat:@"%@ %@", [[[[[dict objectForKey:@"results"] objectAtIndex:1] objectForKey:@"address_components" ] objectAtIndex:1] objectForKey:@"long_name"], [[[[[dict objectForKey:@"results"] objectAtIndex:1] objectForKey:@"address_components" ] objectAtIndex:0] objectForKey:@"long_name"]];
}

+ (NSString *) returnFullAddressWithCommaSperatedCoordinate:(NSString *)coord {
	return [MGOVGeocoder returnFullAddress:[MGOVGeocoder convertCommaSeperatedCoordinate:coord]];
}

+ (CLLocationCoordinate2D) convertCommaSeperatedCoordinate:(NSString *)coord {
	NSString *regEx1= @"^[0-9.]*";
	NSRange regexpResult = [coord rangeOfString:regEx1 options:NSRegularExpressionSearch];
	double longitude = [[coord substringWithRange:regexpResult] doubleValue];
	NSString *regEx2 = @"[0-9.]*$";
	regexpResult = [coord rangeOfString:regEx2 options:NSRegularExpressionSearch];
	double latitude = [[coord substringWithRange:regexpResult] doubleValue];
	CLLocationCoordinate2D finalCoord;
	finalCoord.longitude = longitude;
	finalCoord.latitude = latitude;
	return finalCoord;
}


@end
