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
	// check for internet connection
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
	
	internetReachable = [[Reachability reachabilityForInternetConnection] retain];
	[internetReachable startNotifier];
	
	// check if a pathway to a random host exists
	hostReachable = [[Reachability reachabilityWithHostName: @"www.apple.com"] retain];
	[hostReachable startNotifier];
	
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
	NSLog(@"%@", queryURL);
	
	// GO with ASIHttpRequest
	// TODO: ask for ggm: Fail return
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:queryURL];
	[request setDelegate:self];
	[request setTimeOutSeconds:60];
	[request startAsynchronous];
	return YES;
}

#pragma mark -
#pragma mark NetworkStatus

- (void) checkNetworkStatus:(NSNotification *)notice {
	// called after network status changes
	NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
	switch (internetStatus)
	{
		case NotReachable: 
		{
			NSLog(@"The internet is down.");
			if ([[PrefAccess readPrefByKey:@"NetworkIsAlerted"] boolValue] == NO) {
				UIAlertView *netowrkAlert = [[UIAlertView alloc] initWithTitle:@"沒有網路連線" message:@"無法讀取遠端資料庫資訊" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
				[netowrkAlert show];
				[netowrkAlert release];
				[PrefAccess writePrefByKey:@"NetworkIsAlerted" andObject:[NSNumber numberWithBool:YES]];
			}
			break;
		}
		case ReachableViaWiFi:
		{
			NSLog(@"The internet is working via WIFI.");
			if ([[PrefAccess readPrefByKey:@"NetworkIsAlerted"] boolValue] == YES) {
				[PrefAccess writePrefByKey:@"NetworkIsAlerted" andObject:[NSNumber numberWithBool:NO]];
			}
			break;
		}
		case ReachableViaWWAN:
		{
			NSLog(@"The internet is working via WWAN.");
			if ([[PrefAccess readPrefByKey:@"NetworkIsAlerted"] boolValue] == YES) {
				[PrefAccess writePrefByKey:@"NetworkIsAlerted" andObject:[NSNumber numberWithBool:NO]];
			}
			break;
		}
	}
	
	NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
	switch (hostStatus)
	
	{
		case NotReachable:
		{
			NSLog(@"A gateway to the host server is down.");
			break;
			
		}
		case ReachableViaWiFi:
		{
			NSLog(@"A gateway to the host server is working via WIFI.");
			break;
			
		}
		case ReachableViaWWAN:
		{
			NSLog(@"A gateway to the host server is working via WWAN.");
			break;
			
		}
	}
}


#pragma mark -
#pragma mark ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request {
	NSString *resultString = [request responseString];
	if ([resultString isEqualToString:@"<html><head>\n<meta http-equiv=\"content-type\" content=\"text/html;charset=utf-8\">\n<title>404 NOT_FOUND</title>\n</head>\n<body text=#000000 bgcolor=#ffffff>\n<h1>Error: NOT_FOUND</h1>\n</body></html>"]) {
		returnType = DataSourceGAEReturnNotFound;
		queryResult = nil;
	} else {
		queryResult = [[request responseString] JSONValue];
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
	[self autorelease];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	queryResult = nil;
	returnType = DataSourceGAEReturnTypeUnkonwn;
	[resultTarget recieveQueryResultType:returnType withResult:queryResult];
	[indicatorView finishedLoad];
	[indicatorView removeFromSuperview];
	[indicatorView release];
	[self autorelease];
}

#pragma mark -
#pragma mark Parse Query Conditions

- (NSString *)convertConditionTypeToString {
	if (conditionType == DataSourceGAEQueryByID) return @"get_id";
	else if (conditionType == DataSourceGAEQueryByType) return @"query/typeid";
	else if (conditionType == DataSourceGAEQueryByEmail) return @"case_queryemail";
	else if (conditionType == DataSourceGAEQueryByCoordinate) return @"query/coordinates";
	else if (conditionType == DataSourceGAEQueryByStatus) return @"query/status";
	
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
	
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", queryBaseURL, restURL]];
}

- (NSURL *)generateMultiConditionsURL {
	// NSDictionary to String
	NSString *queryEmail = [queryMultiConditions valueForKey:@"DataSourceGAEQueryByEmail"];
	NSString *queryCoord = [queryMultiConditions valueForKey:@"DataSourceGAEQueryByCoordinate"];
	NSString *queryTypes = [queryMultiConditions valueForKey:@"DataSourceGAEQueryByType"];
	NSString *queryStatus = [queryMultiConditions valueForKey:@"DataSourceGAEQueryByStatus"];
	
	NSString *restURL = @"query/";
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
	return [[self alloc] init];
}

- (id)init {
	if (self = [super init]) {
		queryBaseURL = @"http://ntu-ecoliving.appspot.com/ecoliving/";
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
	 [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
