/*
 * 
 * GoogleAnalytics.m
 * 2010/11/05
 * sodas
 *
 * Provide information for Google Analytics
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

#import "GoogleAnalytics.h"

@implementation GoogleAnalytics

+ (void)trackAction:(GANAction)action {
	NSString *eventString = nil;
	NSString *actionString = nil;
	
	if (action==GNAActionAppDidEnterBackground) {
		eventString = kAppLifecycle;
		actionString = @"AppEnterBackground";
	} else if (action==GNAActionAppDidEnterForeground) {
		eventString = kAppLifecycle;
		actionString = @"AppEnterForeground";
	} else if (action==GNAActionAppWillTerminate) {
		eventString = kAppLifecycle;
		actionString = @"AppWillTerminate";
	} else if (action==GNAActionAppDidFinishLaunch) {
		eventString = kAppLifecycle;
		actionString = @"AppDidStartup";
	}
	
	if (eventString==nil || actionString==nil)
		return;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss ZZZZ"];
	NSString *timeStamp = [dateFormatter stringFromDate:[NSDate date]];
	[dateFormatter release];
	
	NSString *labelString = [NSString stringWithFormat:@"[iOS][%@][%@]", [[UIDevice currentDevice] systemVersion], timeStamp];
	
	[[GANTracker sharedTracker] trackEvent:eventString action:actionString label:labelString value:-1 withError:nil];
}

@end
