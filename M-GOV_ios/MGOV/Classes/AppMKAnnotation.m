//
//  AppMKAnotation.m
//  MGOV
//
//  Created by sodas on 2010/8/27.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "AppMKAnnotation.h"

@implementation AppMKAnnotation

@synthesize coordinate;
@synthesize annotationSubtitle, annotationTitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord addressDictionary:(NSDictionary *)addressDictionary {
	
	if ((self = [super initWithCoordinate:coord addressDictionary:addressDictionary])) {
		// NOTE: self.coordinate is now different from super.coordinate, since we re-declare this property in header, 
		// self.coordinate and super.coordinate don't share same ivar anymore.
		self.coordinate = coord;
	}
	return self;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord andTitle:(NSString *)t andSubtitle:(NSString *)st {
	
	self = [super init];
	if (!self) return nil;
	
	coordinate = coord;
	annotationTitle = t;
	annotationSubtitle = st;
	
	return self;
}

#pragma mark -
#pragma mark MKAnnotation protocol

- (NSString *)title {
	return annotationTitle;
}

- (NSString *)subtitle {
	return annotationSubtitle;
}

@end
