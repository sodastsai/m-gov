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

+ (NSString *) returnFullAddress:(CLLocationCoordinate2D)coordinate {
	// Use Google API to transform Latitude & Longitude to the corresponding address
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?latlng=%f,%f&sensor=true&language=zh-TW", coordinate.latitude, coordinate.longitude]];
	NSData *data = [[NSData alloc] initWithContentsOfURL:url];
	NSDictionary *dict = [[CJSONDeserializer deserializer] deserialize:data error:nil];
	[url release];
	[data release];
	if (![[dict objectForKey:@"status"] isEqual:@"OK"]) return nil;
	return [NSString stringWithFormat:@"%@", [[[dict objectForKey:@"results"] objectAtIndex:0] objectForKey:@"formatted_address"]];
}
+ (NSArray *) returnRegion:(CLLocationCoordinate2D)coordinate {
	// Use Google API to transform Latitude & Longitude to the corresponding address  
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?latlng=%f,%f&sensor=true&language=zh-TW", coordinate.latitude, coordinate.longitude]];
	NSData *data = [[NSData alloc] initWithContentsOfURL:url];
	NSDictionary *dict = [[CJSONDeserializer deserializer] deserialize:data error:nil];	
	[url release];
	[data release];
	if (![[dict objectForKey:@"status"] isEqual:@"OK"]) return nil;
	NSArray *array = [NSArray arrayWithObjects:[[[[[dict objectForKey:@"results"] objectAtIndex:1] objectForKey:@"address_components" ] objectAtIndex:1] objectForKey:@"long_name"], [[[[[dict objectForKey:@"results"] objectAtIndex:1] objectForKey:@"address_components" ] objectAtIndex:0] objectForKey:@"long_name"], nil];
	
	dict = nil;
	return array;
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
	
	regEx1 = nil;
	regEx2 = nil;
	return finalCoord;
}


@end
