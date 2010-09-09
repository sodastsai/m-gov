//
//  QueryGoogleAppEngine.m
//  MGOV
//
//  Created by sodas on 2010/9/9.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "QueryGoogleAppEngine.h"

@implementation QueryGoogleAppEngine

@synthesize conditionType, returnType, queryCondition, queryConditions, resultRange, resultTarget;

#pragma mark -
#pragma mark Action

- (BOOL)startQuery {
	// Set condition
	if (queryCondition!=nil && queryConditions==nil) {
		queryURL = [self generateSingleConditionURL];
	} else if (queryConditions!=nil && queryCondition==nil) {
		
	} else {
		return NO;
	}
	
	// GO
	NSString *str = [[NSString alloc] initWithContentsOfURL:queryURL encoding:NSUTF8StringEncoding error:nil];
	// TODO: ask for ggm: Fail return
	
	if (returnType == DataSourceGAEReturnByNSArray) {
		queryResult = [[[NSArray alloc] initWithArray:[str JSONValue]] autorelease];
	} else if (returnType == DataSourceGAEReturnByNSDictionary) {
		queryResult = [[[NSDictionary alloc] initWithDictionary:[str JSONValue]] autorelease];
	} else {
		queryResult = str;
	}
	
	[resultTarget recieveQueryResultType:returnType withResult:queryResult];
	return YES;
}

#pragma mark -
#pragma mark Parse Query Conditions

- (NSString *)convertConditionTypeToString {
	if (conditionType == DataSourceGAEQueryByID) return @"get/id";
	else if (conditionType == DataSourceGAEQueryByType) return @"query/typeid";
	else if (conditionType == DataSourceGAEQueryByEmail) return @"query/email";
	else if (conditionType == DataSourceGAEQueryByCoordinate) return @"query/coordinate";
	else if (conditionType == DataSourceGAEQueryByStatus) return @"query/status";
	
	return nil;
}

- (NSString *)convertNSRangeToString {
	return [NSString stringWithFormat:@"%d/%d", resultRange.location, resultRange.length];
}

- (NSURL *)generateSingleConditionURL {
	// Set Type
	NSString* restURL = [NSString stringWithFormat:@"%@/", [self convertConditionTypeToString]];
	// Set condition
	restURL = [NSString stringWithFormat:@"%@%@/", restURL, queryCondition];
	// Set Range
	if (conditionType!=DataSourceGAEQueryByID && resultRange.length!=0) restURL = [NSString stringWithFormat:@"%@%@/", restURL, [self convertNSRangeToString]];
	
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", queryBaseURL, restURL]];
}

- (NSURL *)generateMultiConditionsURL {
	// NSDictionary to String
	return nil;
}

#pragma mark -
#pragma mark Provider Lifecycle

- (id)init {
	if (self = [super init]) {
		queryBaseURL = @"http://ntu-ecoliving.appspot.com/ecoliving/";
	}
	return self;
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
}

- (void)dealloc {
    [super dealloc];
}

@end
