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
	[[self class] trackAction:action withLabel:nil andTimeStamp:NO];
}

+ (void)trackAction:(GANAction)action withTimeStamp:(BOOL)ts {
	[[self class] trackAction:action withLabel:nil andTimeStamp:ts];
}

+ (void)trackAction:(GANAction)action withLabel:(NSString *)label {
	[[self class] trackAction:action withLabel:label andTimeStamp:NO];
}

+ (void)trackAction:(GANAction)action withLabel:(NSString *)label andTimeStamp:(BOOL)ts {
	NSString *eventString = nil;
	NSString *actionString = nil;
	
	if (action==GANActionAppDidEnterBackground) {
		eventString = kAppLifecycle;
		actionString = @"AppEnterBackground";
	} else if (action==GANActionAppDidEnterForeground) {
		eventString = kAppLifecycle;
		actionString = @"AppEnterForeground";
	} else if (action==GANActionAppWillTerminate) {
		eventString = kAppLifecycle;
		actionString = @"AppWillTerminate";
	} else if (action==GANActionAppDidFinishLaunch) {
		eventString = kAppLifecycle;
		actionString = @"AppDidStartup";
	} else if (action==GANActionAddCaseSuccess) {
		eventString = kCaseAdder;
		actionString = @"AddCaseScuess";
	} else if (action==GANActionAddCaseFailed) {
		eventString = kCaseAdder;
		actionString = @"AddCaseFailed";
	} else if (action==GANActionAddCaseWithPhoto) {
		eventString = kCaseAdder;
		actionString= @"AddCaseWithPhoto";
	} else if (action==GANActionAddCaseWithoutPhoto) {
		eventString = kCaseAdder;
		actionString= @"AddCaseWithoutPhoto";
	} else if (action==GANActionAddCaseWithName) {
		eventString = kCaseAdder;
		actionString = @"AddCaseWithName";
	} else if (action==GANActionAddCaseWithDescription) {
		eventString = kCaseAdder;
		actionString = @"AddCaseWithDescription";
	} else if (action==GANActionAddCaswWithType) {
		eventString = kCaseAdder;
		actionString = @"AddCaseWithType";
	} else if (action==GANActionAddCaseLocationSelectorChanged) {
		eventString = kCaseAdder;
		actionString = @"AddCaseWithLocationSelectorChanged";
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
	
	if (label!=nil)
		labelString = [labelString stringByAppendingFormat:@" %@", label];
	
	[[GANTracker sharedTracker] trackEvent:eventString action:actionString label:labelString value:-1 withError:nil];
	
	if ([[[[NSBundle mainBundle] infoDictionary] objectForKey:@"Develop Mode"] boolValue])
		NSLog(@"Google Analytics: %@ - %@", actionString, labelString);
}

@end
