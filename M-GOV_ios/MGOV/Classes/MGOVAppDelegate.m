/*
 * 
 * MGOVAppDelegate.h
 * 2010/8/24
 * shou
 * 
 * Application Delegate
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

#import "MGOVAppDelegate.h"

@implementation MGOVAppDelegate

@synthesize window, tabBarController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 
	// Setup Google Analytics
	[[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-19512059-3" dispatchPeriod:10 delegate:nil];
	// Record Event
	[GoogleAnalytics trackAction:GANActionAppDidFinishLaunch withLabel:nil andTimeStamp:NO andUDID:NO];
	
	// Set the locationManager be a global variable, and init
	MGOVGeocoder *shared = [MGOVGeocoder sharedVariable];
	CLLocationManager *locationManager = [[CLLocationManager alloc] init];
	shared.locationManager = locationManager;
	[locationManager release];
	[shared.locationManager startUpdatingLocation];
	
	// Generate Case Add temp file
	// Define File Path
	NSString *tempPlistPathInAppBundle = [[NSBundle mainBundle] pathForResource:@"CaseAddTempInformation" ofType:@"plist"];
	NSString *tempPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"CaseAddTempInformation.plist"];
	// Copy plist file
	if (![[NSFileManager defaultManager] fileExistsAtPath:tempPlistPathInAppDocuments]) 
		[[NSFileManager defaultManager] copyItemAtPath:tempPlistPathInAppBundle toPath:tempPlistPathInAppDocuments error:nil];
	
	// User Preference default value
	NSDictionary *defaultDict = [[NSDictionary alloc] initWithObjectsAndKeys:
								 @"", @"User Email",
								 @"", @"Name",
								 [NSNumber numberWithBool:NO], @"NetworkIsAlerted",
								 [NSDate date], @"TimeEnterBackground",
								 nil];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultDict];
	[defaultDict release];
	
	// Case Viewer
	CaseViewerViewController *caseViewer = [[CaseViewerViewController alloc] initWithStyle:UITableViewStyleGrouped];
	[caseViewer startToQueryCase];
	
	// My Case
	MyCaseViewController *myCase = [[MyCaseViewController alloc] initWithMode:HybridViewListMode andTitle:@"我的案件"];
	myCase.dataSource = myCase;
	myCase.selectorDelegate = myCase;
	myCase.childViewController = caseViewer;
	myCase.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"我的案件" image:[UIImage imageNamed:@"myCase.png"] tag:0] autorelease];
		
	// Query
	QueryViewController *queryCase = [[QueryViewController alloc] initWithMode:HybridViewMapMode andTitle:@"查詢案件"];
	queryCase.dataSource = queryCase;
	queryCase.selectorDelegate = queryCase;
	queryCase.childViewController = caseViewer;
	queryCase.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"查詢案件" image:[UIImage imageNamed:@"query.png"] tag:0] autorelease];
	
	// Preference
	PrefViewController *preference = [[PrefViewController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController *prefTab = [[UINavigationController alloc] initWithRootViewController:preference];
	preference.title = @"設定";
	prefTab.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"設定" image:[UIImage imageNamed:@"pref.png"] tag:0] autorelease];
	
	// Add tabs and view
	tabBarController = [[UITabBarController alloc] init];
	tabBarController.delegate = self;
	tabBarController.viewControllers = [NSArray arrayWithObjects:myCase, queryCase, prefTab, nil];
	
	// Set window property and show
	window.backgroundColor = [UIColor viewFlipsideBackgroundColor];
	[window addSubview:tabBarController.view];
	[window makeKeyAndVisible];
	
	// Release
	[myCase release];
	[queryCase release];
	[preference release];
	[prefTab release];
	[caseViewer release];
	
	return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Clean Tmp save
	NSString *tempPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"CaseAddTempInformation.plist"];
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:tempPlistPathInAppDocuments];
	[dict setObject:[NSData data] forKey:@"Photo"];
	[dict setObject:[NSNumber numberWithDouble:0.0] forKey:@"Latitude"];
	[dict setObject:[NSNumber numberWithDouble:0.0] forKey:@"Longitude"];
	[dict setValue:@"" forKey:@"Name"];
	[dict setValue:@"" forKey:@"Description"];
	[dict setValue:@"" forKey:@"TypeTitle"];
	[dict setObject:[NSNumber numberWithInt:0] forKey:@"TypeID"];
	[dict writeToFile:tempPlistPathInAppDocuments atomically:YES];
	// Reset network alert status
	[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"NetworkIsAlerted"];
	// Record Time Stamp
	[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"TimeEnterBackground"];
	// Record Event
	[GoogleAnalytics trackAction:GANActionAppDidEnterBackground withLabel:nil andTimeStamp:NO andUDID:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	[NetworkChecking checkNetwork];
	// Refesh views after coming back
	if (([[NSDate date] timeIntervalSince1970]-[[[NSUserDefaults standardUserDefaults] objectForKey:@"TimeEnterBackground"] timeIntervalSince1970])>10*60) {
		NSEnumerator *enumerator = [tabBarController.viewControllers objectEnumerator];
		id eachViewController;
		while (eachViewController = [enumerator nextObject])
			if([eachViewController isKindOfClass:[HybridViewController class]])
				if (![[eachViewController topViewController] isKindOfClass:[CaseAddViewController class]] && ![[eachViewController topViewController] isKindOfClass:[CaseViewerViewController class]])
					[eachViewController refreshDataSource];
	}
	// Record Event
	[GoogleAnalytics trackAction:GANActionAppDidEnterForeground withLabel:nil andTimeStamp:NO andUDID:NO];
}
	 
- (void)applicationWillTerminate:(UIApplication *)application {
	// RecordEvent
	[GoogleAnalytics trackAction:GANActionAppWillTerminate withLabel:nil andTimeStamp:NO andUDID:NO];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[[GANTracker sharedTracker] stopTracker];
	[tabBarController release];
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark TabBarController Delegate

- (BOOL)tabBarController:(UITabBarController *)aTabBarController shouldSelectViewController:(UIViewController *)viewController {
	if (![aTabBarController.selectedViewController isEqual:viewController]) {
		// Record View Controller
		if ([viewController isKindOfClass:[MyCaseViewController class]])
			[GoogleAnalytics trackAction:GANActionAppTabIsMyCase withLabel:nil andTimeStamp:NO andUDID:NO];
		else if ([viewController isKindOfClass:[QueryViewController class]])
			[GoogleAnalytics trackAction:GANActionAppTabIsQueryCase withLabel:nil andTimeStamp:NO andUDID:NO];
		else if ([viewController isKindOfClass:[UINavigationController class]])
			if ([[(UINavigationController *)viewController topViewController] isKindOfClass:[PrefViewController class]])
				[GoogleAnalytics trackAction:GANActionAppTabIsPreference withLabel:nil andTimeStamp:NO andUDID:NO];
	}
	return YES;
}

- (void)tabBarController:(UITabBarController *)aTabBarController didSelectViewController:(UIViewController *)viewController {
	// Pop Case Viewer out if going to back
	NSEnumerator *enumerator =  [aTabBarController.viewControllers objectEnumerator];
	id eachViewController;
	while (eachViewController = [enumerator nextObject])
		if ( [eachViewController isKindOfClass:[CaseSelectorViewController class]] && ![eachViewController isEqual:viewController] )
			if ([[eachViewController topViewController] isKindOfClass:[CaseViewerViewController class]])
				[eachViewController popViewControllerAnimated:NO];
}

@end
