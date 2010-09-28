//
//  QueryGoogleAppEngine.h
//  MGOV
//
//  Created by sodas on 2010/9/9.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "ASIHTTPRequest.h"
#import "LoadingOverlayView.h"

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
	
	LoadingOverlayView *indicatorView;
	UIView *indicatorTargetView;
}

@property (nonatomic) DataSourceGAEQueryTypes conditionType;
@property (nonatomic, readonly) DataSourceGAEReturnTypes returnType;
@property (retain,nonatomic) NSString *queryCondition;
@property (retain,nonatomic) NSDictionary *queryMultiConditions;
@property (nonatomic) NSRange resultRange;
@property (retain,nonatomic) id resultTarget;
@property (nonatomic, retain) UIView *indicatorTargetView;

+ (NSString *)generateMapQueryConditionFromRegion:(MKCoordinateRegion)mapRegion;
- (NSString *)convertConditionTypeToString;
- (NSString *)convertNSRangeToString;
- (NSURL *)generateSingleConditionURL;
- (NSURL *)generateMultiConditionsURL;

- (BOOL)startQuery;
+ (id)requestQuery;

@end
