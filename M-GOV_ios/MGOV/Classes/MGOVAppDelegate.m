//
//  MGOVAppDelegate.m
//  MGOV
//
//  Created by Shou 2010/8/24.
//  Copyright NTU Mobile HCI Lab 2010. All rights reserved.
//

#import "MGOVAppDelegate.h"

@implementation MGOVAppDelegate

@synthesize window, tabBarController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 
	
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
	
	[PrefAccess copyEmptyPrefPlistToDocumentsByRecover:NO];
	
	// My Case
	MyCaseViewController *myCase = [[MyCaseViewController alloc] initWithMode:HybridViewListMode andTitle:@"我的案件"];
	myCase.dataSource = myCase;
	myCase.selectorDelegate = myCase;
	myCase.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"我的案件" image:[UIImage imageNamed:@"myCase.png"] tag:0] autorelease];
		
	// Query
	QueryViewController *queryCase = [[QueryViewController alloc] initWithMode:HybridViewMapMode andTitle:@"查詢案件"];
	queryCase.dataSource = queryCase;
	queryCase.selectorDelegate = queryCase;
	queryCase.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"查詢案件" image:[UIImage imageNamed:@"query.png"] tag:0] autorelease];
	
	// Preference
	PrefViewController *preference = [[PrefViewController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController *prefTab = [[UINavigationController alloc] initWithRootViewController:preference];
	preference.title = @"設定";
	prefTab.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"設定" image:[UIImage imageNamed:@"pref.png"] tag:0] autorelease];
	
	// Add tabs and view
	tabBarController = [[UITabBarController alloc] init];
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Refesh views after coming back
	NSEnumerator *enumerator = [tabBarController.viewControllers objectEnumerator];
	id eachViewController;
	while (eachViewController = [enumerator nextObject])
		if([eachViewController isKindOfClass:[HybridViewController class]])
			if (![[eachViewController topViewController] isKindOfClass:[CaseAddViewController class]] && ![[eachViewController topViewController] isKindOfClass:[CaseViewerViewController class]])
				[eachViewController refreshDataSource];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
}

- (void)dealloc {
	[tabBarController release];
    [window release];
    [super dealloc];
}

@end
