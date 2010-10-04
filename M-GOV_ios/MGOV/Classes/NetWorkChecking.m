//
//  NetWorkChecking.m
//  MGOV
//
//  Created by shou on 2010/10/4.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "NetWorkChecking.h"


@implementation NetWorkChecking

#pragma mark -
#pragma mark NetworkStatus

+ (BOOL) checkNetwork {
	
	Reachability* internetReachable;
	BOOL networkCheck;
	
	// check for internet connection
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
	
	internetReachable = [Reachability reachabilityForInternetConnection];
	NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
	switch (internetStatus)
	{
		case NotReachable: 
		{
			networkCheck = NO;
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
			networkCheck = YES;
			if ([[PrefAccess readPrefByKey:@"NetworkIsAlerted"] boolValue] == YES) {
				[PrefAccess writePrefByKey:@"NetworkIsAlerted" andObject:[NSNumber numberWithBool:NO]];
			}
			break;
		}
		case ReachableViaWWAN:
		{
			networkCheck = YES;
			if ([[PrefAccess readPrefByKey:@"NetworkIsAlerted"] boolValue] == YES) {
				[PrefAccess writePrefByKey:@"NetworkIsAlerted" andObject:[NSNumber numberWithBool:NO]];
			}
			break;
		}
	}
	return networkCheck;
}

/*
- (void) checkNetworkStatus:(NSNotification *)notice {
	// called after network status changes
	
	NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
	switch (internetStatus)
	{
		case NotReachable: 
		{
			self.networkCheck = NO;
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
			self.networkCheck = YES;
			if ([[PrefAccess readPrefByKey:@"NetworkIsAlerted"] boolValue] == YES) {
				[PrefAccess writePrefByKey:@"NetworkIsAlerted" andObject:[NSNumber numberWithBool:NO]];
			}
			break;
		}
		case ReachableViaWWAN:
		{
			self.networkCheck = YES;
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
*/

@end
