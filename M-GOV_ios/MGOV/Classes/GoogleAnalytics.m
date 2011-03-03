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

+ (void)trackAction:(GANAction)action withLabel:(NSString *)label andTimeStamp:(BOOL)ts andUDID:(BOOL)udid {
#ifndef DEBUG
	NSString *eventString = nil;
	NSString *actionString = nil;
	
	if (action==GANActionAppDidEnterBackground) {
		eventString = kGANEventAppLifecycle;
		actionString = @"AppEnterBackground";
	} else if (action==GANActionAppDidEnterForeground) {
		eventString = kGANEventAppLifecycle;
		actionString = @"AppEnterForeground";
	} else if (action==GANActionAppWillTerminate) {
		eventString = kGANEventAppLifecycle;
		actionString = @"AppWillTerminate";
	} else if (action==GANActionAppDidFinishLaunch) {
		eventString = kGANEventAppLifecycle;
		actionString = @"AppDidStartup";
	} else if (action==GANActionAddCaseSuccess) {
		eventString = kGANEventCaseAdder;
		actionString = @"AddCaseSuccess";
	} else if (action==GANActionAddCaseFailed) {
		eventString = kGANEventCaseAdder;
		actionString = @"AddCaseFailed";
	} else if (action==GANActionAddCaseWithPhoto) {
		eventString = kGANEventCaseAdder;
		actionString= @"AddCaseWithPhoto";
	} else if (action==GANActionAddCaseWithoutPhoto) {
		eventString = kGANEventCaseAdder;
		actionString= @"AddCaseWithoutPhoto";
	} else if (action==GANActionAddCaseWithName) {
		eventString = kGANEventCaseAdder;
		actionString = @"AddCaseWithName";
	} else if (action==GANActionAddCaseWithDescription) {
		eventString = kGANEventCaseAdder;
		actionString = @"AddCaseWithDescription";
	} else if (action==GANActionAddCaseWithType) {
		eventString = kGANEventCaseAdder;
		actionString = @"AddCaseWithType";
	} else if (action==GANActionAddCaseLocationSelectorChanged) {
		eventString = kGANEventCaseAdder;
		actionString = @"AddCaseWithLocationSelectorChanged";
	} else if (action==GANActionMyCaseFilterAll) {
		eventString = kGANEventMyCase;
		actionString = @"MyCaseWithAllFilter";
	} else if (action==GANActionMyCaseFilterOK) {
		eventString = kGANEventMyCase;
		actionString = @"MyCaseWithOKFilter";
	} else if (action==GANActionMyCaseFilterUnknown) {
		eventString = kGANEventMyCase;
		actionString = @"MyCaseWithUnknownFilter";
	} else if (action==GANActionMyCaseFilterFailed) {
		eventString = kGANEventMyCase;
		actionString = @"MyCaseWithFailedFilter";
	} else if (action==GANActionMyCaseListMode) {
		eventString = kGANEventMyCase;
		actionString = @"MyCaseWithListMode";
	} else if (action==GANActionMyCaseMapMode) {
		eventString = kGANEventMyCase;
		actionString = @"MyCaseWithMapMode";
	} else if (action==GANActionQueryCaseMapMode) {
		eventString = kGANEventQueryCase;
		actionString = @"QueryCaseWithMapMode";
	} else if (action==GANActionQueryCaseListMode) {
		eventString = kGANEventQueryCase;
		actionString = @"QueryCaseWithListMode";
	} else if (action==GANActionQueryCaseAllType) {
		eventString = kGANEventQueryCase;
		actionString = @"QueryCaseWithAllType";
	} else if (action==GANActionQueryCaseWithType) {
		eventString = kGANEventQueryCase;
		actionString = @"QueryCaseWithType";
	} else if (action==GANActionPrefUserChangeEmail) {
		eventString = kGANEventPrefernce;
		actionString = @"UserChangeEmail";
	} else if (action==GANActionPrefUserChangeName) {
		eventString = kGANEventPrefernce;
		actionString = @"UserChangeName";
	} else if (action==GANActionAppTabIsMyCase) {
		eventString = kGANEventAppTab;
		actionString = @"TabMyCase";
	} else if (action==GANActionAppTabIsQueryCase) {
		eventString = kGANEventAppTab;
		actionString = @"TabQueryCase";
	} else if (action==GANActionAppTabIsPreference) {
		eventString = kGANEventAppTab;
		actionString = @"TabOption";
	}
	
	if (eventString==nil || actionString==nil)
		return;
	
	NSString *labelString = [NSString stringWithFormat:@"[iOS][%@]", [[UIDevice currentDevice] systemVersion]];
	
	if ([[[[NSBundle mainBundle] infoDictionary] objectForKey:@"Develop Mode"] boolValue])
		labelString = [labelString stringByAppendingString:@"[Debug Mode]"];
	
	if (ts) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss ZZZZ"];
		NSString *timeStamp = [dateFormatter stringFromDate:[NSDate date]];
		[dateFormatter release];
		labelString = [labelString stringByAppendingFormat:@"[%@]", timeStamp];
	}
	
	if (udid)
		labelString = [labelString stringByAppendingFormat:@"[%@]", [[UIDevice currentDevice] uniqueIdentifier]];
	
	if (label!=nil)
		labelString = [labelString stringByAppendingFormat:@" %@", label];
    
	[[GANTracker sharedTracker] trackEvent:eventString action:actionString label:labelString value:-1 withError:nil];
	
	if ([[[[NSBundle mainBundle] infoDictionary] objectForKey:@"Develop Mode"] boolValue])
		NSLog(@"Google Analytics: %@ - %@", actionString, labelString);
#endif
}

@end
