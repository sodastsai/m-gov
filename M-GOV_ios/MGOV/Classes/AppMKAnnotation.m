/*
 * 
 * AppMKAnotation.m
 * 2010/8/27
 * sodas
 * 
 * implementation of map annotation
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

#import "AppMKAnnotation.h"

@implementation AppMKAnnotation

@synthesize coordinate;
@synthesize annotationSubtitle, annotationTitle;
@synthesize annotationID;
@synthesize annotationStatus;

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

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord andTitle:(NSString *)t andSubtitle:(NSString *)st andCaseID:(NSString *)ID andStatus:(NSString *)status{
	if (self = [super init]) {
		self.coordinate = coord;
		self.annotationTitle = t;
		self.annotationSubtitle = st;
		self.annotationID = ID;
		self.annotationStatus = status;
	}
	return self;
}

- (NSString *)annotationID {
	return annotationID;
}

- (NSString *)annotationStatus {
	return annotationStatus;
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
