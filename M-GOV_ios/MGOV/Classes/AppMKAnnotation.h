/*
 * 
 * AppMKAnotation.h
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

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AppMKAnnotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *annotationTitle;
	NSString *annotationSubtitle;
	NSString *annotationID;
	NSString *annotationStatus;
}

@property (nonatomic, assign, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *annotationTitle;
@property (nonatomic, retain) NSString *annotationSubtitle;
@property (nonatomic, retain) NSString *annotationID;
@property (nonatomic, retain) NSString *annotationStatus;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coord andTitle:(NSString *)t andSubtitle:(NSString *)st;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coord andTitle:(NSString *)t andSubtitle:(NSString *)st andCaseID:(NSString *)ID andStatus:(NSString *)status;

- (NSString *)annotationID;
- (NSString *)annotationStatus;

@end
