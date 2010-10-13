//
//  QueryGoogleAppEngine.m
//  MGOV
//
//  Created by sodas on 2010/9/9.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "QueryGoogleAppEngine.h"

@implementation QueryGoogleAppEngine

@synthesize conditionType, queryCondition, queryMultiConditions, resultRange, resultTarget, returnType, indicatorTargetView;

#pragma mark -
#pragma mark Action

- (BOOL)startQuery {
	[NetWorkChecking checkNetwork];
	indicatorView = [[LoadingOverlayView alloc] initAtViewCenter:indicatorTargetView];
	[indicatorTargetView addSubview:indicatorView];
	[indicatorView startedLoad];
	// Set condition
	if (conditionType!=DataSourceGAEQueryByMultiConditons) {
		// Single conditon
		queryURL = [self generateSingleConditionURL];
	} else {
		// Multi conditions
		queryURL = [self generateMultiConditionsURL];
	}
	
	// GO with ASIHttpRequest
	// TODO: ask for ggm: Fail return
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:queryURL];
	[request setDelegate:self];
	[request setTimeOutSeconds:60];
	[request startAsynchronous];
	[self retain];
	return YES;
}




#pragma mark -
#pragma mark ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request {
	NSString *resultString = [request responseString];
	NSData *resultData = [request responseData];
	if ([resultString isEqualToString:@"<html><head>\n<meta http-equiv=\"content-type\" content=\"text/html;charset=utf-8\">\n<title>404 NOT_FOUND</title>\n</head>\n<body text=#000000 bgcolor=#ffffff>\n<h1>Error: NOT_FOUND</h1>\n</body></html>"]) {
		returnType = DataSourceGAEReturnNotFound;
		queryResult = nil;
	} else {
		queryResult = [[CJSONDeserializer deserializer] deserialize:resultData error:nil];
		// Set type
		if ([queryResult isKindOfClass:[NSDictionary class]]) {
			if ([[queryResult valueForKey:@"error"] isEqualToString:@"null"]) {
				returnType = DataSourceGARReturnEmpty;
				queryResult = nil;
			} else {
				returnType = DataSourceGAEReturnByNSDictionary;
			}
		} else if ([queryResult isKindOfClass:[NSArray class]]) {
			returnType = DataSourceGAEReturnByNSArray;
		} else {
			returnType = DataSourceGAEReturnTypeUnkonwn;
		}
	}
	// return to Data source
	[resultTarget recieveQueryResultType:returnType withResult:queryResult];
	[indicatorView finishedLoad];
	[indicatorView removeFromSuperview];
	[indicatorView release];
	[self release];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	queryResult = nil;
	returnType = DataSourceGAEReturnTypeUnkonwn;
	[resultTarget recieveQueryResultType:returnType withResult:queryResult];
	[indicatorView finishedLoad];
	[indicatorView removeFromSuperview];
	[indicatorView release];
	[self release];
}

#pragma mark -
#pragma mark Parse Query Conditions

- (NSString *)convertConditionTypeToString {
	if (conditionType == DataSourceGAEQueryByID) return @"czone/get_id";
	else if (conditionType == DataSourceGAEQueryByType) return @"czone/query/typeid";
	else if (conditionType == DataSourceGAEQueryByEmail) return @"case/query/email";
	else if (conditionType == DataSourceGAEQueryByCoordinate) return @"czone/query/coordinates";
	else if (conditionType == DataSourceGAEQueryByStatus) return @"case/query/status";
	
	return nil;
}

- (NSString *)convertNSRangeToString {
	return [NSString stringWithFormat:@"%d/%d", resultRange.location, resultRange.location+resultRange.length-1];
}

- (NSURL *)generateSingleConditionURL {
	// Set Type
	NSString* restURL = [NSString stringWithFormat:@"%@/", [self convertConditionTypeToString]];
	// Set condition
	restURL = [NSString stringWithFormat:@"%@%@/", restURL, queryCondition];
	// Set Range
	if (conditionType!=DataSourceGAEQueryByID && resultRange.length!=0) restURL = [NSString stringWithFormat:@"%@%@/", restURL, [self convertNSRangeToString]];
	else if (conditionType!=DataSourceGAEQueryByID && resultRange.length==0) restURL = [NSString stringWithFormat:@"%@0/10000/", restURL]; 
	
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", queryBaseURL, restURL]];
}

- (NSURL *)generateMultiConditionsURL {
	// NSDictionary to String
	NSString *queryEmail = [queryMultiConditions valueForKey:@"DataSourceGAEQueryByEmail"];
	NSString *queryCoord = [queryMultiConditions valueForKey:@"DataSourceGAEQueryByCoordinate"];
	NSString *queryTypes = [queryMultiConditions valueForKey:@"DataSourceGAEQueryByType"];
	NSString *queryStatus = [queryMultiConditions valueForKey:@"DataSourceGAEQueryByStatus"];
	
	NSString *restURL;
	if (queryEmail != nil) restURL = @"case/query/";
	else restURL = @"czone/query/";
		
	BOOL isFirstCondition = YES;
	// Attach Condition Name
	if (queryCoord!=nil) {
		if (!isFirstCondition) restURL = [restURL stringByAppendingString:@"&"];
		restURL = [restURL stringByAppendingString:@"coordinates"];
		isFirstCondition = NO;
	}
	if (queryEmail!=nil) {
		if (!isFirstCondition) restURL = [restURL stringByAppendingString:@"&"];
		restURL = [restURL stringByAppendingString:@"email"];
		isFirstCondition = NO;
	}
	if (queryTypes!=nil) {
		if (!isFirstCondition) restURL = [restURL stringByAppendingString:@"&"];
		restURL = [restURL stringByAppendingString:@"typeid"];
		isFirstCondition = NO;
	}
	if (queryStatus!=nil) {
		if (!isFirstCondition) restURL = [restURL stringByAppendingString:@"&"];
		restURL = [restURL stringByAppendingString:@"status"];
		isFirstCondition = NO;
	}
	// Attach Condition content
	restURL = [restURL stringByAppendingString:@"/"];
	isFirstCondition = YES;
	if (queryCoord!=nil) {
		if (!isFirstCondition) restURL = [restURL stringByAppendingString:@"&"];
		restURL = [restURL stringByAppendingString:queryCoord];
		isFirstCondition = NO;
	}
	if (queryEmail!=nil) {
		if (!isFirstCondition) restURL = [restURL stringByAppendingString:@"&"];
		restURL = [restURL stringByAppendingString:queryEmail];
		isFirstCondition = NO;
	}
	if (queryTypes!=nil) {
		if (!isFirstCondition) restURL = [restURL stringByAppendingString:@"&"];
		restURL = [restURL stringByAppendingString:queryTypes];
		isFirstCondition = NO;
	}
	if (queryStatus!=nil) {
		if (!isFirstCondition) restURL = [restURL stringByAppendingString:@"&"];
		restURL = [restURL stringByAppendingString:queryStatus];
		isFirstCondition = NO;
	}
	// Set Range
	if (resultRange.length!=0) restURL = [NSString stringWithFormat:@"%@/%@/", restURL, [self convertNSRangeToString]];
	if (resultRange.length==0) restURL = [NSString stringWithFormat:@"%@/0/10000/", restURL];

	return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", queryBaseURL, restURL]];
}

+ (NSString *)generateMapQueryConditionFromRegion:(MKCoordinateRegion)mapRegion {
	return [NSString stringWithFormat:@"%f&%f&%f&%f", mapRegion.center.longitude, mapRegion.center.latitude, mapRegion.span.longitudeDelta/2.5, mapRegion.span.latitudeDelta/2.5];
}

+ (NSString *)generateORcombinedCondition:(NSArray *)ORconditions {
	NSString *result = @"";
	int conditionCount = [ORconditions count];
	NSEnumerator *enumerator = [ORconditions objectEnumerator];
	id eachCondition;
	while (eachCondition = [enumerator nextObject]) {
		result = [result stringByAppendingFormat:@"%@", eachCondition];
		if (--conditionCount) result = [result stringByAppendingString:@","];
	}
	return result;
}

#pragma mark -
#pragma mark Provider Lifecycle

+ (id)requestQuery {
	return [[[self alloc] init] autorelease];
}

- (id)init {
	if (self = [super init]) {
		queryBaseURL = @"http://ntu-ecoliving.appspot.com/";
		// Default is getting all data
		resultRange = NSRangeFromString(@"0, 0");
	}
	return self;
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
}

- (void)dealloc {
	[super dealloc];
	[indicatorTargetView release];
	[(id)resultTarget release];
}

@end
