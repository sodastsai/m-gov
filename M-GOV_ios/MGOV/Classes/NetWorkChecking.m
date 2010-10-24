/*
 * 
 * NetworkChecking.m
 * 2010/10/4
 * shou
 * 
 * Check Network availibility
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

#import "NetworkChecking.h"


@implementation NetworkChecking

#pragma mark -
#pragma mark NetworkStatus

+ (BOOL) checkNetwork {
	
	Reachability* internetReachable;
	BOOL networkCheck = NO;
	
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
