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

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord andTitle:(NSString *)t andSubtitle:(NSString *)st {
	if (self = [super init]) {
		coordinate = coord;
		annotationTitle = t;
		annotationSubtitle = st;		
	}
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
