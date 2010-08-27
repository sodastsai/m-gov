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

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord {
	return [self initWithCoordinate:coord andTitle:nil andSubtitle:nil];
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord andTitle:(NSString *)t {
	return [self initWithCoordinate:coord andTitle:t andSubtitle:nil];
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
