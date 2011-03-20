/*
 * 
 * QueryGoogleAppEngine.h
 * 2010/9/9
 * sodas
 * 
 * The connector of Google App Engine service
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
#import <MapKit/MapKit.h>
#import "ASIHTTPRequest.h"
#import "LoadingOverlayView.h"
#import "NetworkChecking.h"
#import "JSONKit.h"

typedef enum {
	DataSourceGAEQueryByID,
	DataSourceGAEQueryByEmail,
	DataSourceGAEQueryByCoordinate,
	DataSourceGAEQueryByType,
	DataSourceGAEQueryByStatus,
	DataSourceGAEQueryByMultiConditons,
} DataSourceGAEQueryTypes;

typedef enum {
	DataSourceGAEReturnByNSArray,
	DataSourceGAEReturnByNSDictionary,
	DataSourceGAEReturnTypeUnkonwn,
	DataSourceGAEReturnNotFound,
	DataSourceGARReturnEmpty,
} DataSourceGAEReturnTypes;


@protocol QueryGAEReciever

@required
- (void)recieveQueryResultType:(DataSourceGAEReturnTypes)type withResult:(id)result;

@end


@interface QueryGoogleAppEngine : NSObject <ASIHTTPRequestDelegate> {
	// User Arguments
	DataSourceGAEQueryTypes conditionType;
	DataSourceGAEReturnTypes returnType;
	NSString *queryCondition;
	NSDictionary *queryMultiConditions;
	NSRange resultRange;
	id<QueryGAEReciever> resultTarget;
	
	// Query elements
	NSString *queryBaseURL;
	NSURL *queryURL;
	NSString *queryType;
	id queryResult;
	
	// Loading View
	LoadingOverlayView *indicatorView;
	UIView *indicatorTargetView;
}

@property (nonatomic) DataSourceGAEQueryTypes conditionType;
@property (nonatomic, readonly) DataSourceGAEReturnTypes returnType;
@property (retain,nonatomic) NSString *queryCondition;
@property (retain,nonatomic) NSDictionary *queryMultiConditions;
@property (nonatomic) NSRange resultRange;
@property (retain,nonatomic) id<QueryGAEReciever> resultTarget;
@property (nonatomic, retain) UIView *indicatorTargetView;

+ (NSString *)generateMapQueryConditionFromRegion:(MKCoordinateRegion)mapRegion;
+ (NSString *)generateORcombinedCondition:(NSArray *)ORconditions;

- (NSString *)convertConditionTypeToString;
- (NSString *)convertNSRangeToString;
- (NSURL *)generateSingleConditionURL;
- (NSURL *)generateMultiConditionsURL;

- (BOOL)startQuery;
+ (id)requestQuery;

@end
