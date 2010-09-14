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
@synthesize caseID;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord {
	return [self initWithCoordinate:coord andTitle:nil andSubtitle:nil];
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord andTitle:(NSString *)t andSubtitle:(NSString *)st {
	if (self = [super init]) {
		coordinate = coord;
		annotationTitle = t;
		annotationSubtitle = st;		
	}
	return self;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord andTitle:(NSString *)t andSubtitle:(NSString *)st andCaseID:(NSString *)ID {
	if (self = [super init]) {
		coordinate = coord;
		annotationTitle = t;
		annotationSubtitle = st;
		annotationID = ID;
	}
	return self;
}

- (NSString *)annotationID {
	return annotationID;
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
