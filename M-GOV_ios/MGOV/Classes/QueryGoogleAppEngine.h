//
//  QueryGoogleAppEngine.h
//  MGOV
//
//  Created by sodas on 2010/9/9.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	DataSourceGAEQueryByID,
	DataSourceGAEQueryByEmail,
	DataSourceGAEQueryByCoordinate,
	DataSourceGAEQueryByType,
	DataSourceGAEQueryByStatus,
} DataSourceGAEQueryTypes;

typedef enum {
	DataSourceGAEReturnByNSArray,
	DataSourceGAEReturnByNSDictionary,
	DataSourceGAEReturnByNSString,
} DataSourceGAEReturnTypes;

@protocol QueryGAEReciever

- (void)recieveQueryResultType:(DataSourceGAEReturnTypes)type withResult:(id)result;

@end


@interface QueryGoogleAppEngine : NSObject {
	// User Arguments
	DataSourceGAEQueryTypes conditionType;
	DataSourceGAEReturnTypes returnType;
	NSString *queryCondition;
	NSDictionary *queryConditions;
	NSRange resultRange;
	id<QueryGAEReciever> resultTarget;
	
	// Query elements
	NSString *queryBaseURL;
	NSURL *queryURL;
	NSString *queryType;
	id queryResult;
}

@property (nonatomic) DataSourceGAEQueryTypes conditionType;
@property (nonatomic) DataSourceGAEReturnTypes returnType;
@property (retain,nonatomic) NSString *queryCondition;
@property (retain,nonatomic) NSDictionary *queryConditions;
@property (nonatomic) NSRange resultRange;
@property (retain,nonatomic) id resultTarget;

- (NSString *)convertConditionTypeToString;
- (NSString *)convertNSRangeToString;
- (NSURL *)generateSingleConditionURL;
- (NSURL *)generateMultiConditionsURL;

- (BOOL)startQuery;

@end
