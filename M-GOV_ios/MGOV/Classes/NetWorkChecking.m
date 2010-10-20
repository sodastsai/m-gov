//
//  NetworkChecking.m
//  MGOV
//
//  Created by shou on 2010/10/4.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "NetworkChecking.h"


@implementation NetworkChecking

#pragma mark -
#pragma mark NetworkStatus

+ (BOOL) checkNetwork {
	
	Reachability* internetReachable;
	BOOL networkCheck;
	
	internetReachable = [Reachability reachabilityForInternetConnection];
	NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
	switch (internetStatus) {
		case NotReachable:
			networkCheck = NO;
			if ([[PrefAccess readPrefByKey:@"NetworkIsAlerted"] boolValue] == NO) {
				UIAlertView *netowrkAlert = [[UIAlertView alloc] initWithTitle:@"沒有網路連線" message:@"無法查詢案件資料" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
				[netowrkAlert show];
				[netowrkAlert release];
				[PrefAccess writePrefByKey:@"NetworkIsAlerted" andObject:[NSNumber numberWithBool:YES]];
			}
			break;
		case ReachableViaWiFi:
			networkCheck = YES;
			if ([[PrefAccess readPrefByKey:@"NetworkIsAlerted"] boolValue] == YES)
				[PrefAccess writePrefByKey:@"NetworkIsAlerted" andObject:[NSNumber numberWithBool:NO]];
			break;
		case ReachableViaWWAN:
			networkCheck = YES;
			if ([[PrefAccess readPrefByKey:@"NetworkIsAlerted"] boolValue] == YES)
				[PrefAccess writePrefByKey:@"NetworkIsAlerted" andObject:[NSNumber numberWithBool:NO]];
			break;
	}
	return networkCheck;
}

@end
