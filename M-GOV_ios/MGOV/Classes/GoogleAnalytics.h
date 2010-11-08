/*
 * 
 * GoogleAnalytics.h
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

#import <Foundation/Foundation.h>
#import "GANTracker.h"

#define kGANEventAppLifecycle @"AppLifecycle"
#define kGANEventCaseAdder @"CaseAdderEvent"
#define kGANEventMyCase @"MyCaseEvent"
#define kGANEventQueryCase @"QueryCaseEvent"
#define kGANEventPrefernce @"OptionEvent"
#define kGANEventAppTab @"AppTabEvent"

typedef enum {
	// App Lifecycle
	GANActionAppDidFinishLaunch,
	GANActionAppDidEnterBackground,
	GANActionAppDidEnterForeground,
	GANActionAppWillTerminate,
	// App Tab Event
	GANActionAppTabIsMyCase,
	GANActionAppTabIsQueryCase,
	GANActionAppTabIsPreference,
	// Case Adder event
	GANActionAddCaseSuccess,
	GANActionAddCaseFailed,
	GANActionAddCaseWithName,
	GANActionAddCaseWithDescription,
	GANActionAddCaseWithPhoto,
	GANActionAddCaseWithoutPhoto,
	GANActionAddCaswWithType,
	GANActionAddCaseLocationSelectorChanged,
	// My Case Event
	GANActionMyCaseFilterAll,
	GANActionMyCaseFilterOK,
	GANActionMyCaseFilterUnknown,
	GANActionMyCaseFilterFailed,
	GANActionMyCaseMapMode,
	GANActionMyCaseListMode,
	// Query Case Event
	GANActionQueryCaseMapMode,
	GANActionQueryCaseListMode,
	GANActionQueryCaseAllType,
	GANActionQueryCaseWithType,
	// Preference Event
	GANActionPrefUserChangeEmail,
	GANActionPrefUserChangeName,
} GANAction;

@interface GoogleAnalytics : NSObject {
}

+ (void)trackAction:(GANAction)action withLabel:(NSString *)label andTimeStamp:(BOOL)ts andUDID:(BOOL)udid;

@end
