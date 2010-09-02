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

@end
